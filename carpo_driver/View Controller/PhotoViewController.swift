//
//  PhotoViewController.swift
//  carpo-customer
//
//  Created by Tien Dat on 2/8/18.
//  Copyright © 2018 Tien Dat. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation
class PhotoViewController: BaseViewController {
    @IBOutlet weak var imgViewProfile: UIImageView!
    let imgPicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBarItem(title: "Thay đổi ảnh đại diện")
        setupView()
    }
    
    func setupView(){
        //        imgViewProfile.sd_setImage(with: URL(string: (Global.user?.data.photo!)!)
        //        , placeholderImage: #imageLiteral(resourceName: "ic_profile")) { (image, error, cache, url) in
        //
        //        }
        
        imgViewProfile.sd_setImage(with: URL(string: (Global.user?.data.photo)!)! , placeholderImage: #imageLiteral(resourceName: "ic_logo"), options: [.retryFailed], completed: nil)
        imgPicker.delegate = self
    }
    
    func checkCamera() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .authorized:
            imgPicker.sourceType = .camera
            imgPicker.isEditing = false
            present(imgPicker, animated: true, completion: nil) // Do your stuff here i.e. callCameraMethod()
        case .denied:
            alertPromptToAllowCameraAccessViaSetting()
        case .notDetermined:
            alertToEncourageCameraAccessInitially()
        default:
            alertToEncourageCameraAccessInitially()
        }
    }
    
    func alertToEncourageCameraAccessInitially() {
        let alert = UIAlertController(
            title: "Thông Báo",
            message: "Quyền truy cập camera cần được kích hoạt!",
            preferredStyle: UIAlertControllerStyle.alert
        )
        alert.addAction(UIAlertAction(title: "Thoát", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Uỷ quyền", style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
            //            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func alertPromptToAllowCameraAccessViaSetting() {
        
        let alert = UIAlertController(
            title: "IMPORTANT",
            message: "Camera access required for capturing photos!",
            preferredStyle: UIAlertControllerStyle.alert
        )
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel) { alert in
            if AVCaptureDevice.devices(for: AVMediaType.video).count > 0 {
                AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                    DispatchQueue.main.async() {
                        self.checkCamera() } }
            }
            }
        )
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func useCamera(_ sender: UIButton){
        print("camera action")
        //        checkCamera()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imgPicker.delegate = self
            imgPicker.sourceType = .camera
            imgPicker.isEditing = false
            present(imgPicker, animated: true, completion: nil)
        } else {
            alertToEncourageCameraAccessInitially()
        }
    }
    
    @IBAction func useGallery(_ sender: UIButton){
        print("photo library")
        imgPicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imgPicker.isEditing = false
        self.present(imgPicker, animated: true, completion: nil)
    }
    
}
extension PhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        imgViewProfile.contentMode = .scaleAspectFit //3
        imgViewProfile.image = chosenImage //4
        uploadAvatar(chosenImage)
        dismiss(animated:true, completion: nil) //5
    }
    
    func uploadAvatar(_ image: UIImage){
        let completion = {(result: ChangeAvatarResult?, error: String?) -> Void in
            if result?.status == 0 {
                self.alert(title: "Lỗi", message: "Cập nhập hình ảnh thất bại")
            } else {
                if let url = result?.data?.imageUrl {
                    let newUser = Global.user
                    newUser?.data.photo = url
                    Global.user = newUser
                    self.alert(title: "Đã cập nhập", message: "")
                }
                Global.user?.data.photo = (result?.data?.imageUrl)!
                
                
            }
        }
        ApiManager.changeAvatar(image, completion: completion)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

