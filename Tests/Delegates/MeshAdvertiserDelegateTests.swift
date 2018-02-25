//
//  MeshAdvertiserDelegateTests.swift
//  MeshKit
//
//  Created by Joe Blau on 2/25/18.
//

import XCTest
import MultipeerConnectivity

@testable import MeshKit

fileprivate class MockMeshNetworkDelegate: MeshNetworkDelegate {
    var messageInvitedExpectation: XCTestExpectation?

    func update(message: MeshMessage) {
        switch message.operation {
        case .invited: messageInvitedExpectation?.fulfill()
        default: break
        }
    }
}

class MeshAdvertiserDelegateTests: XCTestCase {
    fileprivate let mockSession = MCSession(peer: MCPeerID(displayName: "mockDisplayName"))
    fileprivate let mockMeshNetworkDelegate = MockMeshNetworkDelegate()
    fileprivate let mockPeerID = MCPeerID(displayName: "mockDisplayName")


    
    func testDidReceiveInvitation() {
        mockMeshNetworkDelegate.messageInvitedExpectation = expectation(description: "invted")
        mockMeshNetworkDelegate.messageInvitedExpectation?.expectedFulfillmentCount = 1

        let mockNearbyAdvertiser = MCNearbyServiceAdvertiser(peer: mockPeerID, discoveryInfo: nil, serviceType: "mock-invited")
        let mockMeshAdvertiserDelegate = MeshAdvertiserDelegate(session: mockSession, meshNetwork: mockMeshNetworkDelegate)
        mockMeshAdvertiserDelegate.advertiser(mockNearbyAdvertiser, didReceiveInvitationFromPeer: mockPeerID, withContext: nil) { (invited, session) in}

        waitForExpectations(timeout: 2, handler: nil)
    }
    

    
}
