//
//  ViewController.swift
//  Xylophone
//
//  Created by Angela Yu on 27/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    var audioPlayer : AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func notePressed(_ sender: UIButton) {
        let sound = "note" + String(sender.tag)
        playSound(sound)
    
    }
    
    func playSound(_ sound : String) {
        
        let soundUrl = Bundle.main.url(forResource: sound, withExtension: "wav")
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: soundUrl!)
        } catch {
            print(error)
        }
        
        audioPlayer.play()
        
    }

}

