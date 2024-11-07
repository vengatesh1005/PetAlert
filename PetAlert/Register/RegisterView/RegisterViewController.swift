//
//  RegisterViewController.swift
//  PetAlert
//
//  Created by vengatesh.c on 03/11/24.
//

import UIKit

class RegisterViewController: UIViewController,UITextFieldDelegate,RegisterPresenterToView {
    
    //MARK: ------  IBOutlet ------
    @IBOutlet var userNameTxtFld: UITextField!
    @IBOutlet var emailTxtFld: UITextField!
    @IBOutlet var passwordTxtFld: UITextField!
    @IBOutlet var confirmPasswordTxtFld: UITextField!
    @IBOutlet var registerButtonOutlet: UIButton!
    @IBOutlet var subViewMain: UIView!
    
    //MARK: ------  Variables and Delegate Objects  ------
    private let validationServices = Validation()
    weak fileprivate var registerViewDelegate: RegisterViewToPresenter?
    fileprivate var registerViewPresenterobj: RegisterPresenter!
    
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
    
    // MARK: IBActions
    @IBAction func registerButtonAction(_ sender: Any) {
        self.startActivityIndicator()
        var userDict = dict()
        userDict["name"] = userNameTxtFld.text
        userDict["email"] = emailTxtFld.text
        userDict["password"] = passwordTxtFld.text
        userDict["confirm_password"] = confirmPasswordTxtFld.text
        let status = validationServices.validateTextFields(userDict: userDict)
        if status == .validationSucceeded
        {
            registerViewDelegate?.registerNewUser(userDetails: userDict)
        } else {
            self.stopActivityIndicator()
            showAlert(title: "Registration", message: status.errorDescription ?? userRegistrationStatus.unknownError.errorDescription!, okActionTitle: "OK")
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: UITextFiledDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    // MARK: Registration Response from FireBase
    func registraionResponse(status: Bool, errorMessage: String) {
        self.stopActivityIndicator()
        if status {
            self.clearFieldsAfterSubmission()
            self.showAlertWithCompletionHandler(title: "Registration Successful", message: "You're all set! Your account has been created successfully.", options: "Login Now") { option in
                self.navigationController?.popViewController(animated: true)
            }
        } else
        {
            showAlert(title: "Registration Failed", message: errorMessage, okActionTitle: "OK")
        }
    }
}

// MARK: -  Extension
extension RegisterViewController
{
    //MARK: ------  Page Setup  ------
    func setupView()
    {
        hideKeyboardOnTap()
        passwordTxtFld.enablePasswordToggle()
        confirmPasswordTxtFld.enablePasswordToggle()
        
        self.registerViewPresenterobj = RegisterPresenter()
        self.registerViewDelegate =  self.registerViewPresenterobj
        self.registerViewDelegate?.setViewDelegate(self)
    }
    
    func buttonSetupView()
    {
        //Setup corner radius dynamically
        registerButtonOutlet.roundCorners(.allCorners, radius: registerButtonOutlet.frame.height / 2)
        //Button Configuration for (iOS 15.0,*)
        registerButtonOutlet.buttonConfiguration()
        registerButtonOutlet.layoutIfNeeded()
    }
    
    func clearFieldsAfterSubmission() {
        self.userNameTxtFld.text = ""
        self.passwordTxtFld.text = ""
        self.emailTxtFld.text = ""
        self.confirmPasswordTxtFld.text = ""
    }
}

