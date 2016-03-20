# DBModel

By [Gryphon and Rook Inc.](http://gryphonandrook.com/).

DBModel is a wrapper to simplify requests to CoreData. The goal is to mimic the syntax used in Ruby on Rails for interacting with the database. 

## Information

Each Entity defined in CoreData should inherit from DBModel. DBModel defines common methods to retrieve objects.

### DBModel

Class methods that return a single object are:
* find(predicate: Where)
* findByKey(key: String, withValue: value)
* findByKey(key: String, withValue: value)
* findByPredicate(predicate: Where)
* findOrCreateByPredicate(predicate: Where, byKey key: String, withValue value:String)
* findOrCreateByKey(key: String, withValue value:String)
* CreateByKey(key: String, withValue value:String)

Class methods that return an array of results are:
* none() - returns an empty array
* all() - returns all objects with the default sort order
* allWithSort(order: SortOrder) - returns all objects with specific sort order
* query(predicate: Where) - returns objects matching predicate with the default sort order
* query(predicate: Where, withOrder order: SortOrder) - returns objects matching predicate with specific sort order

Entities can override the defaultSortOrder() method to specify how queries should order results.

### Where

Helper class to define complex queries by passing in a dictionary and containing an array of NSPredicates. As well as chaining complex queries together. Sibling values in a dictionary are automatically chained via an Or predicate. Whereas sibling keys are chained by an And predicate.

Class Methods include:
* init() - creates new instance with no searchPredicates defined
* init(terms: [String:[AnyObject]]) - creates new instance with searchPredicates defined by dictionary.
        `Where.init(terms: ["remoteID":[142, 158]])`

Instance Methods include:
* search() - returns a NSCompoundPredicate of type .AndPredicateType for all searchPredicates added to the instance.
* byPredicate(predicate: NSPredicate) - appends a custom predicate to the searchPredicates defined for the instance.
* whereByKey(key: String, withValue value: [AnyObject] - appends additional predicates to the searchPredicates defined for the instance.
        `Where.init().whereByKey("status", withValue: ["Active", "Conditional/Pending", "For Sale"])`
* whereNotByKey(key: String, withValue value: [AnyObject] - appends additional predicates to exclude keys that match given values to the searchPredicates defined for the instance.
        `Where.init().whereNotByKey("status", withValue: ["Active", "For Sale"])`

### SortOrder

Helper class to define custom sort orders via a dictionary. Allows setting as many sort objects as necessary.

Methods are:
* init(terms: [String:String]) - creates an instance defining an array of NSSortDescriptors.
        `SortOrder.init(terms: ["price":"Desc", "lastUpdatedAt":"Asc"])`
* sort() - returns the array of NSSortDescriptors on an instance.

## License

MIT License. Copyright 2015-2016 Gryphon and Rook Inc. http://gryphonandrook.com

You are not granted rights or licenses to the trademarks of Gryphon and Rook Inc.
