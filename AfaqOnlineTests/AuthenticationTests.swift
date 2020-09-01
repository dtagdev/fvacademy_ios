//
//  AuthenticationTests.swift
//  AfaqOnlineTests
//
//  Created by MGoKu on 6/4/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import XCTest
@testable import Al_Academya
import RxSwift

class AuthenticationTests: XCTestCase {
    
    var AuthenticationVM = AuthenticationViewModel()
    var disposeBag = DisposeBag()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        AuthenticationVM.username.onNext("Hassan")
        AuthenticationVM.password.onNext("passwordD0@")
        AuthenticationVM.first_name.onNext("TestFirstName")
        AuthenticationVM.last_name.onNext("TestLastName2")
        AuthenticationVM.id_number.onNext("654654645")
        AuthenticationVM.medical_number.onNext("1332132654")
        AuthenticationVM.phone.onNext("5646564")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testRegisterResponse() {
        let expectation = self.expectation(description: "Register Response Parse Expectation")
        AuthenticationVM.email.onNext("MohammedUnitTest10@gmail.com")
        AuthenticationVM.attemptToRegister(gender: "male", title: "Dr", job: "Doctor").subscribe(onNext: { (registerData) in
            if registerData.status ?? false {
                XCTAssertNotNil(registerData.data ?? DataClass())
                expectation.fulfill()
            } else {
                let errors = registerData.errors ?? Errors()
                if let email = errors.email {
                    XCTFail(email[0])
                }
            }
        }, onError: { (error) in
            XCTFail(error.localizedDescription)
            }).disposed(by: disposeBag)
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testLoginResponse() {
        let expectation = self.expectation(description: "Login Response Parse Expectation")
        AuthenticationVM.email.onNext("MohammedUnitTest2@gmail.com")
        AuthenticationVM.attemptToLogin().subscribe(onNext: { (loginData) in
            if loginData.status ?? false {
                XCTAssertNotNil(loginData.data ?? LoginDataClass())
                expectation.fulfill()
            } else {
                let errors = loginData.errors ?? ""
                XCTFail(errors)
            }
        }, onError: { (error) in
            XCTFail(error.localizedDescription)
            }).disposed(by: disposeBag)
        
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    func testForgetPasswordResponse() {
        
    }
    
    func testPerformanceAuthentication() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
//            testRegisterResponse()
//            testLoginResponse()
        }
    }
}
