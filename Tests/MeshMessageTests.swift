//
//  MeshMessageTests.swift
//  MeshKit
//
//  Created by Joe Blau on 2/24/18.
//

import XCTest
import MultipeerConnectivity

@testable import MeshKit

class MeshMessageTests: XCTestCase {
    

    func testCustomStringConvertable() {
        let peerID = MCPeerID(displayName: "mockDisplayName")
        let message = MeshMessage(peerID: peerID, operation: MeshOperation.disconnected)

        let expectedString =
        """
        Display Name: mockDisplayName
        Operation: disconnected
        """

        XCTAssertEqual("\(message)", expectedString)
    }

    
}
