//
//  WelcomeRouter.swift
//  PetAlert
//
//  Created by vengatesh.c on 03/11/24.
//

import Foundation
import UIKit

class WelcomeRouter : NSObject, welcomePresenterToRouter
{
    //MARK: ------  Router Delegate Function ------
    func navigateTo(_ fromVC: UIViewController, _ toVC: UIViewController, _ animation: Bool) {
        fromVC.navigationController?.pushViewController(toVC, animated: animation)
    }
}
