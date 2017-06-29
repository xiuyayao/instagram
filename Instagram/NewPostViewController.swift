//
//  NewPostViewController.swift
//  Instagram
//
//  Created by Xiuya Yao on 6/27/17.
//  Copyright © 2017 Xiuya Yao. All rights reserved.
//

import UIKit
import Parse

class NewPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let cameraSelectAlertController = UIAlertController(title: "Camera NOT available", message: "Please select Photo Library", preferredStyle: .alert)
    
    @IBOutlet weak var imageToPost: UIImageView!
    
    @IBOutlet weak var captionToPost: UITextField!
    
    var postImage = UIImage(named: "imageName")
    var postCaption = ""
    let vc = UIImagePickerController()
    
    @IBAction func sharePostAction(_ sender: UIButton) {
        postCaption = captionToPost.text ?? ""
        Post.postUserImage(image: imageToPost.image, withCaption: postCaption) { (status: Bool, error: Error?) in
            print("Post successful")
        }
        // clear image and caption
        imageToPost.image = #imageLiteral(resourceName: "image_placeholder")
        captionToPost.text = ""
        
        // NEED TO DO THIS
        // segue to home view controller after successful posting
    }
    
    
    @IBAction func cameraPostAction(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
            self.present(vc, animated: true, completion: nil)
        } else {
            self.present(self.cameraSelectAlertController, animated: true)
            /*
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
            */
        }
    }
    
    @IBAction func photoLibraryAction(_ sender: UIButton) {
        vc.sourceType = .photoLibrary
        self.present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        // let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
     
        // Do something with the images (based on your use case)
        postImage = editedImage
        imageToPost.image = editedImage
     
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        // vc.sourceType = UIImagePickerControllerSourceType.camera
        
        /*
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
        self.present(vc, animated: true, completion: nil)
         */
        
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here.
        }
        // add the OK action to the alert controller
        cameraSelectAlertController.addAction(OKAction)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
