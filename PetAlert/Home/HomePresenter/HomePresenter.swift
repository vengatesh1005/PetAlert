//
//  HomeViewController.swift
//  PetAlert
//
//  Created by vengatesh.c on 04/11/24.
//

import Foundation
import UIKit
class HomePresenter : NSObject {
    //MARK: ------  Presenter Delegate Obejects ------
    weak fileprivate var HomeViewDelegate:HomePresenterToView?
    weak fileprivate var HomeInteractorDelegate:HomePresenterToInteractor!
    fileprivate var HomeInteractorObj:HomeInteractor!
    weak fileprivate var HomeRouterDelegate:HomePresenterToRouter!
    fileprivate var HomeRouterObj:HomeRouter!
    
    override init() {
        super.init()
        
        self.HomeInteractorObj = HomeInteractor()
        self.HomeInteractorDelegate = self.HomeInteractorObj
        self.HomeInteractorDelegate?.setInteractorDelegate(self)
        
        self.HomeRouterObj = HomeRouter()
        self.HomeRouterDelegate = self.HomeRouterObj
    }
}
//MARK: ------  Presenter Delegate Functions ------
extension HomePresenter : HomeViewToPresenter {
    
    func setViewDelegate(_ delegate: HomePresenterToView) {
        self.HomeViewDelegate = delegate
    }
    func submitPetDetails(petDetails: dict) {
        self.HomeInteractorDelegate.submitPetDetails(petDetails: petDetails)
    }
    func navigateTo(_ fromVC: UIViewController, _ toVC: UIViewController, _ animation: Bool) {
        self.HomeRouterDelegate.navigateTo(fromVC, toVC, animation)
    }
    func HomeResponse(status: Bool, errorMessage: String) {
        self.HomeViewDelegate?.HomeResponse(status: status, errorMessage: errorMessage)
    }
}
