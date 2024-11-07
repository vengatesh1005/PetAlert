//
//  SplashViewController.swift
//  PetAlert
//
//  Created by vengatesh.c on 03/11/24.
//

import UIKit

class SplashViewController: UIViewController {
    
    //MARK: ------  IBOutlet ------
    @IBOutlet var logoSplashImageView: UIImageView!
    
    //MARK: ------  Variables and Delegate Objects  ------
    weak fileprivate var splashViewDelegate: SplashViewToPresenter?
    fileprivate var splashViewPresenterobj: SplashPresenter!
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.splashViewDelegate?.getNextScreenAfterSplash()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if logoutStatus {
            logoSplashImageView.addSymbolEffect(.variableColor,animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.logoSplashImageView.removeAllSymbolEffects()
                self.splashViewDelegate?.navigateTo(self, getViewController.loginScreen.instance, false)
            }
        }
    }
    
    //TODO: - Setup
    func setupView()
    {
        logoSplashImageView.addSymbolEffect(.variableColor,animated: true)
        self.splashViewPresenterobj = SplashPresenter()
        self.splashViewDelegate =  self.splashViewPresenterobj
        self.splashViewDelegate?.setViewDelegate(self)
    }
}

// MARK: - Extension
extension SplashViewController : SplashPresenterToView {
    
    func nextScreenAfterSplash(_ VC: UIViewController?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.logoSplashImageView.removeAllSymbolEffects()
            self.splashViewDelegate?.navigateTo(self, VC!, false)
        }
    }
}
