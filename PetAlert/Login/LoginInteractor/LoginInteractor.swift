//
//  LoginInteractor.swift
//  PetAlert
//
//  Created by vengatesh.c on 04/11/24.
//

import Foundation

class LoginInteractor : NSObject {
    //MARK: ------  Interactor Delegate Obejects ------
    fileprivate weak var presentorDelegate:LoginPresenter?
}

//MARK: ------  Interactor Delegate Function ------
extension LoginInteractor : LoginPresenterToInteractor {
    
    func setInteractorDelegate(_ delegate: LoginPresenter) {
        self.presentorDelegate = delegate
    }
    
    func checkUserWithFirebase(email:String,password:String) {
        
        FireBaseManager.loginUser(email: email, password: password) { status, error in
            self.presentorDelegate?.loginResponse(status: status, errorMessage: error)
        }
    }
}
