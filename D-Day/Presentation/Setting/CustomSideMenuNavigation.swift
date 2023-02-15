//
//  CustomSideMenuNavigation.swift
//  D-Day
//
//  Created by hana on 2023/01/30.
//

import UIKit
import SideMenu

class MenuVC: UIViewController{//, StoryboardInitializable {
//    static var storyboardName: String = "Main"
//    static var storyboardID: String = "MenuVC"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
    }
}


//
//protocol StoryboardInitializable {
//    static var storyboardName: String { get set }
//    static var storyboardID: String { get set }
//    static func instantiate() -> Self
//}
//
//extension StoryboardInitializable where Self: UIViewController {
//
//    static func instantiate() -> Self {
//        if #available(iOS 13.0, *) {
//            let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
//            return storyboard.instantiateViewController(identifier: storyboardID) { (coder) -> Self? in
//                return Self(coder: coder)
//            }
//        } else {
//            let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
//            let vc = storyboard.instantiateViewController(withIdentifier: storyboardID) as! Self
//            return vc
//        }
//    }
//}
