import Foundation

import SQLite

class eventDBMS {
    
    private let eventTable = Table("contacts")
    private let id = Expression<Int64>("id")
   private let titl = Expression<String>("title")
   private let desc = Expression<String>("desc")
  private  let cate = Expression<String>("cate")
    let usersTable = Table("Event")

    static let instance = eventDBMS()
    private let db: Connection?
    
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            db = try Connection("\(path)/Stephencelis.sqlite3")
            createTable()
        } catch {
            db = nil
            print ("Unable to open database")
        }
    }
    
    func createTable() {
        do {
            try db!.run(self.usersTable.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(titl)
                table.column(desc)
                table.column(cate)
            })
        } catch {
            print("Unable to create table")
            print(error)
        }
    }
    
    func addEventst(ctitle: String, cdesc: String, ccate: String) -> Int64? {
        do {
            let insert = eventTable.insert(titl <- ctitle, desc <- cdesc, cate <- ccate)
            let id = try db!.run(insert)
            
            return id
        } catch {
            print("Insert failed")
            return nil
        }
    }
    
    func getEvents() -> [Events] {
        var cEvents = [Events]()
        
        do {
            for contact in try db!.prepare(self.eventTable) {
                cEvents.append(Events(title: contact[titl], description: contact[desc], Category: contact[cate], imageE: "hello"))
            }}
        catch {
            print("Select failed")
            print(error)
        }
        
        return cEvents
    }
    
}
