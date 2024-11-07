//
//  LoginRouter.swift
//  PetAlert
//
//  Created by vengatesh.c on 04/11/24.
//

import Foundation
import UIKit

class LoginRouter : NSObject,LoginPresenterToRouter {
    //MARK: ------  Router Delegate Function ------
    func navigateTo(_ fromVC: UIViewController, _ toVC: UIViewController, _ animation: Bool) {
        fromVC.navigationController?.pushViewController(toVC, animated: animation)
    }
}

