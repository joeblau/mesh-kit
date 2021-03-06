//
//  MeshKitTests.swift
//  MeshKit
//
//  Created by Joe Blau on 10/18/18.
//  Copyright © 2018 MeshKit. All rights reserved.
//

import Foundation
import XCTest

@testable import MeshKit

class MeshKitTests: XCTestCase  {
    struct TestObject: Codable {
        var testInterger = 0
    }
    
    func _testConnect_sendMessage_oneToOne() {
        let expect = expectation(description: "Auto-Connect-One-One")
        expect.expectedFulfillmentCount = 1
        
        var services = [MeshNetwork<TestObject>]()
        (1...2).forEach { services.append(createService(type: "oneToOne", with: "Service \($0)", expect: expect)) }

        services.forEach { $0.start() }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            var testInstance = TestObject()
            testInstance.testInterger = 100
            services[0].send(codable: testInstance)
        }
        
        waitForExpectations(timeout: 60) { (error) in
            services.forEach { service in
                service.disconnect()
                service.stop()
            }
        }
    }
    
    func _testConnect_sendMessage_oneToFour() {
        let expect = expectation(description: "Auto-Connect-One-Four")
        expect.expectedFulfillmentCount = 3
        
        var services = [MeshNetwork<TestObject>]()
        (1...4).forEach { services.append(createService(type: "oneToFour", with: "Service \($0)", expect: expect)) }
        services.forEach { $0.start() }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            var testInstance = TestObject()
            testInstance.testInterger = 100
            services[0].send(codable: testInstance)
        }
        
        waitForExpectations(timeout: 60) { (error) in
            services.forEach { service in
                service.disconnect()
                service.stop()
            }
        }
    }
    
    func _testConnect_sendMessage_fourToFour() {
        let expect = expectation(description: "Auto-Connect-Four-Four")
        expect.expectedFulfillmentCount = 12
        
        var services = [MeshNetwork<TestObject>]()
        (1...4).forEach { services.append(createService(type: "fourToFour", with: "Service \($0)", expect: expect)) }
        services.forEach { $0.start() }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            var testInstance = TestObject()
            testInstance.testInterger = 100
            services.forEach { $0.send(codable: testInstance) }
        }
        
        waitForExpectations(timeout: 60) { (error) in
            services.forEach { service in
                service.disconnect()
                service.stop()
            }
        }
    }
    
    func _testConnect_send1000Messages() {
        measure {
            let expect = expectation(description: "Auto-Connect-1000")
            expect.expectedFulfillmentCount = 1000

            var services = [MeshNetwork<TestObject>]()
            (1...2).forEach { services.append(createService(type: "oneThousand", with: "Service \($0)", expect: expect)) }

            services.forEach { $0.start() }

            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                var testInstance = TestObject()
                (0...999).forEach {
                    testInstance.testInterger = $0
                    services[0].send(codable: testInstance)
                }
            }

            waitForExpectations(timeout: 60) { (error) in
                services.forEach { service in
                    service.disconnect()
                    service.stop()
                }
            }
        }
    }
    
    private func createService(type: String, with displayName: String, expect: XCTestExpectation) -> MeshNetwork<TestObject> {
        return MeshNetwork<TestObject>.init(serviceType: type, displayName: displayName) { (peerID, test) in
            expect.fulfill()
        }
    }
    
//    static var allTests = [
//        ("testConnect_sendMessage_oneToOne", testConnect_sendMessage_oneToOne),
//        ("testConnect_sendMessage_oneToFour", testConnect_sendMessage_oneToFour),
//        ("testConnect_sendMessage_fourToFour", testConnect_sendMessage_fourToFour),
//        ("testConnect_send1000Messages", testConnect_send1000Messages)
//    ]
}
