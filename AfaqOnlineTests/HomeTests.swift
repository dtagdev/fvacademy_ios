//
//  HomeTests.swift
//  AfaqOnlineTests
//
//  Created by MGoKu on 6/4/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import XCTest
@testable import Al_Academya
import RxSwift

class HomeTests: XCTestCase {

    var HomeVM = HomeViewModel()
    var disposeBag = DisposeBag()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHomeResponse() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expectation = self.expectation(description: "Home Response Parse Expectations")
        self.HomeVM.getHomeData().subscribe(onNext: { (homeData) in
            if homeData.status ?? false {
                XCTAssertNotNil(homeData.data ?? HomeDataClass())
                expectation.fulfill()
            } else {
                XCTFail(homeData.errors ?? "")
            }
        }, onError: { (error) in
            XCTFail(error.localizedDescription)
            }).disposed(by: disposeBag)
        self.waitForExpectations(timeout: 10, handler: nil)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            testHomeResponse()
        }
    }

}
