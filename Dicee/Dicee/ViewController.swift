//
//  ViewController.swift
//  Dicee
//
//  Created by Vinicius Cechin on 14/04/2018.
//  Copyright © 2018 Vinicius Cechin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let dice = "dice"
    
    @IBOutlet weak var leftDice: UIImageView!
    @IBOutlet weak var rightDice: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        generateRandomDices()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func rollDices(_ sender: UIButton) {
        generateRandomDices()
    }
    
    func generateRandomDices() {
        var diceIndex = Int(arc4random_uniform(6))
        leftDice.image = getDiceImage(diceIndex)
        
        diceIndex = Int(arc4random_uniform(6))
        rightDice.image = getDiceImage(diceIndex)
    }
    
    func getDiceImage(_ index:Int) -> UIImage {
        return UIImage(named: "\(dice)\(index + 1)")!
    }
}

