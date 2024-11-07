//
//  LostPetPresenter.swift
//  PetAlert
//
//  Created by vengatesh.c on 06/11/24.
//

import Foundation
import UIKit
class LostPetPresenter : NSObject {
    //MARK: ------  Presenter Delegate Obejects ------
    weak fileprivate var LostPetViewDelegate:LostPetPresenterToView?
    weak fileprivate var LostPetInteractorDelegate:LostPetPresenterToInteractor!
    fileprivate var LostPetInteractorObj:LostPetInteractor!
    weak fileprivate var LostPetRouterDelegate:LostPetPresenterToRouter!
    fileprivate var LostPetRouterObj:LostPetRouter!
    
    override init() {
        super.init()
        
        self.LostPetInteractorObj = LostPetInteractor()
        self.LostPetInteractorDelegate = self.LostPetInteractorObj
        self.LostPetInteractorDelegate?.setInteractorDelegate(self)
        
        self.LostPetRouterObj = LostPetRouter()
        self.LostPetRouterDelegate = self.LostPetRouterObj
    }
}

extension LostPetPresenter : LostPetViewToPresenter {
    
    //MARK: ------  Presenter Delegate Functions ------
    func setViewDelegate(_ delegate: LostPetPresenterToView) {
        self.LostPetViewDelegate = delegate
    }
    func loadLostPetDetailsFromFireBase() {
        self.LostPetInteractorDelegate.loadLostPetDetailsFromFireBase()
    }
    func navigateTo(_ fromVC: UIViewController, _ toVC: UIViewController, _ animation: Bool) {
        self.LostPetRouterDelegate.navigateTo(fromVC, toVC, animation)
    }
    func SuccessPetListResponse(status: Bool, data:[dict]) {
        self.LostPetViewDelegate?.SuccessPetListResponse(status: status, data: data)
    }
    func FailurePetListResponse(status: Bool) {
        self.LostPetViewDelegate?.FailurePetListResponse(status: status)
    }
    
}
