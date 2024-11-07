//
//  RegisterPresenter.swift
//  PetAlert
//
//  Created by vengatesh.c on 03/11/24.
//

import Foundation
import UIKit

class RegisterPresenter : NSObject {
    //MARK: ------  Presenter Delegate Obejects ------
    weak fileprivate var registerViewDelegate:RegisterPresenterToView?
    weak fileprivate var registerInteractorDelegate:RegisterPresenterToInteractor!
    fileprivate var registerInteractorObj:RegisterInteractor!
    weak fileprivate var registerRouterDelegate:RegisterPresenterToRouter!
    fileprivate var registerRouterObj:RegisterRouter!
    
    override init() {
        super.init()
        
        self.registerInteractorObj = RegisterInteractor()
        self.registerInteractorDelegate = self.registerInteractorObj
        self.registerInteractorDelegate?.setInteractorDelegate(self)
        
        self.registerRouterObj = RegisterRouter()
        self.registerRouterDelegate = self.registerRouterObj
    }
}

//MARK: ------  Presenter Delegate Functions ------
extension RegisterPresenter : RegisterViewToPresenter {
    
    func setViewDelegate(_ delegate: RegisterPresenterToView) {
        self.registerViewDelegate = delegate
    }
    func registerNewUser(userDetails: dict) {
        self.registerInteractorDelegate.registerNewUser(userDetails: userDetails)
    }
    func registraionResponse(status:Bool,errorMessage:String) {
        self.registerViewDelegate?.registraionResponse(status: status, errorMessage: errorMessage)
    }
    func navigateTo(_ fromVC: UIViewController, _ toVC: UIViewController, _ animation: Bool) {
        self.registerRouterDelegate.navigateTo(fromVC, toVC, true)
    }
    
}
