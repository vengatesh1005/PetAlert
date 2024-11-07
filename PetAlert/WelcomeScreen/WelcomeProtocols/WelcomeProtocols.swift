//
//  WelcomeProtocols.swift
//  PetAlert
//
//  Created by vengatesh.c on 03/11/24.
//

import Foundation
import UIKit

//MARK: ------  View to Presenter ------
protocol welcomeViewToPresenter : NSObject
{
    func navigateTo(_ fromVC: UIViewController, _ toVC: UIViewController, _ animation: Bool)
}

//MARK: ------  Presenter to Router ------
protocol welcomePresenterToRouter : NSObject
{
    func navigateTo(_ fromVC: UIViewController, _ toVC: UIViewController, _ animation: Bool)
}
