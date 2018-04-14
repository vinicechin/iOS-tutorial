//
//  ViewController.swift
//  Dicee
//
//  Created by Vinicius Cechin on 14/04/2018.
//  Copyright © 2018 Vinicius Cechin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var diceIndex: Int = 0
    
    @IBOutlet weak var leftDice: UIImageView!
    @IBOutlet weak var rightDice: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func rollDices(_ sender: UIButton) {
        diceIndex = Int(arc4random_uniform(6))
        
        print(diceIndex) 
    }
}

