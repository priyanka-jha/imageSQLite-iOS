//
//  ViewImage.swift
//  imageSQLite-iOS
//
//  Created by Priyanka Jha on 12/12/18.
//  Copyright © 2018 Priyanka Jha. All rights reserved.
//

import UIKit

class ViewImage: UIViewController {
 
    @IBOutlet weak var imageView: UIImageView!
   
    var databasePath = String()
    var imageid = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    // Do any additional setup after loading the view.
        
        let filemgr = FileManager.default
        let dirPaths = filemgr.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        databasePath = dirPaths[0].appendingPathComponent("image.sqlite").path
        let imageDB = FMDatabase(path: databasePath as String)
        
        if (imageDB.open()) {
            
         
            let querySQL = "SELECT * FROM image WHERE  id= '\(imageid)' ;"
            let results:FMResultSet? = imageDB.executeQuery(querySQL,
                                                              withArgumentsIn: [])
            
            if results?.next() == true {
            let imageValue = (results?.string(forColumn: "imagevalue"))!
            let dataDecoded:Data = Data(base64Encoded: imageValue, options: .ignoreUnknownCharacters)!
            let decodedimage = UIImage(data: dataDecoded)
            imageView.image = decodedimage
            }
            else {
                
                print("Details1111 not found")
                
                
            }
            imageDB.close()
        } else {
            print("Error: \(imageDB.lastErrorMessage())")
        }
        
        
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        
        
        
    }
    
    @IBAction func deleteImage(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Confirm Delete...", message: "Are you sure you want to delete this image?", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
            
            let imageDB = FMDatabase(path: self.databasePath as String)
            
            if (imageDB.open()) {
                let delSQL1 = "DELETE FROM image WHERE id= '\(self.imageid)' ;"
                let result1 = imageDB.executeUpdate(delSQL1,withArgumentsIn: [])
                print("image deleted")
                
                imageDB.close()
                
                let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                let DV = MainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                
                self.navigationController?.pushViewController(DV, animated: true)
                
            } else {
                print("Error9: \(imageDB.lastErrorMessage())")
            }
            
            
        }
        ))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
