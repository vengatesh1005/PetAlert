//
//  RegisterInteractor.swift
//  PetAlert
//
//  Created by vengatesh.c on 03/11/24.
//

import Foundation

class RegisterInteractor : NSObject {
    //MARK: ------  Interactor Delegate Obejects ------
    fileprivate weak var presentorDelegate:RegisterPresenter?
}

//MARK: ------  Interactor Delegate Function ------
extension RegisterInteractor : RegisterPresenterToInteractor {
    
    func setInteractorDelegate(_ delegate: RegisterPresenter) {
        self.presentorDelegate = delegate
    }
    
    func registerNewUser(userDetails: dict) {
        FireBaseManager.registerNewUser(data: userDetails) { status, error in
            self.presentorDelegate?.registraionResponse(status: status, errorMessage: error)
        }
    }
}
