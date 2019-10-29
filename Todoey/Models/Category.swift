//
//  Category.swift
//  Todoey
//
//  Created by Vinicius Cechin on 24/10/19.
//  Copyright © 2019 Vinicius Cechin. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let todos = List<Todo>()
}
