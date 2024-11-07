//
//  WelcomeViewController.swift
//  PetAlert
//
//  Created by vengatesh.c on 03/11/24.
//

import UIKit
import Firebase
import FirebaseDatabase

class WelcomeViewController: UIViewController {
    //MARK: ------  IBOutlet ------
    @IBOutlet var mainView: UIView!
    @IBOutlet var subView1: UIView!
    @IBOutlet var subView2: UIView!
    @IBOutlet var petfindImageView: UIImageView!
    @IBOutlet var welcomeTitleLabel: UILabel!
    @IBOutlet var welcomeDescriptionLabel: UILabel!
    @IBOutlet var welcomeDescriptionLabel2: UILabel!
    @IBOutlet var loginButtonHeightConstrain: NSLayoutConstraint!
    @IBOutlet var viewPetsHeightConstrain: NSLayoutConstraint!
    @IBOutlet var signupButtonHeightConstrain: NSLayoutConstraint!
    @IBOutlet var welcomeScreenButtonsOutletCollections: [UIButton]!
    
    //MARK: ------  Variables and Delegate Objects  ------
    weak fileprivate var welcomeViewDelegate: welcomeViewToPresenter?
    fileprivate var welcomeViewPresenterObj: WelcomePresenter!
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.welcomeViewPresenterObj = WelcomePresenter()
        self.welcomeViewDelegate = welcomeViewPresenterObj
        
        setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        DispatchQueue.main.async {
            self.setupView()
        }
    }
    // MARK: IBActions
    @IBAction func loginBtnAction(_ sender: Any) {
        self.welcomeViewDelegate?.navigateTo(self, getViewController.loginScreen.instance, true)
    }
    
    @IBAction func signupBtnAction(_ sender: Any) {
        self.welcomeViewDelegate?.navigateTo(self, getViewController.signupScreen.instance, true)
    }
    
    @IBAction func viewlostPetsBtnAction(_ sender: Any) {
        self.welcomeViewDelegate?.navigateTo(self, getViewController.petListScreen.instance, true)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
// MARK: - Extension
extension WelcomeViewController
{
    //MARK: ------  Page Setup  ------
    func setupView()
    {
        //Setup corner radius dynamically and Button Configuration for (iOS 15.0,*)
        for button in welcomeScreenButtonsOutletCollections
        {
            button.roundCorners(.allCorners, radius: button.frame.height / 2)
            button.buttonConfiguration()
            button.layoutIfNeeded()
        }
    }
}


