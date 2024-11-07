//
//  LostPetRouter.swift
//  PetAlert
//
//  Created by vengatesh.c on 06/11/24.
//

import Foundation
import UIKit

class LostPetRouter : NSObject,LostPetPresenterToRouter {
    //MARK: ------  Router Delegate Function ------
    func navigateTo(_ fromVC: UIViewController, _ toVC: UIViewController, _ animation: Bool) {
        fromVC.navigationController?.pushViewController(toVC, animated: animation)
    }
}
