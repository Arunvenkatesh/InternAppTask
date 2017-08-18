import UIKit
import SQLite
import Foundation

class CreateEventVC: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    
    var imagesDirectoryPath:String!
    var Eventsc = [Events]()
    
    var database: Connection!
    let usersTable = Table("EventLL")
    let id = Expression<Int>("id")
    let titl = Expression<String>("title")
    let desc = Expression<String>("desc")
    let cate = Expression<String>("cate")
    let imageP = Expression<String>("ImagePath")
    
    
     var isClicked = true
    var etitle: String?
    var edescription: String?
    var ecat: String?
    var imagePathr = NSDate().description
    
    
    @IBOutlet weak var eventtitle: UITextField!
    
    @IBOutlet weak var imageUpload: UIImageView!
    
    @IBOutlet weak var eventdescription: UITextField!
    
    
    @IBOutlet weak var category: UITextField!
    
    
    @IBOutlet weak var eventSubmitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do{
            let document = try  FileManager.default.url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = document.appendingPathComponent("users").appendingPathExtension("sqlite3")
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            // Get the Document directory path
            let documentDirectorPath:String = paths[0]
            // Create a new path for the new images folder
            imagesDirectoryPath = documentDirectorPath.appending("/ImagePicker")
            var objcBool:ObjCBool = true
            let isExist = FileManager.default.fileExists(atPath: imagesDirectoryPath, isDirectory: &objcBool)
            // If the folder with the given path doesn't exist already, create it
            if isExist == false{
                do{
                    try FileManager.default.createDirectory(atPath: imagesDirectoryPath, withIntermediateDirectories: true, attributes: nil)
                }catch{
                    print("Something went wrong while creating a new folder")
                }
            }
            
            let database = try Connection(fileURL.path)
            self.database = database
        }catch{
            print(error)
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageuploading))
        imageUpload.addGestureRecognizer(tapGestureRecognizer)
        imageUpload.isUserInteractionEnabled = true
    }
    
    
    func createTableEvent()
    {
        print("table created printed")
        let createTable = self.usersTable.create { (table) in
            table.column(self.titl)
            table.column(self.desc)
            table.column(self.cate)
            table.column(self.imageP)
        }
        do
        {
            try self.database.run(createTable)
            print("Table is created successfully..!")
        }catch{
            print(error)
            print("the errror is in creating table ====  ==== ==== =")
        }
    }
    
    func imageuploading()
    {
        
        print("image tapped")
        
        let imagePC = UIImagePickerController()
        imagePC.delegate = self
        imagePC.allowsEditing = false
        let actionsheet = UIAlertController(title: "Photo Source", message: "Choose a Source", preferredStyle: .actionSheet)
        actionsheet.addAction(UIAlertAction(title: "camera", style: .default, handler: {(action: UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera)
            {
                imagePC.sourceType = UIImagePickerControllerSourceType.camera
                self.present(imagePC,animated: true,completion: nil)}
                
            else
            {
                print("cannot open Camera")
                let actionshe = UIAlertController(title: "Camera Not Available", message: "Please use real device", preferredStyle: .alert)
                actionshe.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(actionshe,animated: true,completion: nil)
                
            }
        }
        ))
        actionsheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action: UIAlertAction) in
            imagePC.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imagePC,animated: true,completion: nil)}))
        
        
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(actionsheet,animated: true,completion: nil)
    }
    
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imageRecieved = info[UIImagePickerControllerOriginalImage] as?  UIImage {
            imageUpload.image = imageRecieved
            imagePathr = imagePathr.replacingOccurrences(of: " ", with: "")
            imagePathr = imagesDirectoryPath.appending("/\(imagePathr).png")
            let data = UIImagePNGRepresentation(imageRecieved)
            let success = FileManager.default.createFile(atPath: imagePathr, contents: data, attributes: nil)
            print(success)
            print("imagePath+++\(imagePathr)=====")
            
        }
        else{
            print("Error in uploading image")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    @IBAction func eventSubmitClicked(_ sender: Any) {
       
        if isClicked{
            createTableEvent()
            isClicked = false
        }
        etitle = eventtitle.text
        edescription = eventdescription.text
        ecat = category.text
        
        let inserEvent = self.usersTable.insert(self.titl <- etitle!,self.desc <- edescription!,self.cate <- ecat!,self.imageP <- imagePathr
            
            
        )
        
        do{
            
            try self.database.run(inserEvent)
            print("Inserted Row")
        }catch{
            print(error)
            print("Error in inserting the data")
        }
        displayTable()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        self.present(nextViewController, animated:true, completion:nil)
        
        
        
    }
    func displayTable()
    {
        do{
            let users = try self.database.prepare(self.usersTable)
            for user in users
            {
                print(" Title: \(user[self.titl]) description: \(user[self.desc])Category: \(user[self.cate]) imagePath\(self.imageP)")
            }
        }catch{
            print(error)
            print("Error in displaying data")
        }
    }
    
    
    
}
