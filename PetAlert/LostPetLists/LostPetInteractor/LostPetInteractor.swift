//
//  LostPetInteractor.swift
//  PetAlert
//
//  Created by vengatesh.c on 06/11/24.
//

import Foundation
class LostPetInteractor : NSObject {
    //MARK: ------  Interactor Delegate Obejects ------
    fileprivate weak var presentorDelegate:LostPetPresenter?
}

extension LostPetInteractor : LostPetPresenterToInteractor {
    //MARK: ------  Interactor Delegate Function ------
    func setInteractorDelegate(_ delegate: LostPetPresenter) {
        self.presentorDelegate = delegate
    }
    func loadLostPetDetailsFromFireBase() {
        FireBaseManager.getPetListFromFireBase { status, data in
            self.presentorDelegate?.SuccessPetListResponse(status: status, data: data)
        } onFailure: { status in
            self.presentorDelegate?.FailurePetListResponse(status: status)
        }
    }
}
