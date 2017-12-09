//
//  SupportViewController.swift
//  carpo_driver
//
//  Created by Tien Dat on 11/15/17.
//  Copyright © 2017 Tien Dat. All rights reserved.
//

import UIKit

class SupportViewController: BaseViewController {
    @IBOutlet weak var tvReport: UITextView!
    @IBOutlet weak var btnAttach: UIButton!
    let imagePicker = UIImagePickerController()
    var image:UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        setNavigationBarItem(title: Global.currentScreenTitle)
    }
    
    @IBAction func submitPressed(_ sender: UIButton){
        
    }

    
    @IBAction func attachPressed(_ sender: AnyObject) {
        let optionMenu = UIAlertController(title: nil, message: "", preferredStyle: .alert)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (UIAlertAction) in
            self.chooseCamera()
        }
        let libraryAction = UIAlertAction(title: "Thư Viện Ảnh", style: .default) { (UIAlertAction) in
            self.chooseLibrary()
        }
        
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(libraryAction)
        optionMenu.addAction(UIAlertAction(title: "Huỷ", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    func chooseCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.isEditing = false
            present(imagePicker, animated: true, completion: nil)
        } else {
            alert(title: "Lỗi", message: "Camera không tồn tại")
        }
    }
    
    func chooseLibrary() {
        print("photo library")
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.isEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
}
extension SupportViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let imageSize = Double(min(pickedImage.size.width, pickedImage.size.height))
            let cropImage = pickedImage.cropToBounds(width: imageSize, height: imageSize)
            self.image = cropImage
//            imgAvatar.showIndicator()
//            self.imgAvatar.contentMode = .scaleAspectFill
//            self.imgAvatar.image = cropImage
//
//            updateStyleForButtonGo()
//            viewModel.uploadAvatar(cropImage)
            
            
            
        } else {
//            self.imgAvatar.image = #imageLiteral(resourceName: "ic_logo")
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        updateStyleForButtonGo()
        dismiss(animated: true, completion: nil)
    }
}
