//
//  MeshNetworkTests.swift
//  MeshKitTests iOS
//
//  Created by Joe Blau on 2/24/18.
//

import XCTest

@testable import MeshKit

fileprivate struct MessageCount {
    var dataNone: Int = 0
    var dataSome: Int = 0
    var connected: Int = 0
    var connecting: Int = 0
    var disconnected: Int = 0
    var autoReconnected: Int = 0
    var invited: Int = 0
    var foundPeer: Int = 0
    var lostPeer: Int = 0
}

struct MockMessage: Codable {
    var title: String
    var description: String
}

fileprivate class MockMeshNetworkDelegate: MeshNetworkDelegate {
    var messageDataNoneExpectation: XCTestExpectation?
    var messageDataSomeExpectation: XCTestExpectation?
    var messageConnectedExpectation: XCTestExpectation?
    var messageConnectingExpectation: XCTestExpectation?
    var messageDisconnectedExpectation: XCTestExpectation?
    var messageAutoReconnectedExpectation: XCTestExpectation?
    var messageInvitedExpectation: XCTestExpectation?
    var messageFoundPeerExpectation: XCTestExpectation?
    var messageLostPeerExpectation: XCTestExpectation?

    func update(message: MeshMessage) {
        debugPrint(message)
        switch message.operation {
        case .data(.none): messageDataNoneExpectation?.fulfill()
        case .data(.some(_)): messageDataSomeExpectation?.fulfill()
        case .connected: messageConnectedExpectation?.fulfill()
        case .connecting: messageConnectingExpectation?.fulfill()
        case .disconnected: messageDisconnectedExpectation?.fulfill()
        case .autoReconnected: messageAutoReconnectedExpectation?.fulfill()
        case .invited: messageInvitedExpectation?.fulfill()
        case .foundPeer: messageFoundPeerExpectation?.fulfill()
        case .lostPeer: messageLostPeerExpectation?.fulfill()
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

    func testTwoConnections() {
        let devices = 2
        executeMeshNetwork(serviceType: "0\(#function)",
            connectingDevices: devices,
            expectedMessageCount: messageCount(for: devices))
    }

    func testTwoConnections_sendMessages() {
        let devices = 2

        var expectedMessageCount = messageCount(for: devices)
        expectedMessageCount.dataSome = 2

        executeMeshNetwork(serviceType: "2\(#function)",
        connectingDevices: devices,
        sendCustomMessage: true,
        expectedMessageCount: expectedMessageCount)

    }

    func testThreeConnectionsOneDisconnects() {
        let devices = 3
        var expectedMessageCount = messageCount(for: devices)
        expectedMessageCount.disconnected = 4

        executeMeshNetwork(serviceType: "3\(#function)",
            connectingDevices: devices,
            disconnectingDevices: 1,
            expectedMessageCount: expectedMessageCount)
    }

    // MARK: - Private

    fileprivate func executeMeshNetwork(serviceType: String,
                                        connectingDevices: Int,
                                        disconnectingDevices: UInt = 0,
                                        sendCustomMessage: Bool = false,
                                        expectedMessageCount: MessageCount) {
        let mockMeshNetworkDelegate = MockMeshNetworkDelegate()

        if expectedMessageCount.dataNone > 0 {
            mockMeshNetworkDelegate.messageDataNoneExpectation = expectation(description: "data none")
            mockMeshNetworkDelegate.messageDataNoneExpectation?.expectedFulfillmentCount = expectedMessageCount.dataNone
        }

        if expectedMessageCount.dataSome > 0 {
            mockMeshNetworkDelegate.messageDataSomeExpectation = expectation(description: "data some")
            mockMeshNetworkDelegate.messageDataSomeExpectation?.expectedFulfillmentCount = expectedMessageCount.dataSome
        }

        if expectedMessageCount.connected > 0 {
            mockMeshNetworkDelegate.messageConnectedExpectation = expectation(description: "connected")
            mockMeshNetworkDelegate.messageConnectedExpectation?.expectedFulfillmentCount = expectedMessageCount.connected
        }

        if expectedMessageCount.connecting > 0 {
            mockMeshNetworkDelegate.messageConnectingExpectation = expectation(description: "connecting")
            mockMeshNetworkDelegate.messageConnectingExpectation?.expectedFulfillmentCount = expectedMessageCount.connecting
        }
        
        if expectedMessageCount.disconnected > 0 {
            mockMeshNetworkDelegate.messageDisconnectedExpectation = expectation(description: "disconnected")
            mockMeshNetworkDelegate.messageDisconnectedExpectation?.expectedFulfillmentCount = expectedMessageCount.disconnected
            mockMeshNetworkDelegate.messageDisconnectedExpectation?.assertForOverFulfill = false

        }

        if expectedMessageCount.autoReconnected > 0 {
            mockMeshNetworkDelegate.messageAutoReconnectedExpectation = expectation(description: "auto reconnected")
            mockMeshNetworkDelegate.messageAutoReconnectedExpectation?.expectedFulfillmentCount = expectedMessageCount.autoReconnected
        }

        if expectedMessageCount.invited > 0 {
            mockMeshNetworkDelegate.messageInvitedExpectation = expectation(description: "invted")
            mockMeshNetworkDelegate.messageInvitedExpectation?.expectedFulfillmentCount = expectedMessageCount.invited
        }

        if expectedMessageCount.foundPeer > 0 {
            mockMeshNetworkDelegate.messageFoundPeerExpectation = expectation(description: "found peer")
            mockMeshNetworkDelegate.messageFoundPeerExpectation?.expectedFulfillmentCount = expectedMessageCount.foundPeer
        }

        if expectedMessageCount.lostPeer > 0 {
            mockMeshNetworkDelegate.messageLostPeerExpectation = expectation(description: "lost peer")
            mockMeshNetworkDelegate.messageLostPeerExpectation?.expectedFulfillmentCount = expectedMessageCount.lostPeer
        }

        let devices: [MeshNetwork<MockMessage>] = (0..<connectingDevices)
            .map { (deviceNumber) -> MeshNetwork<MockMessage> in
                MeshNetwork<MockMessage>(serviceType: serviceType,
                                         displayName: "Device \(deviceNumber)",
                    delegate: mockMeshNetworkDelegate,
                    autoReconnect: false)
        }

        devices.forEach { (device) in
            device.start()
        }

        if sendCustomMessage {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                devices.forEach { (device) in
                    let mockMessage = MockMessage(title: "hello", description: "world")
                    device.broadcast(message: mockMessage)
                }
            }
        }

        if disconnectingDevices > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + (sendCustomMessage ? 6 : 4)) {
                devices
                    .suffix(Int(disconnectingDevices))
                    .forEach{ (device) in
                        device.disconnecd()
                }
            }
        }

        waitForExpectations(timeout: 14) { (error) in
            devices.forEach { (device) in
                device.stop()
                device.disconnecd()
            }
        }
    }

    fileprivate func messageCount(for devices: Int) -> MessageCount {
        let fullyConnectedGraphEdges = (devices * (devices - 1))
        return MessageCount(dataNone: 0,
                            dataSome: 0,
                            connected: fullyConnectedGraphEdges,
                            connecting: fullyConnectedGraphEdges,
                            disconnected: 0,
                            autoReconnected: 0,
                            invited: fullyConnectedGraphEdges,
                            foundPeer: fullyConnectedGraphEdges,
                            lostPeer: 0)
    }
}
