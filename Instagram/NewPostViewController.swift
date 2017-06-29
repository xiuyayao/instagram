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
    
    let postAlertController = UIAlertController(title: "Invalid Action", message: "Please select an image to post", preferredStyle: .alert)
    
    let cameraSelectAlertController = UIAlertController(title: "Camera NOT available", message: "Please select Photo Library", preferredStyle: .alert)
    
    @IBOutlet weak var imageToPost: UIImageView!
    
    @IBOutlet weak var captionToPost: UITextField!
    
    var postImage = UIImage(named: "imageName")
    var postCaption = ""
    let vc = UIImagePickerController()
    
    @IBAction func sharePostAction(_ sender: UIButton) {
        
        postCaption = captionToPost.text ?? ""
        
        if (imageToPost.image == #imageLiteral(resourceName: "image_placeholder")) {
            // print error message
            self.present(self.postAlertController, animated: true)
            
        } else {
            Post.postUserImage(image: imageToPost.image, withCaption: postCaption) { (status: Bool, error: Error?) in
                print("Post successful")
            }
            // clear image and caption
            imageToPost.image = #imageLiteral(resourceName: "image_placeholder")
            captionToPost.text = ""
            
            // segue to home view controller after successful posting
            self.performSegue(withIdentifier: "homeSegue", sender: nil)
        }
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // Get the image captured by the UIImagePickerController
        // let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
     
        // Do something with the images (based on your use case)
        postImage = editedImage
        imageToPost.image = editedImage
     
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
    
    // CHECK THIS FUNCTION AND MAKE SURE IT WORKS
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

    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewPostViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
        
        // let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        // vc.sourceType = UIImagePickerControllerSourceType.camera
        
        // Old code, before choice of camera vs photo library was added
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
        
        // add the OK action to the alert controller
        postAlertController.addAction(OKAction)
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
