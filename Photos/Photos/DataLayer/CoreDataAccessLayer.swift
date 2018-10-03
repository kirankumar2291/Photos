//
//  CoreDataAccessLayer.swift
//  Photos
//
//  Created by Kiran kumar on 03/10/18.
//  Copyright © 2018 Kiran kumar. All rights reserved.
//

import UIKit
import CoreData

class CoreDataAccessLayer: NSObject {


    //    MARK: - Insertion Methods
    
    class func insertPhoto(photo: PhotosObject)
    {
        let arrPhotoExists = checkIfPhototExistsWithName(name: photo.imageName, inEntity: "Photos")
        if arrPhotoExists != nil
        {
            let photoModel = arrPhotoExists![0] as? Photos
            photoModel?.isFavoriteImage = photo.isFavoriteImage
            photoModel?.isImageDeleted = photo.isImageDeleted
        }
        else
        {
            let phot = Photos(context: context)
            phot.imageName = photo.imageName
            phot.isFavoriteImage = photo.isFavoriteImage
            phot.isImageDeleted = photo.isImageDeleted
        }
        do {
            try context.save()
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }

    //    MARK: - Updation Methods
    
    class func favoritePhoto(photo: Photos)
    {
        let arrPhotoExists = checkIfPhototExistsWithName(name: photo.imageName!, inEntity: "Photos")
        if arrPhotoExists != nil
        {
            let photoModel = arrPhotoExists![0] as? Photos
            photoModel?.isFavoriteImage = true
        }
        do {
            try context.save()
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }

    class func unFavoritePhoto(photo: Photos)
    {
        let arrPhotoExists = checkIfPhototExistsWithName(name: photo.imageName!, inEntity: "Photos")
        if arrPhotoExists != nil
        {
            let photoModel = arrPhotoExists![0] as? Photos
            photoModel?.isFavoriteImage = false
        }
        do {
            try context.save()
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    class func isPhotoFavorite(photo: Photos) -> Bool
    {
        let arrPhotoExists = checkIfPhototExistsWithName(name: photo.imageName!, inEntity: "Photos")
        if arrPhotoExists != nil
        {
            let photoModel = arrPhotoExists![0] as? Photos
            return (photoModel?.isFavoriteImage)!
        }
        else
        {
            return false
        }
    }
    
    class func deleteMultiplePhotos(arrPhotos: [Photos])
    {
        for object in arrPhotos
        {
            let arrPhotoExists = checkIfPhototExistsWithName(name: object.imageName!, inEntity: "Photos")
            if arrPhotoExists != nil
            {
                let photoModel = arrPhotoExists![0] as? Photos
                photoModel?.isImageDeleted = true
            }
            do {
                try context.save()
                
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }

    class func recoverMultiple(arrPhotos: [Photos])
    {
        for object in arrPhotos
        {
            let arrPhotoExists = checkIfPhototExistsWithName(name: object.imageName!, inEntity: "Photos")
            if arrPhotoExists != nil
            {
                let photoModel = arrPhotoExists![0] as? Photos
                photoModel?.isImageDeleted = false
            }
            do {
                try context.save()
                
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }

    //    MARK: - Deletion Methods
    
    class func DeletePhotosPermanently(arrPhotos: [Photos])
    {
        for object in arrPhotos
        {
            let arrPhotoExists = checkIfPhototExistsWithName(name: object.imageName!, inEntity: "Photos")
            if arrPhotoExists != nil
            {
                let photoModel = arrPhotoExists![0] as? Photos
                context.delete(photoModel!)
                
            }
            do {
                try context.save()
                
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }

    //    MARK: - Fetching Methods

    class func getAllPhotos() -> [Photos]?
    {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Photos")
        
        request.returnsDistinctResults = true
        let resultPredicate = NSPredicate(format: "isImageDeleted != %d", true)
        request.predicate = resultPredicate

        do {
            let  results = try context.fetch(request) as! [Photos]
            if (results.count > 0) {
                return results
                
            } else {
                return nil
            }
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        return nil
    }

    class func getDeletedPhotos() -> [Photos]?
    {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Photos")
        
        request.returnsDistinctResults = true
        let resultPredicate = NSPredicate(format: "isImageDeleted == %d", true)
        request.predicate = resultPredicate

        do {
            let  results = try context.fetch(request) as! [Photos]
            if (results.count > 0) {
                return results
                
            } else {
                return nil
            }
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        return nil

    }
    
    class func getFavoriteImages() -> [Photos]?
    {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Photos")
        
        request.returnsDistinctResults = true
        let resultPredicate = NSPredicate(format: "isFavoriteImage == %d AND isImageDeleted == %d", true, false)
        request.predicate = resultPredicate
        
        do {
            let  results = try context.fetch(request) as! [Photos]
            if (results.count > 0) {
                return results
                
            } else {
                return nil
            }
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        return nil
        
    }
    //MARK: - Check the existence of record
    
    class func checkIfPhototExistsWithName(name: String, inEntity entity: String) -> [NSManagedObject]?
    {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        request.returnsDistinctResults = true
        if name.count > 0
        {
            let resultPredicate = NSPredicate(format: "imageName == %@", name)
            request.predicate = resultPredicate
        }
        do {
            let  results = try context.fetch(request) as! [NSManagedObject]
            if (results.count > 0) {
                return results
                
            } else {
                return nil
            }
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        return nil

    }
}
