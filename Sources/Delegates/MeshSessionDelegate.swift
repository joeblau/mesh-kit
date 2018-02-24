//
//  MeshSessionDelegate.swift
//  MeshKit
//
//  Created by Joe Blau on 2/24/18.
//

import Foundation
import MultipeerConnectivity

internal class MeshSessionDelegate: NSObject, MCSessionDelegate {

    private let delegate: MeshNetworkDelegate
    init(meshNetwork delegate: MeshNetworkDelegate) {
        self.delegate = delegate
    }

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected: delegate.update(message: MeshMessage(peerID: peerID, operation: .connected))
        case .connecting, .notConnected: delegate.update(message: MeshMessage(peerID: peerID, operation: .disconnected))
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        delegate.update(message: MeshMessage(peerID: peerID, operation: .data(data)))
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
//        fatalError("Streaming is not supported")
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
//        fatalError("Receiving resources is not supported")
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
//        fatalError("Receiving resources is not supported")
    }



}
