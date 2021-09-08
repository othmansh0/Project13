//
//  ViewController.swift
//  Project13
//
//  Created by othman shahrouri on 9/7/21.
//


//Context core image component that handles rendering
//creating a context is computationally expensive so we create it once as global

//Filter stores the filter user has activated




import CoreImage
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensity: UISlider!
    var currentImage: UIImage!
    
    var context: CIContext!
    var filter: CIFilter!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        title = "Instafilter "
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        context = CIContext()
        filter = CIFilter(name: "CISepiaTone")
    }

    @IBAction func changeFilter(_ sender: Any) {
    }
    
    @IBAction func save(_ sender: Any) {
    }
    @IBAction func intensityChanged(_ sender: Any) {
    }
    
    @objc func importPicture(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        currentImage = image
        
        
        
    }
    
    
    
}

