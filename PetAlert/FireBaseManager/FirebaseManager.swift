//
//  FirebaseManager.swift
//  PetAlert
//
//  Created by vengatesh.c on 04/11/24.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

//MARK: ------  FireBase Handler  ------
let FireBaseManager = FirebaseManager()
class FirebaseManager {
    //MARK: ------  Register New User With FireBase  ------
    func registerNewUser(data:dict,completionHandler:@escaping(_ status:Bool, _ error: String) -> ())
    {
        Auth.auth().createUser(withEmail: data["email"]!, password: data["password"]! ) { user, error in
            var errorMsg = ""
            if let registerError = error {
                let err = registerError as NSError
                switch err.code {
                case AuthErrorCode.wrongPassword.rawValue:
                    print("wrong password")
                    errorMsg = "Incorrect Password"
                case AuthErrorCode.invalidEmail.rawValue:
                    print("invalid email")
                    errorMsg = "Invalid Email"
                case AuthErrorCode.accountExistsWithDifferentCredential.rawValue:
                    print("accountExistsWithDifferentCredential")
                    errorMsg = "AccountExistsWithDifferentCredential"
                case AuthErrorCode.emailAlreadyInUse.rawValue:
                    print("email is alreay in use")
                    errorMsg = "Email is alreay in use"
                default:
                    print("unknown error: \(err.localizedDescription)")
                    errorMsg = "unknown error: \(err.localizedDescription)"
                }
                completionHandler (false,errorMsg)
            } else {
                if let authResult = user {
                    let user = authResult.user
                    print("Registration", user.email ?? "",user.uid)
                    self.insertDataToFireBase(data: data, userID: user.uid)
                    completionHandler (true,"Success") }
            }
        }
    }
    //MARK: ------  After successful registration, user details are saved to the Firebase Database  ------
    func insertDataToFireBase(data:dict,userID:String)
    {
        var DBRef: DatabaseReference!
        DBRef = Database.database().reference()
        var data = data
        data.removeValue(forKey: "password")
        data.removeValue(forKey: "confirm_password")
        DBRef.child("users").child(userID).setValue(["userdetails":data])
    }
    
    //MARK: ------  User Login by FireBase Auth ------
    func loginUser(email:String,password:String,completionHandler:@escaping(_ status:Bool, _ error: String) -> ())
    {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let authResult = authResult {
                let user = authResult.user
                currentUserEmail = user.email ?? ""
                currentUserID = user.uid
                self.getLoggedInUserNameFromFireBase { status in
                    if status {
                        UserDefaultPreferenceHandler.storeloginStatus(status: true)
                        UserDefaultPreferenceHandler.getUserLoginStatus(on: "Login")
                        print("User has Signed In Email",user.email ?? "")
                        print("User has Signed In ID",user.uid)
                        completionHandler (true,"")
                    } else {
                        completionHandler (false,"Incorrect Email or Password")
                    }
                }
            }
            if let error = error {
                print("Can't Sign in user",error.localizedDescription)
                completionHandler (false,"Incorrect Email or Password")
            }
        }
    }
    //MARK: ------  Submit Lost Pet Details to Firebase Database ------
    func submitLostPetDetails(petDetails:dict,completionHandler:@escaping(_ status:Bool, _ error: String)-> ())
    {
        var DBRef: DatabaseReference!
        DBRef = Database.database().reference()
        DBRef.child("users").child(currentUserID).child("petdetails").childByAutoId().updateChildValues(petDetails) { (error, ref) -> Void in
            if error != nil {
                completionHandler (false,error!.localizedDescription)
            } else {
                self.submitLostPetDetailsToSeparteDB(petDetails: petDetails) { status, error in
                    if status {
                        completionHandler (true,"")
                    } else {
                        completionHandler (false,error)
                    }
                }
            }
        }
    }
    
    //MARK: ------  Store Pet Details to Separte Location ------
    func submitLostPetDetailsToSeparteDB(petDetails:dict,completionHandler:@escaping(_ status:Bool, _ error: String)-> ()) {
        
        var DBRef: DatabaseReference!
        DBRef = Database.database().reference()
        DBRef.child("lostpetdetails").child("petdetails").childByAutoId().updateChildValues(petDetails) { (error, ref) -> Void in
            if error != nil {
                completionHandler (false,error!.localizedDescription)
            } else {
                completionHandler (true,"")
            }
        }
    }
    
    //MARK: ------  Pet Image Upload ------
    func uploadImageToFireBase(image:UIImage,imageName:String,completionHandler:@escaping(_ status:Bool, _ imageURL:String, _ error: String) -> ())
    {
        let DBRef = Storage.storage().reference().child(imageName)
        if let uploadData = image.jpegData(compressionQuality: 0.5)
        {
            DBRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if let error = error { completionHandler (false,"",error.localizedDescription) }
                DBRef.downloadURL(completion: { (url, error) in
                    if let error = error { completionHandler (false,"",error.localizedDescription) }
                    if let imgUrl = url?.absoluteString {
                        print("Image Uploaded URL:",imgUrl)
                        completionHandler (true,imgUrl,"")
                    }
                })
            })
        }
    }
    //MARK: ------  Pet Image Download ------
    func downloadImageFromFireBase(petImageUrl:String,completionHandler:@escaping(_ status:Bool, _ image:UIImage, _ error: String) -> ())
    {
        let DBRef = Storage.storage().reference(forURL: petImageUrl)
        DBRef.downloadURL(completion: { (url, error) in
            do {
                let data = try Data(contentsOf: url!)
                let image = UIImage(data: data as Data)
                completionHandler (true,image!,"")
            } catch {
                print("\(error)")
            }
        })
    }
    
    //MARK: ------  Get Auth User Details by using Auth ID ------
    func getLoggedInUserNameFromFireBase(completionHandler:@escaping(_ status:Bool) -> ())
    {
        var DBRef: DatabaseReference!
        DBRef = Database.database().reference()
        DBRef.child("users").child(currentUserID).child("userdetails").observe(.value, with: { (snapshot) in
            if !snapshot.exists() {
                print("No users found")
                completionHandler (false)
            } else {
                guard let dict = snapshot.value as? [String:String] else {
                    print("Error")
                    completionHandler (false)
                    return
                }
                if let username = dict["name"] {
                    currentUserName = username
                    completionHandler (true)
                }
            }
        })
    }
    //MARK: ------  Get Lost Pet Details Data ------
    func getPetListFromFireBase(onSuccess: @escaping (Bool,[dict]) -> (), onFailure: @escaping (Bool) -> ())
    {
        var DBRef: DatabaseReference!
        DBRef = Database.database().reference()
        DBRef.child("lostpetdetails").child("petdetails").observe(.value, with: { (snapshot) in
            if !snapshot.exists() {
                print("No petdetails found")
                onFailure(false)
            } else {
                petListDatas.removeAll()
                for case let userSnapshot as DataSnapshot in snapshot.children {
                    guard let dict = userSnapshot.value as? [String:String] else {
                        print("Error")
                        onFailure(false)
                        return
                    }
                    petListDatas.append(dict)
                    onSuccess (true, petListDatas)
                }
            }
        })
    }
}
