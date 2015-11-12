//
//  SortBy.swift
//  EstateTV
//
//  Created by Development on 2015-10-26.
//  Copyright © 2015 Gryphon & Rook Inc. All rights reserved.
//

import Foundation
import CoreData

class SortOrder: NSObject {
    var sortDescriptors = [NSSortDescriptor]()

    // terms = ["price":"Desc", "lastUpdatedAt":"Asc"]
    convenience init(terms: [String:String]) {
        self.init()
        for (column, order) in terms {
            let sortDirection: Bool = order == "Asc"
            let sortItem: NSSortDescriptor = NSSortDescriptor(key: column, ascending: sortDirection)
            
            self.sortDescriptors.append(sortItem)
        }
    }

    func sort() -> [NSSortDescriptor] {
        return sortDescriptors
    }    
}
