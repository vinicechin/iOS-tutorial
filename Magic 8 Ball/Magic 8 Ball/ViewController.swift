//
//  ViewController.swift
//  Magic 8 Ball
//
//  Created by Vinicius Cechin on 22/04/2018.
//  Copyright © 2018 Vinicius Cechin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var ballImageText = "ball"
    
    @IBOutlet weak var imageBall8: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        generateRandomAnswer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func askAction(_ sender: Any) {
        generateRandomAnswer()
    }
    
    func generateRandomAnswer() {
        let index:Int = getRandomIndex()
        imageBall8.image = UIImage(named: "\(ballImageText)\(index+1)")
    }
    
    func getRandomIndex() -> Int {
        return Int(arc4random_uniform(5))
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        generateRandomAnswer()
    }
}

