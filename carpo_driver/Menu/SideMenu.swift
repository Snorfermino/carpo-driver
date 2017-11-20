//
//  SideMenu.swift
//  carpo_driver
//
//  Created by Tien Dat on 11/13/17.
//  Copyright © 2017 Tien Dat. All rights reserved.
//

import Foundation
import UIKit
import SlideMenuControllerSwift
import IBAnimatable
protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}
enum MenuSection: Int {
    case first = 0
    
    var items: [LeftMenu] {
        switch self {
        case .first:
            return [.home, .history, .group, .support]

        }
    }
}
struct LeftMenuItem {
    let title: String
    let viewController: UIViewController?
    let icon: UIImage
}
enum LeftMenu: Int {
    case home = 0
    case history = 1
    case group = 2
    case support = 3
    var leftMenuItem: LeftMenuItem {
        let mainStoryboard = UIStoryboard.main

        switch self {
        case .home:
            let viewController = UINavigationController(rootViewController: mainStoryboard.viewController(HomeViewController.self))
            return LeftMenuItem(title: "Trang chủ", viewController: viewController, icon: #imageLiteral(resourceName: "ic_gender"))
        case .history:
            let viewController = UINavigationController(rootViewController: mainStoryboard.viewController(MapViewController.self))
            return LeftMenuItem(title: "Lịch sử", viewController: viewController, icon: #imageLiteral(resourceName: "ic_gender"))
        case .support:
            let viewController = UINavigationController(rootViewController: mainStoryboard.viewController(SupportViewController.self))
            return LeftMenuItem(title: "Hỗ Trợ", viewController: viewController, icon: #imageLiteral(resourceName: "ic_gender"))
        case .group:
            let viewController = UINavigationController(rootViewController: mainStoryboard.viewController(GroupViewController.self))
            return LeftMenuItem(title: "Nhóm", viewController: viewController, icon: #imageLiteral(resourceName: "ic_gender"))

        }
    }

    var section: MenuSection? {
        var index = 0
        while true {
            guard let menuSection = MenuSection(rawValue: index) else { return nil }
            if menuSection.items.contains(self) {
                return menuSection
            }
            index += 1
        }
    }

    func item(from leftMenuItems: [[LeftMenuItem]]) -> LeftMenuItem? {
        if let section = self.section,
            let index = section.items.index(where: { $0 == self }) {
            return leftMenuItems[section.rawValue][index]
        } else {
            return nil
        }
    }

    func viewController(from leftMenuItems: [[LeftMenuItem]]) -> UIViewController? {
        if let item = item(from: leftMenuItems),
            let viewController = item.viewController {
            return viewController
        } else {
            return nil
        }
    }
}

class LeftMenuViewController: BaseViewController,LeftMenuProtocol {
    
    @IBOutlet weak var topMenuLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgViewProfilePicture: AnimatableImageView!
    
    @IBOutlet weak var topMenu: UIView!
    var favoriteViewController: UIViewController!
    var userProfileViewController: UIViewController!
    var signInViewController: UIViewController!
    var myWalletViewController: UIViewController!
    var leftMenuItems = [[LeftMenuItem]]()

    var sub1: Bool = false
    var sub2: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLeftMenu()
//        tableView.separatorColor = UIColor(red: 224, green: 224, blue: 224, alpha: 1)
//        self.tableView.separatorColor = UIColor(red: 224, green: 224, blue: 224)
        imgViewProfilePicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toSignInVC(_:))))
        imgViewProfilePicture.isUserInteractionEnabled = true
        self.tableView.register(MenuCell.self, forCellReuseIdentifier: "MenuCell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isOpaque = false
//        updateUIByLogin()
//        NotificationCenter.default.rx.notification(Notification.Name("UserLoginedNotification"))
//            .subscribe(onNext: { [weak self] _ in
//                if let menuItems = self?.leftMenuItems, let viewController = LeftMenu.home.viewController(from: menuItems) {
//                    self?.slideMenuController()?.changeMainViewController(viewController, close: true)
//                }
//                self?.tableView.reloadData()
//                self?.updateUIByLogin()
//            })
//            .disposed(by: disposeBag)
//        NotificationCenter.default.rx.notification(.changeMenuTab)
//            .subscribe(onNext: { notification in
//                if let headerItem = notification.object as? HeaderMenuItem {
//                    switch headerItem {
//                    case .userProfile:
//                        self.goToUserProfile()
//                    case .favourite:
//                        self.goToFavorite()
//                    case .myWallet:
//                        self.goToMyWallet()
//                    }
//                    return
//                }
//                guard let menu = notification.object as? LeftMenu else { return }
//                self.changeViewController(menu)
//                //self.tableView.selectRow(at: IndexPath(row: menu, section: 0), animated: false, scrollPosition: UITableViewScrollPosition.none)
//            })
//            .disposed(by: disposeBag)
    }
    
    @objc func toSignInVC(_ sender: UITapGestureRecognizer){
//        self.navigationController?.pushViewController(UIStoryboard.main.instantiateViewController(withIdentifier: "SignInViewController"), animated: true)
        print("say something")
        let viewController = UINavigationController(rootViewController: UIStoryboard.main.viewController(SignInViewController.self))
        slideMenuController()?.changeMainViewController(viewController, close: true)
    }
    
    func setUpLeftMenu() {
        leftMenuItems.removeAll()
        while true {
            guard let section = MenuSection(rawValue: leftMenuItems.count) else { break }
            var items = [LeftMenuItem]()
            for item in section.items {
                items.append(item.leftMenuItem)
            }
            leftMenuItems.append(items)
        }
        
        let mainStoryboard = UIStoryboard.main
        let signInViewController = UIStoryboard.main.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        self.signInViewController = UINavigationController(rootViewController: signInViewController)
        
        let userProfileViewController = mainStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.userProfileViewController = UINavigationController(rootViewController: userProfileViewController)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
//        case .group, .history, .home:
//            if let viewController = menu.viewController(from: leftMenuItems) {
//                requireLogin(ifElseGoTo: viewController)
//            }
        default:
            if let viewController = menu.viewController(from: leftMenuItems) {
                slideMenuController()?.changeMainViewController(viewController, close: true)
            }
        }
    }
    
    func requireLogin(ifElseGoTo: UIViewController) {
//        if Global.user == nil {
//            showRequireLoginPopup()
//        } else {
//            slideMenuController()?.changeMainViewController(ifElseGoTo, close: true)
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }
    
}
extension LeftMenuViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: getRawValue(indexPath)) {
            switch menu {
            case .home, .history, .support ,.group:
                return MenuCell.height()

            }
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return leftMenuItems.count
//        if(Global.user != nil) {
//            return leftMenuItems.count
//        } else {
//            return leftMenuItems.count - 1
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 11
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MenuCell
        if let menu = LeftMenu(rawValue: getRawValue(indexPath)) {
            if(getRawValue(indexPath) == 0 || getRawValue(indexPath) == 8) {
//                if(getRawValue(indexPath) == 0) {
//                    sub1 = !sub1
//                    cell.updateMenuParentCorner(sub1)
//                } else if (getRawValue(indexPath) == 8) {
//                    sub2 = !sub2
//                    cell.updateMenuParentCorner(sub2)
//                }
                tableView.beginUpdates()
                tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
                tableView.endUpdates()
            } else {
                self.changeViewController(menu)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
}

extension LeftMenuViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leftMenuItems[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if LeftMenu(rawValue: getRawValue(indexPath)) != nil {
            let cell = Bundle.main.loadNibNamed("MenuCell", owner: self, options: nil)?.first as! MenuCell
//            var b = false
//            if menu == .home || menu == .termsAndConditions {
//                b = true
//            }
            
            let item = leftMenuItems[indexPath.section][indexPath.row]
            
            cell.setData(string: item.title)
            cell.isOpaque = false
            cell.backgroundColor = UIColor.clear
            cell.layer.backgroundColor = UIColor.clear.cgColor
            cell.clipsToBounds = true
            return cell
        }
        return UITableViewCell()
    }
    
//    func getCornerValue(_ indexPath: IndexPath) -> MenuTableViewCellCorner {
//        if indexPath.row == 0 {
//            return .full
//        } else if indexPath.row == leftMenuItems[indexPath.section].count - 1 {
//            return .bottom
//        } else {
//            return .normal
//        }
//    }
    
    func getRawValue(_ indexPath: IndexPath) -> Int {
        var cnt = 0
        for i in 0..<indexPath.section {
            cnt += leftMenuItems[i].count
        }
        return cnt + indexPath.row
    }
}
