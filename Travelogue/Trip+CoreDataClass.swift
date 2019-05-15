//
//  Trip+CoreDataClass.swift
//  Travelogue
//
//  Created by Melissa Hollingshed on 4/30/19.
//  Copyright © 2019 Melissa Hollingshed. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(Trip)
public class Trip: NSManagedObject {
    var entries: [Entry]?{
        return self.rawEntries?.array as? [Entry]
    }
    
    convenience init?(title: String) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let context = appDelegate?.persistentContainer.viewContext
            else{
                return nil
        }
        
        self.init(entity: Trip.entity(), insertInto: context)
        self.tripTitle = title
    }
    

}
