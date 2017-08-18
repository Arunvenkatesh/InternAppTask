import UIKit
import SQLite
import Foundation

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    var database: Connection!
    let usersTable = Table("EventLL")
    var eventsCollection = [Events]()
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var leadingCons:
    NSLayoutConstraint!
    var isClicked = true
    
    var ntitl = Expression<String>("title")
    var ndesc = Expression<String>("desc")
    var ncate = Expression<String>("cate")
    var nimage = Expression<String>("ImagePath")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventTableView.reloadData()
        do {
            let document = try  FileManager.default.url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = document.appendingPathComponent("users").appendingPathExtension("sqlite3")
        let database = try Connection(fileURL.path)
        self.database = database
    }catch{
    print(error)
    }
    

     }


    @IBOutlet weak var eventTableView: UITableView!
    @IBOutlet weak var leadconst: NSLayoutConstraint!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell")!
             //let imageV =  cell.viewWithTag(4) as! UIImageView
        do{
            let users = try self.database.prepare(self.usersTable)
            
            for user in users
            {
            
              
                print(" Title: \(user[ntitl]) description: \(user[ndesc])Category: \(user[ncate])")
                let titleLabel = cell.viewWithTag(1) as! UILabel
                let descLabel = cell.viewWithTag(2) as! UILabel
                let catLabel = cell.viewWithTag(3) as! UILabel
                titleLabel.text = user[ntitl]
                descLabel.text = user[ndesc]
                catLabel.text = user[ncate]
                
            }
            }catch{
            print(error)
            print("Error in displaying data in Table")
        }

       
        return cell
        
    }

    
    
    
    
    
    
    
    
    

    @IBAction func menuButtonClicked(_ sender: UIButton) {
        
        if isClicked{
            leadconst.constant = 0
            print("button is clicked")
            isClicked = false
            menuButton.setImage(#imageLiteral(resourceName: "menuclos"), for: .normal)
            menuButton.backgroundColor = .black
            
        }
        else
        {
            
            leadconst.constant = -250
            isClicked = true
            print("button is not clicked")
            menuButton.backgroundColor = .clear
            menuButton.setImage(#imageLiteral(resourceName: "menuopen"), for: .normal)
            
        }
        
        
        
        
    }
}

