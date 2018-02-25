//
//  MeshBrowserDelegateTests.swift
//  MeshKit
//
//  Created by Joe Blau on 2/25/18.
//

import XCTest
import MultipeerConnectivity

@testable import MeshKit

fileprivate class MockMeshNetworkDelegate: MeshNetworkDelegate {
    var messageFoundPeerExpectation: XCTestExpectation?
    var messageLostPeerExpectation: XCTestExpectation?
    
    func update(message: MeshMessage) {
        switch message.operation {
        case .foundPeer: messageFoundPeerExpectation?.fulfill()
        case .lostPeer: messageLostPeerExpectation?.fulfill()
        default: break
        }
    }
}

class MeshBrowserDelegateTests: XCTestCase {
    fileprivate let mockSession = MCSession(peer: MCPeerID(displayName: "mockDisplayName"))
    fileprivate let mockMeshNetworkDelegate = MockMeshNetworkDelegate()
    fileprivate let mockPeerID = MCPeerID(displayName: "mockDisplayName")

    
    func testFoundPeer() {
        mockMeshNetworkDelegate.messageFoundPeerExpectation = expectation(description: "found peer")
        mockMeshNetworkDelegate.messageFoundPeerExpectation?.expectedFulfillmentCount = 1

        let mockNearbyServiceBrowser = MCNearbyServiceBrowser(peer: mockPeerID, serviceType: "mock-found")
        let mockMeshBrowserDelegate = MeshBrowserDelegate(session: mockSession, meshNetwork: mockMeshNetworkDelegate, autoReconnect: false)
        mockMeshBrowserDelegate.browser(mockNearbyServiceBrowser, foundPeer: mockPeerID, withDiscoveryInfo: nil)

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testLostPeer() {
        mockMeshNetworkDelegate.messageLostPeerExpectation = expectation(description: "lost peer")
        mockMeshNetworkDelegate.messageLostPeerExpectation?.expectedFulfillmentCount = 1

        let mockNearbyServiceBrowser = MCNearbyServiceBrowser(peer: mockPeerID, serviceType: "mock-lost")
        let mockMeshBrowserDelegate = MeshBrowserDelegate(session: mockSession, meshNetwork: mockMeshNetworkDelegate, autoReconnect: false)
        mockMeshBrowserDelegate.browser(mockNearbyServiceBrowser, lostPeer: mockPeerID)

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testLostPeer_autoReconnect() {
        mockMeshNetworkDelegate.messageLostPeerExpectation = expectation(description: "lost peer")
        mockMeshNetworkDelegate.messageLostPeerExpectation?.expectedFulfillmentCount = 1

        let mockNearbyServiceBrowser = MCNearbyServiceBrowser(peer: mockPeerID, serviceType: "mock-lost")
        let mockMeshBrowserDelegate = MeshBrowserDelegate(session: mockSession, meshNetwork: mockMeshNetworkDelegate, autoReconnect: true)
        mockMeshBrowserDelegate.browser(mockNearbyServiceBrowser, lostPeer: mockPeerID)

        waitForExpectations(timeout: 2, handler: nil)
    }
    

}
