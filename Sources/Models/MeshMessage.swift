//
//  MeshMessage.swift
//  MeshKit
//
//  Created by Joe Blau on 10/18/18.
//  Copyright © 2018 MeshKit. All rights reserved.
//

import Foundation
import MultipeerConnectivity

public struct MeshMessage {
    var peerID: MCPeerID
    var operation: MeshOperation
}

public enum MeshOperation {
    case data(Data)
    case stream(InputStream, String)
    case connected
    case connecting
    case disconnected
    case autoReconnect
    case invited
    case foundPeer
    case lostPeer
}

extension MeshMessage: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return debugDescription
    }

    public var debugDescription: String {
        return "Operation: \(operation)\tDisplay Name: \(peerID.displayName)"
    }
}
