//
//  MeshNetworkTests.swift
//  MeshKitTests iOS
//
//  Created by Joe Blau on 2/24/18.
//

import XCTest

@testable import MeshKit

struct MockMessage: Codable {
    var title: String
    var description: String
}

fileprivate class MockMeshNetworkDelegateDelegate: MeshNetworkDelegate {
    private let expectedMessageCount: Int
    

    var messageCount: Int = 0
    var connectionExpectation: XCTestExpectation?

    init(expectedMessage count: Int) {
        expectedMessageCount = count
    }

    func update(message: MeshMessage) {
        messageCount += 1
        if (messageCount == expectedMessageCount) {
            connectionExpectation?.fulfill()
        } else if (messageCount > expectedMessageCount) {
            XCTFail("\(messageCount) > \(expectedMessageCount)")
        }
    }
}


fileprivate class ConnectionDisconnectionDelegate: MeshNetworkDelegate {
    private let expectedMessageCount: Int
    private let expectedDisconnectMessageCount: Int
    var messageCount: Int = 0
    var disconnectMessageCount: Int = 0
    var connectionExpectation: XCTestExpectation?
    var disconnectionExpectation: XCTestExpectation?

    init(expectedMessage count: Int, disconnectMessage disconnectCount: Int) {
        expectedMessageCount = count
        expectedDisconnectMessageCount = disconnectCount
    }

    func update(message: MeshMessage) {
        messageCount += 1
        switch message.operation {
        case .disconnected: disconnectMessageCount += 1
        default: break
        }

        if (messageCount == expectedMessageCount &&
            disconnectMessageCount == expectedDisconnectMessageCount) {
            connectionExpectation?.fulfill()
            disconnectionExpectation?.fulfill()
        } else if (messageCount > expectedMessageCount ) {
            XCTFail()
        }
    }
}


class MeshNetworkTests: XCTestCase {

    private let serviceType = "Unit Test Channel"

    func testTwoDeviceConnections() {
        executeDevicesConnected(deviceCount: 2)
    }

//    func testFourDeviceConnections() {
//        executeDevicesConnected(deviceCount: 4)
//    }
//
//    func testEightDeviceConnections() {
//        executeDevicesConnected(deviceCount: 8)
//    }

    func testConnectTwoDisconnectOne() {
        executeDevicesConnectionDisconnection(deviceCount: 3, disconnectCount: 1)
    }

    
    // MARK: - Private

    private func executeDevicesConnectionDisconnection(deviceCount: Int, disconnectCount: Int) {
        let expectedMessages = (deviceCount * (deviceCount - 1)) * 2
        let disconnectMessageCount = (disconnectCount * (disconnectCount - 1)) * 2
        let connectionDelegate = ConnectionDisconnectionDelegate(expectedMessage: expectedMessages, disconnectMessage: disconnectMessageCount)
        connectionDelegate.connectionExpectation = expectation(description: "Connected")
        connectionDelegate.disconnectionExpectation = expectation(description: "Disconnected")

        let devices: [MeshNetwork<MockMessage>] = (0..<deviceCount)
            .map { (deviceNumber) -> MeshNetwork<MockMessage> in
                MeshNetwork<MockMessage>(serviceType: serviceType,
                                         displayName: "Device \(deviceNumber)",
                    delegate: connectionDelegate)
        }

        devices.forEach { (device) in
            device.start()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            devices
                .suffix(disconnectCount)
                .forEach{ (device) in
                    device.stop()
                    device.disconnecd()
                }
        }

        waitForExpectations(timeout: 20) { (error) in
            devices.forEach { (device) in
                device.stop()
                device.disconnecd()
            }
        }
    }

    private func executeDevicesConnected(deviceCount: Int) {
        let expectedMessages = (deviceCount * (deviceCount - 1)) * 2
        let connectionDelegate = ConnectionDelegate(expectedMessage: expectedMessages)
        connectionDelegate.connectionExpectation = expectation(description: "Connected")

        let devices: [MeshNetwork<MockMessage>] = (0..<deviceCount)
            .map { (deviceNumber) -> MeshNetwork<MockMessage> in
            MeshNetwork<MockMessage>(serviceType: serviceType,
                                     displayName: "Device \(deviceNumber)",
                                     delegate: connectionDelegate)
            }

        devices.forEach { (device) in
            device.start()
        }

        waitForExpectations(timeout: 20) { (error) in
            devices.forEach { (device) in
                device.stop()
                device.disconnecd()
            }
        }
    }
}
