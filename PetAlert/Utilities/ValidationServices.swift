//
//  ValidationServices.swift
//  PetAlert
//
//  Created by vengatesh.c on 03/11/24.
//

import Foundation
import GoogleMaps
import GooglePlaces
//MARK: ------  Validation Struct for Form Fields ------
struct Validation
{
    //MARK: ------  Email Validation  ------
    func isValidMail(emailID: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let trimmedString = emailID.trimmingCharacters(in: .whitespaces)
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: trimmedString)
    }
    
    //MARK: ------  Name Validation  ------
    func isValid(name: String) -> Bool {
        let regex = "[A-Za-z]{3,16}"
        let trimmedString = name.trimmingCharacters(in: .whitespaces)
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        let result = test.evaluate(with: trimmedString)
        return result
    }
    
    //MARK: ------  Password Validation  ------
    //Minimum 4 characters at least 1 Alphabet, 1 Number and 1 Special Character:
    func isValidPassword(password: String) -> Bool {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{6,}$"
        let trimmedString = password.trimmingCharacters(in: .whitespaces)
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        let result = passwordTest.evaluate(with: trimmedString)
        return result
    }
    
    //MARK: ------  Registration Screen Validation  ------

    func validateTextFields(userDict:dict) -> userRegistrationStatus {
        
        guard let userName = userDict["name"], isValid(name: userName) else { return .invalidName }
        guard let userEmail = userDict["email"], isValidMail(emailID: userEmail) else {return .invalidEmail}
        guard let userPassword = userDict["password"], isValidPassword(password: userPassword) else {return .invalidPassword}
        guard let userConfirmPassword = userDict["confirm_password"], userPassword == userConfirmPassword else {return .invalidConfirmPassword}
        return .validationSucceeded
    }
    
    //MARK: ------  Lost Pet Details Submission Screen Validation  ------
    func validateLostPetDetailsSubmission(userDict:dict) -> lostPetSubmission {
        
        guard let petname = userDict["petname"], !petname.isEmpty else { return .emptyPetName }
        guard let petspecies = userDict["petspecies"], !petspecies.isEmpty, petspecies.count >= 2 else {return .emptySpeciesName}
        guard let petdescription = userDict["petdescription"], !petdescription.isEmpty, petdescription.count >= 10 else {return .emptyDescription}
        guard let petlostlocationlat = userDict["petlostlocationlat"], !petlostlocationlat.isEmpty else {return .emptyLostLocation}
        guard let petlostlocationlong = userDict["petlostlocationlong"], !petlostlocationlong.isEmpty else {return .emptyLostLocation}
        guard let petphoto = userDict["petphoto"], !petphoto.isEmpty else {return .emptyPhoto}
        guard let contactdetails = userDict["contactdetails"], !contactdetails.isEmpty,contactdetails.count >= 15 else {return .emptyContactDetails}
        return .validationSucceeded
    }
}

//MARK: ------  Fetching Address from location  ------
func getAddressfrom(location:CLLocation,completionHandler:@escaping(_ address:String, _ error: String) -> ())
{
    let geocoder = GMSGeocoder()
    
    geocoder.reverseGeocodeCoordinate(location.coordinate) { response, error in
       
        if let err = error?.localizedDescription
        {
            print("LocationError \(err)")
            completionHandler ("",error?.localizedDescription ?? "Unable to fetch address.")
        }
        if let address = response?.firstResult() {
            let lines = address.lines!
            let address = lines.joined(separator: ", ")
            completionHandler (address,"")
        }
    }
    
}
