//
//  ImageExtensions.swift
//  Photos
//
//  Created by Kiran kumar on 03/10/18.
//  Copyright © 2018 Kiran kumar. All rights reserved.
//

import Foundation
import UIKit

extension UIImage
{
    func save(_ fileName: String, type: String) {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory = paths[0]
        let dataPath = documentsDirectory.appending("/MyPhotos")
        do {
            if FileManager.default.fileExists(atPath: dataPath)
            {
                
            }
            else
            {
                try FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: false, attributes: nil)
            }
        } catch let error as NSError {
            print(error.localizedDescription);
        }
        
        if type.lowercased() == "png" {
            let path = "\(dataPath)/\(fileName).\(type)"
            try? UIImagePNGRepresentation(self)!.write(to: URL(fileURLWithPath: path), options: [.atomic])
            print("Prescription image Path" ,path)
            
        } else if type.lowercased() == "jpg" {
            let path = "\(dataPath)/\(fileName).\(type)"
            try? UIImageJPEGRepresentation(self, 0.0)!.write(to: URL(fileURLWithPath: path), options: [.atomic])
            print("Prescription image Path" ,path)
        } else {            
        }
    }

}
