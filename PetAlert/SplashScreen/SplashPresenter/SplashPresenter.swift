//
//  SplashPresenter.swift
//  PetAlert
//
//  Created by vengatesh.c on 03/11/24.
//

import Foundation
import UIKit

class SplashPresenter : NSObject
{
    //MARK: ------  Presenter Delegate Obejects ------
    
    weak fileprivate var splashViewDelegate:SplashPresenterToView?
    weak fileprivate var splashInteractorDelegate:SplashPresenterToInteractor!
    fileprivate var splashInteractorObj:SplashInteractor!
    weak fileprivate var splashRouterDelegate:SplashPresenterToRouter!
    fileprivate var splashRouterObj:SplashRouter!
    
    override init() {
        super.init()
        
        self.splashInteractorObj = SplashInteractor()
        self.splashInteractorDelegate = self.splashInteractorObj
        self.splashInteractorDelegate?.setInteractorDelegate(self)
        
        self.splashRouterObj = SplashRouter()
        self.splashRouterDelegate = self.splashRouterObj
    }
}

//MARK: ------  Presenter Delegate Functions ------
extension SplashPresenter : SplashViewToPresenter
{
    func setViewDelegate(_ delegate: SplashPresenterToView) {
        self.splashViewDelegate = delegate
    }
    
    func getNextScreenAfterSplash() {
        self.splashInteractorDelegate.getNextScreenAfterSplash()
        
    }
    func destinationVC(_ destinationVC:UIViewController?)
    {
        self.splashViewDelegate?.nextScreenAfterSplash(destinationVC)
    }
    func navigateTo(_ fromVC: UIViewController, _ toVC: UIViewController, _ animation: Bool) {
        self.splashRouterDelegate.navigateTo(fromVC, toVC, animation)
    }
}
