//
//  Photo+CoreDataProperties.swift
//  Photorama
//
//  Created by Виктория Бадисова on 14.06.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var dateTaken: NSDate?
    @NSManaged public var photoID: String?
    @NSManaged public var remoteURL: NSURL?
    @NSManaged public var title: String?
    @NSManaged public var viewsCount: Int64

}
