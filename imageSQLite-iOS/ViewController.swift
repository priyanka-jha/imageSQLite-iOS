//
//  ViewController.swift
//  imageSQLite-iOS
//
//  Created by Priyanka Jha on 12/12/18.
//  Copyright © 2018 Priyanka Jha. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
   
    var imagepickerController: UIImagePickerController!
    var imageView: UIImage? = nil
    var imageName = "", imageDetails = "", imageValue = ""
    var imageSource = ""
    var GetListData = NSMutableArray()
    var databasePath = String()
    var listid = "", imageid = 0
    
   

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return GetListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableCell") as! ImageTableCell
        
        var listModel = ListModel()
        listModel = GetListData.object(at: indexPath.row) as! ListModel
        
        let id:Int = listModel.Id
        let id1 :String = String(id)
        
        cell.idLabel.text = id1
        cell.imageName.text! = listModel.Name
        cell.imageValue.text! = listModel.Value
        cell.imageDetails.text! = listModel.Details
        
        let imageData = listModel.Value
        let dataDecoded:Data = Data(base64Encoded: imageData, options: .ignoreUnknownCharacters)!
        let decodedimage = UIImage(data: dataDecoded)
        
        cell.listImage.image = decodedimage
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        GetListData = self.loadData()
        tableView.reloadData()
      }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = CGFloat()
        height = 102
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! ImageTableCell
        currentCell.selectionStyle = .none
        
        listid = currentCell.idLabel.text!
        imageid = Int(listid)!
        
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let DV = MainStoryboard.instantiateViewController(withIdentifier: "ViewImage") as! ViewImage
        DV.imageid = self.imageid
        self.navigationController?.pushViewController(DV, animated: true)
    }
   
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //create database
        let dbmanager = DatabaseManager()
        dbmanager.createdatabase()
        
        let filemgr = FileManager.default
        let dirPaths = filemgr.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        databasePath = dirPaths[0].appendingPathComponent("image.sqlite").path
        let count = DatabaseManager.getInstance().GetCount(tablename: "image")
        if count == 0 {
            tableView.isHidden = true
        }
        else {
            tableView.isHidden = false
        }
        
        
        
    }


    @IBAction func selectImage(_ sender: UIBarButtonItem) {
       
        let alertcontroller:UIAlertController = UIAlertController(title: "Image source", message: "Choose the source", preferredStyle: .alert)
      
        alertcontroller.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            
            self.clickImage()
            
        }))
        
        alertcontroller.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            
            self.browseGallery()
       
        }))
        
        alertcontroller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        

        self.present(alertcontroller, animated: true, completion: nil)
    }

    //click image using camera
    func clickImage() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagepickerController = UIImagePickerController()
            imagepickerController.delegate = self
            imagepickerController.sourceType = .camera
            imagepickerController.allowsEditing = false
            present(imagepickerController, animated: true, completion: nil)
            
        }
        else {
            print("Camera not available")
        }
    }
    
    //browse image from gallery
    func browseGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagepickerController =  UIImagePickerController()
            imagepickerController.delegate = self
            imagepickerController.sourceType = .photoLibrary
            imagepickerController.allowsEditing = false
            present(imagepickerController, animated: true, completion: nil)
            
        }
        else {
            print("Photo Library is not accessible")
        }
    }
    
    //save image in database or gallery
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Error selecting image: \(info)")
        }
        imageView = selectedImage
        
        //saveInGallery()
        saveInDatabase()
       
        //Check the source of image
        if picker.sourceType == .camera {
            imageSource = "Camera"
          //saveInGallery()
         // saveInDatabase()
            
        }
        else {
            imageSource = "Gallery"
           // saveInDatabase()
            
        }
   
        imagepickerController.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagepickerController.dismiss(animated: true, completion: nil)
    }
    

   
   
    //save image in photo library
    func saveInGallery() {
        
        let imageData = imageView!.jpegData(compressionQuality: 0.6)

         let compressedJPGImage = UIImage(data: imageData!)
         UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
         
         let alert = UIAlertController(title: "Image saved", message: "Image has been saved to Photo Library!", preferredStyle: UIAlertController.Style.alert)
         
         alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
         
         self.present(alert, animated: true, completion: nil)
        
    }
    
    //save image in database
    func saveInDatabase() {
        
        let image : UIImage = imageView!

        let imageData:NSData = image.pngData()! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        
        let maxid = DatabaseManager.getInstance().GetMaxId(tablename: "image")

        imageName = "Image"+String(maxid+1)
        
        if imageSource == "Camera" {
             imageDetails = "Clicked Image"
        }
        else {
             imageDetails = "Attached Image"

        }
         imageValue = strBase64
        
        let imageDB = FMDatabase(path: databasePath as String)
        if (imageDB.open()) {
            
            let insertSQL = "INSERT INTO image (name, imagevalue, imagedetails) VALUES ('\(imageName)', '\(imageValue)', '\(imageDetails)')"
            
            
            let result = imageDB.executeUpdate(insertSQL,
                                                 withArgumentsIn: [])
            
            print("image submitted")
            
           
            
            if !result {
                print("Error: \(imageDB.lastErrorMessage())")
            }
        }
        else  {
            print("Error: \(imageDB.lastErrorMessage())")
        }
        
        tableView.isHidden = false

        ////// load data into tableview
        self.GetListData = self.loadData()

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }

    func loadData() -> NSMutableArray {
        
        let listData:NSMutableArray = NSMutableArray ()
        let filemgr = FileManager.default
        let dirPaths = filemgr.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        databasePath = dirPaths[0].appendingPathComponent("image.sqlite").path
        
        let imageDB = FMDatabase(path: databasePath as String)
        
        
        if (imageDB.open()) {
            let querySQL = "SELECT * from image ;"
            
            let results:FMResultSet! = imageDB.executeQuery(querySQL,
                                                              withArgumentsIn: [])
            
            if (results != nil)
            {
                
              while (results.next()) {
                    let list:ListModel = ListModel()
                    list.Id = Int(results.int(forColumnIndex: 0))
                    list.Name = String(results.string(forColumnIndex: 1)!)
                    list.Value = String(results.string(forColumnIndex: 2)!)
                    list.Details = String(results.string(forColumnIndex: 3)!)
                   
                    listData.add(list)
                    
              }
                
            }
            imageDB.close()
            
        } else {
            print("Error7: \(imageDB.lastErrorMessage())")
        }
        
        
        return listData
        
        
    }
    

    
}

