//
//  Photos+CoreDataProperties.swift
//  Photos
//
//  Created by Kiran kumar on 03/10/18.
//  Copyright © 2018 Kiran kumar. All rights reserved.
//
//

import Foundation
import CoreData


extension Photos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photos> {
        return NSFetchRequest<Photos>(entityName: "Photos")
    }

    @NSManaged public var isImageDeleted: Bool
    @NSManaged public var isFavoriteImage: Bool
    @NSManaged public var imageName: String?

}
