//
//  RegisterProtocols.swift
//  PetAlert
//
//  Created by vengatesh.c on 03/11/24.
//

import Foundation
import UIKit
typealias dict = [String:String]

//MARK: ------  View to Presenter ------
protocol RegisterViewToPresenter : AnyObject {
    func setViewDelegate(_ delegate:RegisterPresenterToView)
    func registerNewUser(userDetails:dict)
    func navigateTo(_ fromVC: UIViewController, _ toVC: UIViewController, _ animation: Bool)
}

//MARK: ------  Presenter to Interactor ------
protocol RegisterPresenterToInteractor : AnyObject {
    func setInteractorDelegate(_ delegate:RegisterPresenter)
    func registerNewUser(userDetails:dict)
}

//MARK: ------  Presenter to Router ------
protocol RegisterPresenterToRouter : AnyObject {
    func navigateTo(_ fromVC: UIViewController, _ toVC: UIViewController, _ animation: Bool)
}

//MARK: ------  Presenter to View ------
protocol RegisterPresenterToView : AnyObject {
    func registraionResponse(status:Bool,errorMessage:String)
}

