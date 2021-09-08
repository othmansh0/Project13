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
    var currentFilter: CIFilter!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        title = "Instafilter "
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
    }

    //sneder changed from Any to UIButton so we can pin our ac to a button
    @IBAction func changeFilter(_ sender: UIButton) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
           ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
           ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
           ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
           ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
           ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
           ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
           ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
           ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
        if let popoverController = ac.popoverPresentationController {
            //use the sender as a source for popoverPresentation
            popoverController.sourceView = sender
            //Used here is the view it come from then here rectangle around that
            popoverController.sourceRect = sender.bounds
        }
        
           present(ac, animated: true)
    }
    func setFilter(action: UIAlertAction) {
        //make sure we have image
        guard currentImage != nil else { return }
        
        guard let actionTitle = action.title else { return }
        
        currentFilter = CIFilter(name: actionTitle)
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
       
    }
    
    @IBAction func save(_ sender: Any) {
    }
    @IBAction func intensityChanged(_ sender: Any) {
        applyProcessing()
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
        //unedited image/original
        currentImage = image
        
        //let users drag the slider up and down to add varying amounts of sepia effect to the image they select
       //CIImage from UIImage
        let beginImage = CIImage(image: currentImage)
        //Send results to filter
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
        
    }
    
    func applyProcessing() {
        guard let outputImage = currentFilter.outputImage else { return }
        
        //Setting intensity to slider's value
        currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
        
        //reading the final rendered image as UIImage
        //Converting from CIImage to UIImage takes extra step
        //CIImage to CGImage to UIImage
        //We need to specify which part of the image we want to render .extent means all of it
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent){
            let processedImage = UIImage(cgImage: cgImage)
            imageView.image = processedImage
        }
    }
    
}

