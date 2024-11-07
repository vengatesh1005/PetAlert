//
//  LoginProtocols.swift
//  PetAlert
//
//  Created by vengatesh.c on 04/11/24.
//

import Foundation
import UIKit

//MARK: ------  View to Presenter ------
protocol LoginViewToPresenter : AnyObject
{
    func setViewDelegate(_ delegate: LoginPresenterToView)
    func checkUserWithFirebase(email:String,password:String)
    func navigateTo(_ fromVC: UIViewController, _ toVC: UIViewController, _ animation: Bool)
}

//MARK: ------  Presenter to Interactor ------
protocol LoginPresenterToInteractor : AnyObject {
    func setInteractorDelegate(_ delegate:LoginPresenter)
    func checkUserWithFirebase(email:String,password:String)
}

//MARK: ------  Presenter to Router ------
protocol LoginPresenterToRouter : AnyObject {
    func navigateTo(_ fromVC: UIViewController, _ toVC: UIViewController, _ animation: Bool)
}

//MARK: ------  Presenter to View ------
protocol LoginPresenterToView : AnyObject {
    func loginResponse(status:Bool,errorMessage:String)
}
