//
//  MeshSessionDelegateTests.swift
//  MeshKit
//
//  Created by Joe Blau on 2/24/18.
//

import XCTest
import MultipeerConnectivity

@testable import MeshKit

fileprivate class ReceiveSessionDelegate: MeshNetworkDelegate {
    var expectation: XCTestExpectation?

    func update(message: MeshMessage) {
        expectation?.fulfill()
    }
}

class MeshSessionDelegateTests: XCTestCase {
    let mockSession = MCSession(peer: MCPeerID(displayName: "mockDisplayName"))
    let mockInputStream = InputStream()
    let mockName = "Mock Name"
    let mockPeerID = MCPeerID(displayName: "mockDisplayName")
    let mockProgress = Progress()



    func testDidChange_connected() {
        let receiveSessionDelegate = ReceiveSessionDelegate()
        receiveSessionDelegate.expectation = expectation(description: "Connected")
        let mockMeshSessionDelegate = MeshSessionDelegate(meshNetwork:receiveSessionDelegate)
        mockMeshSessionDelegate.session(mockSession, peer: mockPeerID, didChange: .connected)

        waitForExpectations(timeout: 10, handler: nil)
    }


    func testDidChange_disconnected() {
        let receiveSessionDelegate = ReceiveSessionDelegate()
        receiveSessionDelegate.expectation = expectation(description: "Disconnected")
        let mockMeshSessionDelegate = MeshSessionDelegate(meshNetwork:receiveSessionDelegate)
        mockMeshSessionDelegate.session(mockSession, peer: mockPeerID, didChange: .notConnected)

        waitForExpectations(timeout: 10, handler: nil)
    }

    func testDidReceive() {
        let receiveSessionDelegate = ReceiveSessionDelegate()
        receiveSessionDelegate.expectation = expectation(description: "Received")
        let mockMeshSessionDelegate = MeshSessionDelegate(meshNetwork:receiveSessionDelegate)
        mockMeshSessionDelegate.session(mockSession, didReceive: "hello world".data(using: .utf8)!, fromPeer: mockPeerID)


        waitForExpectations(timeout: 10, handler: nil)
    }

    func testMeshSessionDelegate_inputStream() {
        let mockMeshSessionDelegate = MeshSessionDelegate(meshNetwork: ReceiveSessionDelegate())
        mockMeshSessionDelegate.session(mockSession,
                                        didReceive: mockInputStream,
                                        withName: mockName,
                                        fromPeer: mockPeerID)
    }
    
    func testMeshSessionDelegate_didStartReceivingResourceWithName() {
        let mockMeshSessionDelegate = MeshSessionDelegate(meshNetwork: ReceiveSessionDelegate())
        mockMeshSessionDelegate.session(mockSession,
                                        didStartReceivingResourceWithName: mockName,
                                        fromPeer: mockPeerID,
                                        with: mockProgress)
    }

    func testMeshSessionDelegate_didFinishReceivingResourceWithName() {
        let mockMeshSessionDelegate = MeshSessionDelegate(meshNetwork: ReceiveSessionDelegate())
        mockMeshSessionDelegate.session(mockSession,
                                        didFinishReceivingResourceWithName: mockName,
                                        fromPeer: mockPeerID,
                                        at: nil,
                                        withError: nil)
    }
    
}
