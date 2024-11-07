//
//  HomeViewController.swift
//  PetAlert
//
//  Created by vengatesh.c on 04/11/24.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class HomeViewController: UIViewController {
    //MARK: ------  IBOutlet ------
    @IBOutlet var logoImg: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var petNameTxtFld: UITextField!
    @IBOutlet var petDescriptionTxtView: UITextView!
    @IBOutlet var petSpeciesTxtFld: UITextField!
    @IBOutlet var lastSeenLocationLabel: UILabel!
    @IBOutlet var photoTxtLabel: UILabel!
    @IBOutlet var petPhotoImageView: UIImageView!
    @IBOutlet var contactTxtView: UITextView!
    @IBOutlet var submitButtonOutlet: UIButton!
    @IBOutlet var uploadPhotoViewOutlet: UIView!
    @IBOutlet var locationViewOutlet: UIView!
    @IBOutlet var lostPetListView: UIView!
    @IBOutlet var viewlostButtonOutlet: UIButton!
    
    //MARK: ------  Variables and Delegate Objects  ------
    var petUploadedURL = ""
    let descriptionPlaceholder = "Please provide a brief description of pets."
    let contactPlaceholder = "Please provide your contact information, including your mobile number."
    private let validationServices = Validation()
    weak fileprivate var HomeViewDelegate: HomeViewToPresenter?
    fileprivate var HomeViewPresenterobj: HomePresenter!
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isPetlocationSelected {
            self.lastSeenLocationLabel.text = "Pet Lost Location : \(petLostLocationAddress)"
            isPetlocationSelected = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        DispatchQueue.main.async {
            self.buttonSetupView()
        }
    }
    
    // MARK: IBActions
    @objc func uploadPhotoAction()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func lostlocationSelectionButtonAction(_ sender: Any) {
        isPetlocationSelected = true
        isMapRequestFromPetListPage = false
        self.HomeViewDelegate?.navigateTo(self, getViewController.mapScreen.instance, true)
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        
        var userDict = dict()
        userDict["petname"] = self.petNameTxtFld.text
        userDict["petspecies"] = self.petSpeciesTxtFld.text
        userDict["petdescription"] = (self.petDescriptionTxtView.text == descriptionPlaceholder) ? "" : self.petDescriptionTxtView.text
        userDict["petlostaddress"] = petLostLocationAddress
        userDict["petlostlocationlat"] = (petLostLocation != nil) ? "\(petLostLocation.coordinate.latitude)" : ""
        userDict["petlostlocationlong"] = (petLostLocation != nil) ? "\(petLostLocation.coordinate.longitude)" : ""
        userDict["petphoto"] = petUploadedURL
        userDict["contactdetails"] = (self.contactTxtView.text == contactPlaceholder) ? "" : self.contactTxtView.text
        let status = validationServices.validateLostPetDetailsSubmission(userDict: userDict)
        if status == .validationSucceeded
        {
            self.startActivityIndicator()
            self.HomeViewDelegate?.submitPetDetails(petDetails: userDict)
        } else {
            showAlert(title: "PetAlert Submission", message: status.errorDescription ?? userRegistrationStatus.unknownError.errorDescription!, okActionTitle: "OK")
        }
    }
    
    @IBAction func viewLostPetsButtonAction(_ sender: Any) {
        
        self.HomeViewDelegate?.navigateTo(self, getViewController.petListScreen.instance, true)
    }
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        logoutStatus = true
        UserDefaultPreferenceHandler.removeUserDefaultData()
        self.navigationController?.popToViewController(ofClass: SplashViewController.self,animated: false)
    }
    
}
// MARK: - Extension
extension HomeViewController : UITextViewDelegate {
    
    //MARK: ------  UITextView Delegates  ------
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            if textView == petDescriptionTxtView {
                petDescriptionTxtView.text = descriptionPlaceholder
            } else {
                contactTxtView.text = contactPlaceholder
            }
            textView.textColor = UIColor.lightGray
        }
    }
    
    //MARK: ------  Page Setup  ------
    func setupView() {
        
        self.userNameLabel.text = "Hi" + " " + currentUserName
        viewlostButtonOutlet.buttonConfiguration()
        
        petDescriptionTxtView.text = descriptionPlaceholder
        petDescriptionTxtView.setupTextView()
        contactTxtView.text = contactPlaceholder
        contactTxtView.setupTextView()
        hideKeyboardOnTap()
        
        locationViewOutlet.drawBorder()
        uploadPhotoViewOutlet.drawBorder()
        
        setupImageTapTarget()
        
        self.HomeViewPresenterobj = HomePresenter()
        self.HomeViewDelegate =  self.HomeViewPresenterobj
        self.HomeViewDelegate?.setViewDelegate(self)
    }
    
    func buttonSetupView()
    {
        //Setup corner radius dynamically
        self.submitButtonOutlet.roundCorners(.allCorners, radius: self.submitButtonOutlet.frame.height / 2)
        //Button Configuration for (iOS 15.0,*)
        self.submitButtonOutlet.buttonConfiguration()
        self.submitButtonOutlet.layoutIfNeeded()
    }
    
    func setupImageTapTarget()
    {
        let tap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.uploadPhotoAction))
        petPhotoImageView.addGestureRecognizer(tap)
        petPhotoImageView.isUserInteractionEnabled = true
        
    }
    
    func clearFieldsAfterSubmission()
    {
        self.petNameTxtFld.text = ""
        self.petSpeciesTxtFld.text = ""
        self.petDescriptionTxtView.text = descriptionPlaceholder
        self.lastSeenLocationLabel.text = "Click here to choose where you were last seen"
        self.petPhotoImageView.image = UIImage(systemName: "photo")
        self.contactTxtView.text = contactPlaceholder
        self.petDescriptionTxtView.textColor = UIColor.lightGray
        self.contactTxtView.textColor = UIColor.lightGray
        
        petUploadedURL = ""
        petLostLocation = nil
        petLostLocationAddress = ""
    }
}

// MARK: - UIImagePikcer
extension HomeViewController :  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: ------  UIImagePikcer Delegates  ------
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let choosenImage = info[.originalImage] as? UIImage
        var imageName = "petphoto"
        if let imageUrl = info[.imageURL] as? URL {
            imageName = imageUrl.lastPathComponent
            print("file name",imageName)
        }
        
        petPhotoImageView.image = choosenImage
        dismiss(animated: true, completion: {
            self.startActivityIndicator()
            FireBaseManager.uploadImageToFireBase(image: choosenImage!, imageName: imageName) { status, imageURL, error  in
                self.stopActivityIndicator()
                if status {
                    self.petUploadedURL = imageURL
                    self.showAlert(title: "PetAlert", message: "Image Uploaded Successfully", okActionTitle: "OK")
                } else {
                    self.showAlert(title: "Upload Failed", message: error, okActionTitle: "OK")
                }
            }
        })
    }
}

//MARK: ------  Submission Response from FireBase  ------
extension HomeViewController : HomePresenterToView {
    func HomeResponse(status: Bool, errorMessage: String) {
        self.stopActivityIndicator()
        if status {
            self.clearFieldsAfterSubmission()
            self.showAlertWithCompletionHandler(title: "PetAlert Submission", message: "Thank you for registering. Your pet has been listed in the lost pet details. Please click 'OK' to view the list", options: "OK") { button in
                self.HomeViewDelegate?.navigateTo(self, getViewController.petListScreen.instance, true)
            } } else
        {
                showAlert(title: "PetAlert Submission", message: errorMessage, okActionTitle: "OK")
            }
    }
}
