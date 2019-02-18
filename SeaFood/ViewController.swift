//
//  ViewController.swift
//  SeaFood
//
//  Created by Ahmed Ahmed on 2/10/19.
//  Copyright © 2019 MrRadix. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagePickByUser = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = imagePickByUser
            guard let ciImage = CIImage(image: imagePickByUser) else {
                fatalError("Cant convert Image taken to CIIamge")
            }
            detect(image: ciImage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func CameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func detect(image: CIImage){
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else{
            fatalError("Cant load ML Model")
        }
        
        let modelRequest = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else{
                fatalError("Model failed to process the Image")
            }
            if let firstResult = results.first{
                if firstResult.identifier.contains("hotdog"){
                    self.navigationItem.title = "Hotdog!"
                }
                else{
                    self.navigationItem.title = "Not Hotdog!"
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do{
            try handler.perform([modelRequest])
        }
        catch{
            print("Handler failed to load the image")
        }
        
    }
    
    
}

