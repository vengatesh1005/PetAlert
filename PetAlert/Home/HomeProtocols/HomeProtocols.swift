//
//  HomeProtocols.swift
//  PetAlert
//
//  Created by vengatesh.c on 05/11/24.
//

import Foundation
import UIKit

//MARK: ------  View to Presenter ------
protocol HomeViewToPresenter : AnyObject
{
    func setViewDelegate(_ delegate: HomePresenterToView)
    func navigateTo(_ fromVC: UIViewController, _ toVC: UIViewController, _ animation: Bool)
    func submitPetDetails(petDetails:dict)
}

//MARK: ------  Presenter to Interactor ------
protocol HomePresenterToInteractor : AnyObject {
    func setInteractorDelegate(_ delegate:HomePresenter)
    func submitPetDetails(petDetails:dict)
}

//MARK: ------  Presenter to Router ------
protocol HomePresenterToRouter : AnyObject {
    func navigateTo(_ fromVC: UIViewController, _ toVC: UIViewController, _ animation: Bool)
}

//MARK: ------  Presenter to View ------
protocol HomePresenterToView : AnyObject {
    func HomeResponse(status:Bool,errorMessage:String)
}
