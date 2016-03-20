//
//  DBModel.swift
//
//  Created by Development on 2015-10-14.
//  Copyright © 2015 Gryphon & Rook Inc. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DBModel: NSManagedObject {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    static let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    static let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    // Get current model name
    class func getClassName() -> String {
        let classString = NSStringFromClass(self as AnyClass)
        let range = classString.rangeOfString(".", options: NSStringCompareOptions.CaseInsensitiveSearch, range: Range<String.Index>(start:classString.startIndex, end: classString.endIndex), locale: nil)
        return classString.substringFromIndex(range!.endIndex)
    }

    // Find and Create Queries
    // DBModel.find(Where.init(["remoteID":[142]))
    class func find(predicate: Where, inContext moc: NSManagedObjectContext = managedObjectContext) -> AnyObject {
        // Create a new fetch request using the subclass entity
        let fetchRequest = NSFetchRequest(entityName: getClassName())
        fetchRequest.predicate = predicate.search()
        
        // Execute the fetch request, and cast the results to an array of name objects
        do {
            let fetchResults =
            try moc.executeFetchRequest(fetchRequest) as NSArray
            if fetchResults != [] {
                return fetchResults[0] }
        } catch PropertyError.NoEntityFound {
            print("No Properties Found.")
        } catch {
            print("Unmanagaged Error Caught.")
        }
        return []
    }

    class func findByKey(key: String, withValue value: AnyObject, inContext moc: NSManagedObjectContext = managedObjectContext) -> AnyObject {
        // Create a new fetch request using the subclass entity
        let fetchRequest = NSFetchRequest(entityName: getClassName())
        fetchRequest.predicate = Where.init(terms: [key:[value]]).search()
        
        // Execute the fetch request, and cast the results to an array of name objects
        do {
            let fetchResults =
            try moc.executeFetchRequest(fetchRequest) as NSArray
            if fetchResults != [] {
                return fetchResults[0] }
        } catch PropertyError.NoEntityFound {
            print("No Properties Found.")
        } catch {
            print("Unmanagaged Error Caught.")
        }
        return []
    }
    
    class func findByPredicate(predicate: Where, inContext moc: NSManagedObjectContext = managedObjectContext) -> AnyObject {
        // Create a new fetch request using the subclass entity
        let fetchRequest = NSFetchRequest(entityName: getClassName())
        fetchRequest.predicate = predicate.search()

        // Execute the fetch request, and cast the results to an array of name objects
        do {
            let fetchResults =
            try moc.executeFetchRequest(fetchRequest) as NSArray
            if fetchResults != [] {
                return fetchResults[0] }
        } catch PropertyError.NoEntityFound {
            print("No Properties Found.")
        } catch {
            print("Unmanagaged Error Caught.")
        }
        return []
    }
    
    class func findOrCreateByPredicate(predicate: Where, byKey key: String, withValue value: AnyObject, inContext moc: NSManagedObjectContext = managedObjectContext) -> AnyObject {
        let entity = findByPredicate(predicate, inContext: moc)
        
        if entity as! NSObject == [] {
            return createByKey(key, withValue: value, inContext: moc)
        }
        return entity
    }

    class func findOrCreateByKey(key: String, withValue value: AnyObject, inContext moc: NSManagedObjectContext = managedObjectContext) -> AnyObject {
        let entity = findByKey(key, withValue: value, inContext: moc)
        
        if entity as! NSObject == [] {
            return createByKey(key, withValue: value, inContext: moc)
        }
        return entity
    }

    class func createByKey(key: String, withValue value: AnyObject, inContext moc: NSManagedObjectContext = managedObjectContext) -> AnyObject {
        // Create a new object entity using the subclass entity
        let entity = NSEntityDescription.insertNewObjectForEntityForName(getClassName(), inManagedObjectContext: moc)
        entity.setValue(value, forKey: key)
        return entity
    }

    class func defaultSortOrder() -> SortOrder {
        return SortOrder.init()
    }

    // Execute Query
    class func none(moc: NSManagedObjectContext = managedObjectContext) -> AnyObject {
        return []
    }

    class func all(moc: NSManagedObjectContext = managedObjectContext) -> AnyObject {
        return query(Where.init(), withOrder: defaultSortOrder(), inContext: moc)
    }
    
    class func allWithSort(order: SortOrder, inContext moc: NSManagedObjectContext = managedObjectContext) -> AnyObject {
        return query(Where.init(), withOrder: order, inContext: moc)
    }
    
    class func query(predicate: Where, inContext moc: NSManagedObjectContext = managedObjectContext) -> AnyObject {
        // Create a new fetch request using the subclass entity
        return query(predicate, withOrder: defaultSortOrder(), inContext: moc)
    }
    
    class func query(predicate: Where, withOrder order: SortOrder, inContext moc: NSManagedObjectContext = managedObjectContext) -> AnyObject {
        // Create a new fetch request using the subclass entity
        let fetchRequest = NSFetchRequest(entityName: getClassName())
        fetchRequest.sortDescriptors = order.sort()
        fetchRequest.predicate = predicate.search()

        // Execute the fetch request, and cast the results to an array of name objects
        do {
            let fetchResults =
            try moc.executeFetchRequest(fetchRequest)
            return fetchResults
        } catch PropertyError.NoEntityFound {
            print("No Properties Found.")
        } catch {
            print("Unmanagaged Error Caught.")
        }
        return []
    }

    var currentContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    func inContext(moc: NSManagedObjectContext) {
        currentContext = moc
    }

    func dateFromLongString(date: String) -> NSDate {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.dateFromString(date)! as NSDate
    }

    func dateFromString(date: String) -> NSDate {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.dateFromString(date)! as NSDate
    }

    func delete() {
        (UIApplication.sharedApplication().delegate as! AppDelegate)
            .managedObjectContext.deleteObject(self as NSManagedObject)
    }

    func save() {
        if currentContext.hasChanges {
            do {
                try self.validateForInsert()
                try currentContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                self.delete()
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}