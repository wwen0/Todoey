//
//  Category.swift
//  Todoey
//
//  Created by Wei Wen on 7/10/18.
//  Copyright © 2018 Wei Wen. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
