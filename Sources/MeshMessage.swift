//
//  MeshMessage.swift
//  MeshKit
//
//  Created by Joe Blau on 2/24/18.
//

import Foundation
import MultipeerConnectivity


public enum MeshOperation {
    case data(Data?)
    case connected
    case connecting
    case disconnected
    case autoReconnected
    case invited
    case foundPeer
    case lostPeer
}

public struct MeshMessage {
    var peerID: MCPeerID
    var operation: MeshOperation
}

extension MeshMessage: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return debugDescription
    }

    public var debugDescription: String {
        return """
        Display Name: \(peerID.displayName)
        Operation: \(operation)
        """
    }
}
