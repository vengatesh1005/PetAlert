//
//  Extension ViewController + UIView.swift
//  PetAlert
//
//  Created by vengatesh.c on 03/11/24.
//

import Foundation
import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces
var activityIndicatorHoldingViewTag: Int { return 999999 }
//MARK: ------  ViewController Enum For Navigation  ------
enum getViewController {
    case splashScreen
    case welcomeScreen
    case loginScreen
    case signupScreen
    case homeScreen
    case mapScreen
    case petListScreen
    var instance: UIViewController {
        switch self
        {
        case .splashScreen :
            return SplashViewController.instantiate()
        case .welcomeScreen:
            return WelcomeViewController.instantiate()
        case .loginScreen:
            return LoginViewController.instantiate()
        case .signupScreen:
            return RegisterViewController.instantiate()
        case .homeScreen:
            return HomeViewController.instantiate()
        case .mapScreen:
            return MapViewController.instantiate()
        case .petListScreen:
            return LostPetListsViewController.instantiate()
        }
    }
}
//MARK: ------  UserDefaults Handler ------
open class UserDefaultPreferenceHandler {
    //MARK: - Set UserDefaultValue
    class func setUserDefaultValue(_ value:Any, key:String)
    {
        let userDefault = UserDefaults.standard
        userDefault.set(value, forKey: key)
        userDefault.synchronize()
    }
    
    //MARK: - Remove UserDefaultValue
    class func removeUserDefaultData(){
        let userDefault = UserDefaults.standard
        let domain = Bundle.main.bundleIdentifier!
        userDefault.removePersistentDomain(forName: domain)
        userDefault.synchronize()
    }
    //MARK: - Store User Information to UserDefaults
    class func storeloginStatus(status:Bool)
    {
        setUserDefaultValue(status, key: userDefaultsKeys.isloggedIn.description)
        setUserDefaultValue(currentUserName, key: userDefaultsKeys.username.description)
        setUserDefaultValue(currentUserEmail, key: userDefaultsKeys.usermail.description)
        setUserDefaultValue(currentUserID, key: userDefaultsKeys.userid.description)
    }
    //MARK: - Get User Information from UserDefaults
    class func getUserLoginStatus(on : String)
    {
        print("****** User Status On \(on) ******")
        let userDefault = UserDefaults.standard
        isUserLoggedIn = userDefault.bool(forKey: userDefaultsKeys.isloggedIn.description)
        if let name = userDefault.string(forKey: userDefaultsKeys.username.description) {
            currentUserName = name
        }
        if let mail = userDefault.string(forKey: userDefaultsKeys.usermail.description) {
            currentUserEmail = mail
        }
        if let id = userDefault.string(forKey: userDefaultsKeys.userid.description) {
            currentUserID = id
        }
        print("isUserLoggedIn -",isUserLoggedIn)
        print("currentUserName -",currentUserName)
        print("currentUserEmail -",currentUserEmail)
        print("currentUserID -",currentUserID)
        
    }
}

//MARK: - Extension
extension UIViewController {
    
    //MARK: - Alert
    func showAlert(title: String, message: String, okActionTitle: String) {
        let alertView = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
        let okAction = UIAlertAction(title: okActionTitle, style: .default)
        alertView.addAction(okAction)
        self.present(alertView, animated: true)
    }
    //MARK: - Alert with Completion Handler
    func showAlertWithCompletionHandler(title: String, message: String, options: String..., completion: @escaping (Int) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, option) in options.enumerated() {
            alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                completion(index)
            }))
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Keyboard Show and Hide on Tap
    @objc func hideKeyboardOnTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: - ViewController Instantiate
    class func instantiate<T: UIViewController>() -> T {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: self)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
    
    //MARK: - Activity Loader
    func startActivityIndicator(){
        DispatchQueue.main.async{
            //create holding view
            let holdingView = UIView(frame: UIScreen.main.bounds)
            holdingView.backgroundColor = .black
            holdingView.alpha = 0.3
            
            //Add the tag so we can find the view in order to remove it later
            holdingView.tag = activityIndicatorHoldingViewTag
            
            //create activity indicator
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.color = .white
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            
            //Start animating and add the view
            activityIndicator.startAnimating()
            holdingView.addSubview(activityIndicator)
            self.view.addSubview(holdingView)
        }
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async{
            //Here we find the `UIActivityIndicatorView` and remove it from the view
            if let holdingView = self.view.subviews.filter({ $0.tag == activityIndicatorHoldingViewTag}).first {
                holdingView.removeFromSuperview()
            }
        } }
}


//MARK: -
extension UIView {
    
    //MARK: - UIButton/UIView Setup
    func roundCorners(_ corners : UIRectCorner, radius : CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    //MARK: - UIButton/UIView Draw Border
    func drawBorder()
    {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.systemGray4.cgColor
    }
}

//MARK: -
extension UIButton {
    
    //MARK: - Button Configuration for (iOS 15.0,*)
    func buttonConfiguration()
    {
        self.configuration?.titleTextAttributesTransformer =
        UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: AppFontSize!, weight: .bold)
            return outgoing
        }
    }
}

//MARK: -
extension UITextField {
    
    //MARK: - Setup Password Show / Hide Button
    
    func enablePasswordToggle(){
        let button = UIButton(type: .custom)
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -20, bottom: 0, trailing: 0)
        if Device == .pad {
            configuration.buttonSize = .large
        } else {
            configuration.buttonSize = .small
        }
        button.configuration = configuration
        setPasswordIcon(button)
        button.addTarget(self, action: #selector(self.togglePasswordVisibility), for: .touchUpInside)
        self.addSubview(button)
        self.rightView = button
        self.rightViewMode = .always
    }
    func setPasswordIcon(_ button: UIButton) {
        if(isSecureTextEntry){
            button.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        }else{
            button.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        }
    }
    @objc func togglePasswordVisibility(_ sender: Any) {
        self.isSecureTextEntry = !self.isSecureTextEntry
        setPasswordIcon(sender as! UIButton)
    }
}

//MARK: -
extension UITextView {
    
    //MARK: - Setup TextView Border
    func setupTextView()
    {
        self.textColor = UIColor.lightGray
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.systemGray4.cgColor
        self.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
//MARK: -
extension UIImageView {
    
    //MARK: - Setup Rounded Image
    func setRoundedImage()
    {
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.systemGray4.cgColor
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}

//MARK: -
extension UINavigationController {
    //MARK: - Pop Navigation
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            popToViewController(vc, animated: animated)
        }
    }
}

