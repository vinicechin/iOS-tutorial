//
//  SelfDrivenCar.swift
//  Classes and Objects
//
//  Created by Gabriella Barbieri on 25/09/19.
//  Copyright © 2019 Gabriella Barbieri. All rights reserved.
//

import Foundation

class SelfDrivenCar : Car {
    
    var destination = "1 Infinite Loop"
    
    override func drive() {
        super.drive()
        
        print("Driving towards " + destination)
    }
}
