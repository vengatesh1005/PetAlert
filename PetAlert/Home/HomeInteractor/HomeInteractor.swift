//
//  HomeInteractor.swift
//  PetAlert
//
//  Created by vengatesh.c on 05/11/24.
//

import Foundation
class HomeInteractor : NSObject {
    //MARK: ------  Interactor Delegate Obejects ------
    fileprivate weak var presentorDelegate:HomePresenter?
}

extension HomeInteractor : HomePresenterToInteractor {
    //MARK: ------  Interactor Delegate Function ------
    
    func setInteractorDelegate(_ delegate: HomePresenter) {
        self.presentorDelegate = delegate
    }
    func submitPetDetails(petDetails: dict) {
        FireBaseManager.submitLostPetDetails(petDetails: petDetails) { status, error in
            self.presentorDelegate?.HomeResponse(status: status, errorMessage: error)
        }
    }
}
