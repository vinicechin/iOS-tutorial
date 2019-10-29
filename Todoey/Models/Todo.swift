//
//  Todo.swift
//  Todoey
//
//  Created by Vinicius Cechin on 24/10/19.
//  Copyright © 2019 Vinicius Cechin. All rights reserved.
//

import Foundation
import RealmSwift

class Todo: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var checked: Bool = false
    @objc dynamic var creationDate: Date?
    var parent = LinkingObjects(fromType: Category.self, property: "todos")
}
