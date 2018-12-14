//
//  Util.swift
//  imageSQLite-iOS
//
//  Created by Priyanka Jha on 12/12/18.
//  Copyright © 2018 Priyanka Jha. All rights reserved.
//

import Foundation
class Util: NSObject {
    
    class func getPath(fileName: String) -> String {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        print(fileURL)
        return fileURL.path
    }
}
