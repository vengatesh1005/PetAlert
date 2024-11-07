//
//  WelcomePresenter.swift
//  PetAlert
//
//  Created by vengatesh.c on 03/11/24.
//

import Foundation
import UIKit

class WelcomePresenter : NSObject
{
    //MARK: ------  Presenter Delegate Obejects ------
    weak fileprivate var welcomeRouterDelegate:welcomePresenterToRouter!
    fileprivate var welcomeRouterObj:WelcomeRouter!
    
    override init() {
        super.init()
        self.welcomeRouterObj = WelcomeRouter()
        self.welcomeRouterDelegate = self.welcomeRouterObj
    }
}

//MARK: ------  Presenter Delegate Functions ------
extension WelcomePresenter : welcomeViewToPresenter
{
    func navigateTo(_ fromVC: UIViewController, _ toVC: UIViewController, _ animation: Bool) {
        self.welcomeRouterDelegate.navigateTo(fromVC, toVC, animation)
    }
}
