//
//  SplashProtocols.swift
//  PetAlert
//
//  Created by vengatesh.c on 03/11/24.
//

import Foundation
import UIKit

//MARK: ------  View to Presenter ------
protocol SplashViewToPresenter : AnyObject {
    func setViewDelegate(_ delegate:SplashPresenterToView)
    func getNextScreenAfterSplash()
    func destinationVC(_ destinationVC:UIViewController?)
    func navigateTo(_ fromVC: UIViewController, _ toVC: UIViewController, _ animation: Bool)
}

//MARK: ------  Presenter to Interactor ------
protocol SplashPresenterToInteractor : AnyObject {
    func setInteractorDelegate(_ delegate:SplashPresenter)
    func getNextScreenAfterSplash()
}

//MARK: ------  Presenter to Router ------
protocol SplashPresenterToRouter : AnyObject {
    func navigateTo(_ fromVC: UIViewController, _ toVC: UIViewController, _ animation: Bool)
}

//MARK: ------  Presenter to View ------
protocol SplashPresenterToView : AnyObject {
    func nextScreenAfterSplash(_ VC: UIViewController?)
}
