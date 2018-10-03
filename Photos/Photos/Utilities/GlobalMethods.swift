//
//  GlobalMethods.swift
//  Photos
//
//  Created by Kiran kumar on 03/10/18.
//  Copyright © 2018 Kiran kumar. All rights reserved.
//

import UIKit

class GlobalMethods: NSObject {

    class func currentTimeMillis() -> String{
        let nowDouble = Date().timeIntervalSince1970
        return String(nowDouble*1000)
    }
    
    class func getImageForName(name: String) -> String
    {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory = paths[0]
        var dataPath = documentsDirectory.appending("/MyPhotos/")
        dataPath.append(name)
        return dataPath
    }
}
