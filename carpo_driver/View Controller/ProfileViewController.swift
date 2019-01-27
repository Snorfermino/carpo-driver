//
//  ProfileViewController.swift
//  carpo_driver
//
//  Created by Tien Dat on 11/13/17.
//  Copyright © 2017 Tien Dat. All rights reserved.
//

import UIKit
import SVProgressHUD
class ProfileViewController: BaseViewController {
    @IBOutlet weak var imgViewProfilePicture: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    let imgPicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
        self.setNavigationBarItem(title: "Thông tin tài khoản")
        
    }
    
    func setupView(){
        setupTableView()
        imgViewProfilePicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.photoFromLibrary(_:))))
        imgPicker.delegate = self
        
    }
    
    func setupTableView(){
        tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        tableView.layer.addBorder(edge: .top, color: UIColor(hex: "808080"), thickness: 0.25)
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.sizeToFit()
        
        guard Global.user != nil else { return }
        imgViewProfilePicture.sd_setImage(with: Global.user?.data.photo != "" ? URL(string: (Global.user?.data.photo)!)! : nil , placeholderImage: #imageLiteral(resourceName: "ic_logo"), options: [.retryFailed], completed: nil)
    }
    
    @objc func photoFromLibrary(_ sender: UITapGestureRecognizer) {
        
        let viewController = UINavigationController(rootViewController: UIStoryboard.main.viewController(PhotoViewController.self))
        //        slideMenuController()?.changeMainViewController(viewController, close: true)
        self.performSegue(withIdentifier: "PhotoVC", sender: nil)
//        let optionMenu = UIAlertController(title: nil, message: "Take Photo From", preferredStyle: .alert)
//        let cameraAction = UIAlertAction(title: "Photo Camera", style: .default) { (UIAlertAction) in
//            self.chooseCamera()
//        }
//        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { (UIAlertAction) in
//            self.chooseLibrary()
//        }
//
//        optionMenu.addAction(cameraAction)
//        optionMenu.addAction(libraryAction)
//        optionMenu.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
//        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func chooseCamera() {
        print("camera action")
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imgPicker.sourceType = .camera
            imgPicker.isEditing = false
            present(imgPicker, animated: true, completion: nil)
        } else {
            alert(title: "Camera Error", message: "Camera not Available")
            print("camera not available")
        }
    }
    
    func chooseLibrary() {
        print("photo library")
        imgPicker.delegate = self
        imgPicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imgPicker.isEditing = false
        self.present(imgPicker, animated: true, completion: nil)
    }
    
}
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource, AlertPresenting {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
        switch indexPath.row {
        case 0:
            cell.imageView?.image = #imageLiteral(resourceName: "ic_people").resizeImage(newWidth: 20)
            cell.lbInfo.text = Global.user?.data.fullname
        case 1:
            cell.imageView?.image = #imageLiteral(resourceName: "ic_lock").resizeImage(newWidth: 20)
            cell.lbInfo.text = "Đổi mật khẩu"
            cell.imgViewCaret.image = #imageLiteral(resourceName: "ic_arrowRight")
        case 2:
            cell.imageView?.image = #imageLiteral(resourceName: "ic_calendar").resizeImage(newWidth: 20)
            cell.lbInfo.text = "11/07/1996"
        case 3:
            cell.imageView?.image = #imageLiteral(resourceName: "ic_gender").resizeImage(newWidth: 20)
            cell.lbInfo.text = "Nam"
        case 4:
            cell.imageView?.image = #imageLiteral(resourceName: "ic_plate").resizeImage(newWidth: 20)
            cell.lbInfo.text = Global.user?.data.licensePlate
        default:
            cell.lbInfo.text = "Đăng Xuất"
            cell.imageView?.image = #imageLiteral(resourceName: "ic_logout").resizeImage(newWidth: 20)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            showChangePwd(self.view, delegate: self)
        case 5:
            DataManager.loggedOut()
            let viewController = UINavigationController(rootViewController: UIStoryboard.main.viewController(SignInViewController.self))
            slideMenuController()?.changeMainViewController(viewController, close: false)
        default:
            break
        }
    }
    
}
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        imgViewProfilePicture.contentMode = .scaleAspectFit //3
        imgViewProfilePicture.image = chosenImage //4
        uploadAvatar(chosenImage)
        dismiss(animated:true, completion: nil) //5
    }
    
    func uploadAvatar(_ image: UIImage){
        let completion = {(result: ChangeAvatarResult?, error: String?) -> Void in
            if result?.status == 0 {
                self.alert(title: "Lỗi", message: "Cập nhập hình ảnh thất bại")
            } else {
                self.alert(title: "Đã cập nhập", message: "")
                Global.user?.data.photo = result?.data?.imageUrl
            }
        }
        ApiManager.changeAvatar(image, completion: completion)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
extension ProfileViewController: ChangePasswordDelegate {
    func newPwdNotMatch() {
        
    }
    
    func changePwd(isSuccess: Bool) {
        print("")
        if isSuccess {
            alert(title: "Đổi mật khẩu", message: "Thành công")
        } else {
            alert(title: "Đổi mật khẩu", message: "Thất bại")
        }
    }
}
