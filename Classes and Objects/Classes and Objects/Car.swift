//
//  Car.swift
//  Classes and Objects
//
//  Created by Gabriella Barbieri on 24/09/19.
//  Copyright © 2019 Gabriella Barbieri. All rights reserved.
//

import Foundation

enum CarType {
    case Sedan
    case Coupe
    case Hatchback
}

class Car {
    var color = "Black"
    var nSeats = 4
    var typeOfCar : CarType = .Coupe
    
    init() {}
    
    convenience init(chosenColor : String) {
        self.init()
        color = chosenColor
    }
}
