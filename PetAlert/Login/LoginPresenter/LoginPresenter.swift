//
//  LoginPresenter.swift
//  PetAlert
//
//  Created by vengatesh.c on 04/11/24.
//

import Foundation
import UIKit
class LoginPresenter : NSObject {
    
    //MARK: ------  Presenter Delegate Obejects ------
    
    weak fileprivate var loginViewDelegate:LoginPresenterToView?
    weak fileprivate var loginInteractorDelegate:LoginPresenterToInteractor!
    fileprivate var loginInteractorObj:LoginInteractor!
    weak fileprivate var loginRouterDelegate:LoginPresenterToRouter!
    fileprivate var loginRouterObj:LoginRouter!
    
    override init() {
        super.init()
        
        self.loginInteractorObj = LoginInteractor()
        self.loginInteractorDelegate = self.loginInteractorObj
        self.loginInteractorDelegate?.setInteractorDelegate(self)
        
        self.loginRouterObj = LoginRouter()
        self.loginRouterDelegate = self.loginRouterObj
    }
}

//MARK: ------  Presenter Delegate Functions ------
extension LoginPresenter : LoginViewToPresenter {
    func setViewDelegate(_ delegate: LoginPresenterToView) {
        self.loginViewDelegate = delegate
    }
    
    func checkUserWithFirebase(email:String,password:String) {
        self.loginInteractorDelegate.checkUserWithFirebase(email:email,password:password)
    }
    
    func navigateTo(_ fromVC: UIViewController, _ toVC: UIViewController, _ animation: Bool) {
        self.loginRouterDelegate.navigateTo(fromVC, toVC, animation)
    }
    
    func loginResponse(status: Bool, errorMessage: String) {
        self.loginViewDelegate?.loginResponse(status: status, errorMessage: errorMessage)
    }
}
