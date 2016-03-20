//
//  Where.swift
//
//  Created by Development on 2015-10-26.
//  Copyright © 2015 Gryphon & Rook Inc. All rights reserved.
//

import Foundation

class Where: NSObject {
    var searchPredicates = [NSPredicate]()

    // terms = ["remoteID":[142, 158]]
    convenience init(terms: [String:[AnyObject]]) {
        self.init()
        for (key, value) in terms {
            self.whereByKey(key, withValue: value)
        }
    }

    func search() -> NSPredicate {
        return NSCompoundPredicate(type: .AndPredicateType, subpredicates: searchPredicates)
    }

    func byPredicate(predicate: NSPredicate) -> Where {
        searchPredicates.append(predicate)
        return self
    }

    func whereByKey(key: String, withValue value: [AnyObject]) -> Where {
        if value.count == 1 {
            searchPredicates.append(buildPredicateBy(key, withValue: value))
        } else if value.count > 1 {
            searchPredicates.append(getOrPredicateBy(key, withValues: value))
        }
        return self
    }

    func whereNotByKey(key: String, withValue value: [AnyObject]) -> Where {
        if value.count == 1 {
            searchPredicates.append(buildNotPredicateBy(key, withValue: value))
        } else if value.count > 1 {
            searchPredicates.append(getNotAndPredicateBy(key, withValues: value))
        }
        return self
    }

    func buildPredicateBy(key: String, withValue value: [AnyObject]) -> NSPredicate {
        return NSPredicate(format: "\(key) ==[c] %@", argumentArray: value)
    }

    func buildNotPredicateBy(key: String, withValue value: [AnyObject]) -> NSPredicate {
        return NSPredicate(format: "\(key) !=[c] %@", argumentArray: value)
    }

    private func getOrPredicateBy(key: String, withValues values: [AnyObject]) -> NSCompoundPredicate {
        var orPredicates = [NSPredicate]()
        for value in values {
            orPredicates.append(buildPredicateBy(key, withValue: [value]))
        }
        return NSCompoundPredicate(type: .OrPredicateType, subpredicates: orPredicates)
    }

    private func getNotAndPredicateBy(key: String, withValues values: [AnyObject]) -> NSCompoundPredicate {
        var andPredicates = [NSPredicate]()
        for value in values {
            andPredicates.append(buildNotPredicateBy(key, withValue: [value]))
        }
        return NSCompoundPredicate(type: .AndPredicateType, subpredicates: andPredicates)
    }
}