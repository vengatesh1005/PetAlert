//
//  SplashInteractor.swift
//  PetAlert
//
//  Created by vengatesh.c on 03/11/24.
//

import Foundation
import UIKit

class SplashInteractor : NSObject
{
    //MARK: ------  Interactor Delegate Obeject ------
    
    fileprivate weak var presentorDelegate:SplashPresenter?
    
    // MARK: GetUserCurrentStatusOnSplash
    func checkUserStatusOnSplash() -> UIViewController
    {
        //Splash Screen
        var currentUserScreen = getViewController.splashScreen.instance
        
        if isUserLoggedIn
        {
            //Navigate to Home Screen
            currentUserScreen = getViewController.homeScreen.instance
        } else
        {
            //Navigate to Welcome Screen
            currentUserScreen = getViewController.welcomeScreen.instance
        }
        return currentUserScreen
    }
}

//MARK: ------  Interactor Delegate Functions ------
extension SplashInteractor : SplashPresenterToInteractor
{
    func setInteractorDelegate(_ delegate: SplashPresenter) {
        self.presentorDelegate = delegate
    }
    
    func getNextScreenAfterSplash() {
        self.presentorDelegate?.destinationVC(checkUserStatusOnSplash())
    }
}
