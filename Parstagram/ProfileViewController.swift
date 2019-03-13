//
//  ProfileViewController.swift
//  Parstagram
//
//  Created by Caleb Giles on 3/12/19.
//  Copyright © 2019 Caleb Giles. All rights reserved.
//

import UIKit
import AlamofireImage
import Parse

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = PFUser.current()!
        usernameLabel.text = user["username"] as? String
        if(user["profile_image"] != nil){
            let imageFile = user["profile_image"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            
            profileImage.af_setImage(withURL: url)
        }

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onUpdateButton(_ sender: Any) {
        let picker  = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
        }else{
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
        
    }
    
    @IBAction func onSaveChangesButton(_ sender: Any) {
        let user = PFUser.current()!
        
        let imageData = profileImage.image!.pngData()
        let file = PFFileObject(data: imageData!)
        
        user["profile_image"] = file
        
        user.saveInBackground { (success, error) in
            if success{
                self.dismiss(animated: true, completion: nil)
            }
            else{
                print("error onSubmit: \(error)")
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width:300, height: 300)
        let scaledImage = image.af_imageAspectScaled(toFill: size)
        
        profileImage.image = scaledImage
        
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
