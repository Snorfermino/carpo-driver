//
//  UIViewControllerExtension.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/19/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setNavigationBarItem(title: String? = nil) {
        if let cnt = navigationController?.viewControllers.count {
            if(cnt > 1) {
                setNavigationBarItemForBack()
            } else {
//                addLeftBarButtonWithImage(#imageLiteral(resourceName: "ic_menu").resizeImage(newWidth: 20)!)
                let button = UIButton(type: .system)
                button.setImage(#imageLiteral(resourceName: "ic_menu").resizeImage(newWidth: 20), for: .normal)
                button.setTitle("  \(title ?? " ")", for: .normal)
                button.addTarget(self, action: #selector(self.showLeftMenu), for: .touchUpInside)
                button.sizeToFit()
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
            }
        }
        navigationController?.navigationBar.barTintColor = Global.navigationBarColor
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
//        if let title = title {
//            navigationItem.titleView = nil
//            navigationItem.title = title
//        }
//        else {
//            addLogoToTitleView()
//        }
        slideMenuController()?.removeLeftGestures()
        slideMenuController()?.addLeftGestures()
    }
    
    @objc func showLeftMenu(){
        slideMenuController()?.toggleLeft()
    }
    
    func setNavigationBarItemForBack() {
        let image = #imageLiteral(resourceName: "ic_back").withRenderingMode(.alwaysOriginal)
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(popViewController))
        navigationItem.setLeftBarButton(button, animated: true)
    }
    
    func setNavigationBarItemForBack(_ action: Selector) {
        let image = #imageLiteral(resourceName: "ic_back").withRenderingMode(.alwaysOriginal)
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: action)
        navigationItem.setLeftBarButton(button, animated: true)
    }
    
    @objc func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func rightBarButtonItemClicked() {
        let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let signInViewController = loginStoryboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        let temp = UINavigationController(rootViewController: signInViewController)
        slideMenuController()?.changeMainViewController(temp, close: true)
    }
    
    func addLogoToTitleView() {
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "ic_gender"))
        let view = UIView(frame: CGRect(x: 0, y: 0, width: logoImageView.frame.width, height: logoImageView.frame.height))
        view.addSubview(logoImageView)
        logoImageView.center = view.center
        let logoImageViewGesture = UITapGestureRecognizer(target: self, action: #selector(logoImageViewClicked))
        logoImageView.addGestureRecognizer(logoImageViewGesture)
        logoImageView.isUserInteractionEnabled = true
        navigationItem.titleView = view
    }
    
    func loginBarButtonItemClicked() {
        let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
        let d = storyboard.instantiateViewController(withIdentifier: "signIn") as! SignInViewController
        present(d, animated: true, completion: nil)
    }
    
    @objc func logoImageViewClicked() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let temp = UINavigationController(rootViewController: homeViewController)
        slideMenuController()?.changeMainViewController(temp, close: true)
    }
    
    func removeNavigationBarItem() {
        navigationItem.leftBarButtonItem = nil
        slideMenuController()?.removeLeftGestures()
    }
}

