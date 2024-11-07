//
//  LoginViewController.swift
//  PetAlert
//
//  Created by vengatesh.c on 03/11/24.
//

import UIKit

class LoginViewController: UIViewController,LoginPresenterToView {
    
    //MARK: ------  IBOutlet ------
    @IBOutlet var emailTxtFld: UITextField!
    @IBOutlet var passwordTxtFld: UITextField!
    @IBOutlet var loginScreenButtonsOutletCollection: [UIButton]!
    
    //MARK: ------  Variables and Delegate Objects  ------
    weak fileprivate var loginViewDelegate: LoginViewToPresenter?
    fileprivate var loginViewPresenterobj: LoginPresenter!
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        DispatchQueue.main.async {
            self.buttonSetupView()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        clearFieldsAfterSubmission()
    }
    
    // MARK: IBActions
    @IBAction func loginButtonAction(_ sender: Any) {
        
        guard let email = emailTxtFld.text,Validation().isValidMail(emailID: email) else { return self.showAlert(title: "Login Error", message: userRegistrationStatus.invalidEmail.errorDescription!, okActionTitle: "OK")}
        guard let password = passwordTxtFld.text, !password.isEmpty else { return self.showAlert(title: "Login Error", message: "Please Enter Password", okActionTitle: "OK")}
        self.startActivityIndicator()
        self.loginViewDelegate?.checkUserWithFirebase(email: email, password: password)
    }
    
    @IBAction func signupButtonAction(_ sender: Any) {
        self.loginViewDelegate?.navigateTo(self, getViewController.signupScreen.instance, true)
    }
    
    @IBAction func viewlostPetsButtonAction(_ sender: Any) {
        self.loginViewDelegate?.navigateTo(self, getViewController.petListScreen.instance, true)
    }
    
    // MARK: Login Response
    func loginResponse(status: Bool, errorMessage: String) {
        self.stopActivityIndicator()
        if status {
            print("Login successful")
            clearFieldsAfterSubmission()
            self.loginViewDelegate?.navigateTo(self, getViewController.homeScreen.instance, true)
        } else
        {
            showAlert(title: "Login Failed", message: errorMessage, okActionTitle: "OK")
        }
    }
}
// MARK: -  Extension
extension LoginViewController
{
    //MARK: ------  Page Setup  ------
    func setupView()
    {
        hideKeyboardOnTap()
        passwordTxtFld.enablePasswordToggle()
        
        self.loginViewPresenterobj = LoginPresenter()
        self.loginViewDelegate =  self.loginViewPresenterobj
        self.loginViewDelegate?.setViewDelegate(self)
    }
    
    func buttonSetupView()
    {
        //Setup corner radius dynamically and Button Configuration for (iOS 15.0,*)
        for button in loginScreenButtonsOutletCollection
        {
            button.roundCorners(.allCorners, radius: button.frame.height / 2)
            button.buttonConfiguration()
            button.layoutIfNeeded()
        }
    }
    
    func clearFieldsAfterSubmission() {
        self.emailTxtFld.text = ""
        self.passwordTxtFld.text = ""
    }
}
