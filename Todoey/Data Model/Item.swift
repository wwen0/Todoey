//
//  Item.swift
//  Todoey
//
//  Created by Wei Wen on 7/10/18.
//  Copyright © 2018 Wei Wen. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentObject = LinkingObjects(fromType: Category.self, property: "items")
}
