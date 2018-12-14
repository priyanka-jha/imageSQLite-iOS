//
//  DatabaseManager.swift
//  imageSQLite-iOS
//
//  Created by Priyanka Jha on 12/12/18.
//  Copyright © 2018 Priyanka Jha. All rights reserved.
//

import Foundation
import  UIKit

let sharedInstance = DatabaseManager()

class DatabaseManager: NSObject {
    
    var databasePath = String()
    var database:FMDatabase? = nil
    
    class func getInstance() -> DatabaseManager
    {
        if (sharedInstance.database == nil)
        {
            sharedInstance.database = FMDatabase(path: Util.getPath(fileName: "image.sqlite"))
            
        }
        return sharedInstance
    }
    
    
    func createdatabase() {
        
        let filemgr = FileManager.default
        
        let dirPaths = filemgr.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        
        databasePath = dirPaths[0].appendingPathComponent("image.sqlite").path
        
        
        if !filemgr.fileExists(atPath: databasePath as String) {
            
            let imageDB = FMDatabase(path: databasePath as String)
            
            if imageDB == nil {
                print("Error: \(imageDB.lastErrorMessage())")
            }
            
            if (imageDB.open()) {
                let sql_stmt = "CREATE TABLE IF NOT EXISTS image (id INTEGER PRIMARY KEY, name TEXT, imagevalue TEXT, imagedetails TEXT)"
                
                print("database created")
                print("image table created")
                
                if !(imageDB.executeStatements(sql_stmt)) {
                    print("Error: \(imageDB.lastErrorMessage())")
                }
                
             
                
                
                imageDB.close()
            } else {
                print("Error: \(imageDB.lastErrorMessage())")
            }
            
            
        }
        
    }
    
    
    //Get count
    
    func GetCount(tablename:String) -> Int {
        sharedInstance.database!.open()
        
        
        let resultSet:FMResultSet! = sharedInstance.database!.executeQuery("SELECT count(*) FROM '\(tablename)' ; ", withArgumentsIn: [0])
        
        var count:Int   = Int()
        if(resultSet != nil)
        {
            
            while resultSet.next() {
                
                count = Int(resultSet.int(forColumnIndex: 0))
                
            }
            
            
        }
        
        sharedInstance.database!.close()
        return count
        
        
    }
    
    //Get Max id
    
    func GetMaxId(tablename:String) -> Int {
        sharedInstance.database!.open()
        
        
        let resultSet:FMResultSet! = sharedInstance.database!.executeQuery("SELECT max(id) FROM '\(tablename)' ; ", withArgumentsIn: [0])
        
        var count:Int   = Int()
        if(resultSet != nil)
        {
            
            while resultSet.next() {
                
                count = Int(resultSet.int(forColumnIndex: 0))
                
            }
            
            
        }
        
        sharedInstance.database!.close()
        return count
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
