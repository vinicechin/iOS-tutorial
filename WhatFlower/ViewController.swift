//
//  ViewController.swift
//  WhatFlower
//
//  Created by Gabriella Barbieri on 04/11/19.
//  Copyright © 2019 Vinicius Cechin. All rights reserved.
//

import UIKit
import CoreML
import Vision
import Alamofire
import SwiftyJSON
import SDWebImage

class ViewController: UIViewController {
    @IBOutlet weak var flowerImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    let wikiURL = "https://en.wikipedia.org/w/api.php"
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
    }

    @IBAction func cameraButtonPressed(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[.editedImage] as? UIImage else {
            fatalError("Error picking image")
        }
//        flowerImageView.image = pickedImage
        
        guard let ciImage = CIImage(image: pickedImage) else {
            fatalError("Could not convert UIImage to CIImage")
        }
        detect(ciImage)
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

extension ViewController {
    func detect(_ image: CIImage) {
        guard let model = try? VNCoreMLModel(for: FlowerClassifier().model) else {
            fatalError("Cannot import flower classifier ML model")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let classification = request.results?.first as? VNClassificationObservation else {
                fatalError("Could not classify flower")
            }
            
            let name = classification.identifier
            self.navigationItem.title = name.capitalized
            self.requestInfo(flowerName: name)
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        } catch {
            print("Error analysing image, \(error)")
        }
    }
    
    func requestInfo(flowerName: String) {
        let parameters: [String:String] = [
            "format": "json",
            "action": "query",
            "prop": "extracts|pageimages",
            "exintro": "",
            "explaintext": "",
            "titles": flowerName,
            "indexpageids": "",
            "redirects": "1",
            "pithumbsize": "500"
        ]
        
        Alamofire.request(wikiURL, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                print("wiki data")
                print(response)
                
                guard let value = response.result.value else {
                    fatalError("Error getting wiki data")
                }
                
                let flowerJSON: JSON = JSON(value)
                let pageid = flowerJSON["query"]["pageids"][0].stringValue
                let flowerDesc = flowerJSON["query"]["pages"][pageid]["extract"].stringValue
                
                let flowerImageURL = flowerJSON["query"]["pages"][pageid]["thumbnail"]["source"].stringValue
                
                self.descriptionLabel.text = flowerDesc
                self.flowerImageView.sd_setImage(with: URL(string: flowerImageURL))
            }
        }
    }
}

