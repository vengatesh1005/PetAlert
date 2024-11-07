//
//  PetAlertTests.swift
//  PetAlertTests
//
//  Created by vengatesh.c on 01/11/24.
//

import XCTest
import CoreLocation
@testable import PetAlert

final class PetAlertTests: XCTestCase {

    private let validationServices = Validation()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: TEST CASES FOR REGISTRAION VALIDATION
    
    func testEmptyNameThrowsError() throws
    {
        var userDict = dict()
        userDict["name"] = ""
        let expectedError = userRegistrationStatus.invalidName
        let validateError = validationServices.validateTextFields(userDict: userDict)
        XCTAssertEqual(expectedError, validateError)
    }
    
    func testInValidEmailThrowsError() throws
    {
        var userDict = dict()
        userDict["name"] = "john"
        userDict["email"] = "john"
        let expectedError = userRegistrationStatus.invalidEmail
        let validateError = validationServices.validateTextFields(userDict: userDict)
        XCTAssertEqual(expectedError, validateError)
    }
    
    func testInValidPasswordThrowsError() throws
    {
        var userDict = dict()
        userDict["name"] = "john"
        userDict["email"] = "john@gmail.com"
        userDict["password"] = "joh"
        let expectedError = userRegistrationStatus.invalidPassword
        let validateError = validationServices.validateTextFields(userDict: userDict)
        XCTAssertEqual(expectedError, validateError)
    }
    
    func testInValidConfrimPasswordThrowsError() throws
    {
        var userDict = dict()
        userDict["name"] = "john"
        userDict["email"] = "john@gmail.com"
        userDict["password"] = "john@123"
        userDict["confirm_password"] = "john"
        let expectedError = userRegistrationStatus.invalidConfirmPassword
        let validateError = validationServices.validateTextFields(userDict: userDict)
        XCTAssertEqual(expectedError, validateError)
    }
    
    func testValidData() throws
    {
        var userDict = dict()
        userDict["name"] = "john"
        userDict["email"] = "john@gmail.com"
        userDict["password"] = "john@123"
        userDict["confirm_password"] = "john@123"
        
        let expectedSuccess = userRegistrationStatus.validationSucceeded
        let validationMessage = validationServices.validateTextFields(userDict: userDict)
        XCTAssertEqual(expectedSuccess, validationMessage)
    }
    
    // MARK: TEST CASES FOR PET DATA SUBMISSION VALIDATION

    func testEmptyPetNameThrowsError() throws
    {
        var userDict = dict()
        userDict["petname"] = ""
        let expectedError = lostPetSubmission.emptyPetName
        let validateError = validationServices.validateLostPetDetailsSubmission(userDict: userDict)
        XCTAssertEqual(expectedError, validateError)
    }
    
    func testInValidPetSpeciesThrowsError() throws
    {
        var userDict = dict()
        userDict["petname"] = "Tommy"
        userDict["petspecies"] = ""
        let expectedError = lostPetSubmission.emptySpeciesName
        let validateError = validationServices.validateLostPetDetailsSubmission(userDict: userDict)
        XCTAssertEqual(expectedError, validateError)
    }
    
    func testInValidPetDescritpionThrowsError() throws
    {
        var userDict = dict()
        userDict["petname"] = "Tommy"
        userDict["petspecies"] = "Dog"
        userDict["petdescription"] = ""
        let expectedError = lostPetSubmission.emptyDescription
        let validateError = validationServices.validateLostPetDetailsSubmission(userDict: userDict)
        XCTAssertEqual(expectedError, validateError)
    }
    
    func testInValidPetContactThrowsError() throws
    {
        var userDict = dict()
        userDict["petname"] = "Tommy"
        userDict["petspecies"] = "Dog"
        userDict["petdescription"] = "Friendly, medium-sized brown dog with a white patch on its chest. Last seen near Railway Station"
        userDict["contactdetails"] = ""
        let expectedError = lostPetSubmission.emptyContactDetails
        let validateError = validationServices.validateLostPetDetailsSubmission(userDict: userDict)
        XCTAssertEqual(expectedError, validateError)
    }
    
    func testInValidPetLocationThrowsError() throws
    {
        var userDict = dict()
        userDict["petname"] = "Tommy"
        userDict["petspecies"] = "Dog"
        userDict["petdescription"] = "Friendly, medium-sized brown dog with a white patch on its chest. Last seen near Railway Station"
        userDict["contactdetails"] = "Contact me @9849489383"
        userDict["petlostlocationlat"] = ""
        let expectedError = lostPetSubmission.emptyLostLocation
        let validateError = validationServices.validateLostPetDetailsSubmission(userDict: userDict)
        XCTAssertEqual(expectedError, validateError)
    }
    
    func testSuccessValidPetData() throws
    {
        var userDict = dict()
        userDict["petname"] = "Tommy"
        userDict["petspecies"] = "Dog"
        userDict["petdescription"] = "Friendly, medium-sized brown dog with a white patch on its chest. Last seen near Railway Station"
        userDict["contactdetails"] = "Contact me @9849489383"
        userDict["petphoto"] = "https://firebase.storage/petphoto"
        let lat = "9.939093"
        let long = "78.121719"
        let location = CLLocation(latitude: Double(lat)!, longitude: Double(long)!)
        userDict["petlostlocationlat"] = "\(location.coordinate.latitude)"
        userDict["petlostlocationlong"] = "\(location.coordinate.longitude)"
        let expectedSuccess = lostPetSubmission.validationSucceeded
        let validationMessage = validationServices.validateLostPetDetailsSubmission(userDict: userDict)
        XCTAssertEqual(expectedSuccess, validationMessage)
    }
    
    // MARK: TEST CASES FOR lOGIN REQUEST
    func  testInvalidloginRequest(){
        
        let expectation = self.expectation(description: "Invalid login request test")
        FireBaseManager.loginUser(email: "aaa@gmail.com", password: "daff") { status, error in
            XCTAssertFalse(status)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 20.0, handler: nil)
    }
    
    func  testValidloginRequest(){
        
        let expectation = self.expectation(description: "Valid login request test")
        FireBaseManager.loginUser(email: "john@gmail.com", password: "john@123") { status, error in
            XCTAssertTrue(status)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 20.0, handler: nil)
    }
    
    // MARK: TEST CASES FOR FETCHING PETLIST DETAILS
    func testPetListFetchingRequest()
    {
        FireBaseManager.getPetListFromFireBase { status, data in
            XCTAssertTrue(status)
        } onFailure: { status in
            XCTAssertFalse(status)
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
