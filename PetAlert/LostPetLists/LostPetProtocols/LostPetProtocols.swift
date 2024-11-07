//
//  LostPetProtocols.swift
//  PetAlert
//
//  Created by vengatesh.c on 06/11/24.
//

import Foundation
import UIKit

//MARK: ------  View to Presenter ------
protocol LostPetViewToPresenter : AnyObject
{
    func setViewDelegate(_ delegate: LostPetPresenterToView)
    func navigateTo(_ fromVC: UIViewController, _ toVC: UIViewController, _ animation: Bool)
    func loadLostPetDetailsFromFireBase()
}

//MARK: ------  Presenter to Interactor ------
protocol LostPetPresenterToInteractor : AnyObject {
    func setInteractorDelegate(_ delegate:LostPetPresenter)
    func loadLostPetDetailsFromFireBase()
}

//MARK: ------  Presenter to Router ------
protocol LostPetPresenterToRouter : AnyObject {
    func navigateTo(_ fromVC: UIViewController, _ toVC: UIViewController, _ animation: Bool)
}

//MARK: ------  Presenter to View ------
protocol LostPetPresenterToView : AnyObject {
    func SuccessPetListResponse(status: Bool, data:[dict])
    func FailurePetListResponse(status: Bool)
}
