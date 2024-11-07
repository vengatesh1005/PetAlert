//
//  Constants.swift
//  PetAlert
//
//  Created by vengatesh.c on 03/11/24.
//

import Foundation
import UIKit
import CoreLocation

//MARK: ------  Variables for Button Font Size ------
let Device = UIDevice.current.userInterfaceIdiom
private let iPadFontSize = 30.0
private let iPhoneFontSize = 20.0
var AppFontSize : CGFloat? {
    if Device == .pad
    {
        return iPadFontSize
    } else
    {
        return iPhoneFontSize
    }
}
//MARK: ------  Variables for User Information ------
var isUserLoggedIn = false
var currentUserName = ""
var currentUserEmail = ""
var currentUserID = ""
var logoutStatus = false
var userCurrentLocationAddress = ""
var userCurrentLocation : CLLocation!

//MARK: ------  Variables for LostPet Information ------
var petLostLocationAddress = ""
var petLostLocation : CLLocation!
var isPetlocationSelected =  false
var petListDatas = [dict]()
var isMapRequestFromPetListPage = false
var currentPetListData : dict = dict()

//MARK: ------  Registration Error Enum ------
enum userRegistrationStatus {
    case invalidName
    case invalidEmail
    case invalidPassword
    case invalidConfirmPassword
    case validationSucceeded
    case unknownError
    var errorDescription: String? {
        switch self {
        case .invalidName: return "Please Enter Valid User Name.\n(Min 3 characters and Max 16 characters)"
        case .invalidEmail: return "You have entered an invalid email ID"
        case .invalidPassword: return "Please Enter Valid Password.\n(Minimum 6 characters at least 1 Alphabet, 1 Number and 1 Special Character)"
        case .invalidConfirmPassword: return "Password and Confirm Password does not match"
        case .validationSucceeded: return "Validation Done"
        case .unknownError: return "Oops! Something went wrong."
        }
    }
}

//MARK: ------  LostPet Submisison Error Enum ------
enum lostPetSubmission {
    case emptyPetName
    case emptySpeciesName
    case emptyDescription
    case emptyLostLocation
    case emptyPhoto
    case emptyContactDetails
    case validationSucceeded
    case unknownError
    var errorDescription: String? {
        switch self {
        case .emptyPetName: return "Please Enter Valid Pet Name"
        case .emptySpeciesName: return "Please Enter Valid Species Name"
        case .emptyDescription: return "Please Enter Valid Description.\n(Min 10 characters)"
        case .emptyLostLocation: return "Please Select Valid Lost Location"
        case .emptyPhoto: return "Please Select Valid Pet Photo"
        case .emptyContactDetails: return "Please Enter Valid Contact Details.\n(Min 15 characters)"
        case .validationSucceeded: return "Validation Done"
        case .unknownError: return "Oops! Something went wrong."
        }
    }
}

//MARK: ------  UserDefaults Keys ------
enum userDefaultsKeys : String {
    case isloggedIn
    case username
    case usermail
    case userid
    var description: String {
        return self.rawValue
    }
}
