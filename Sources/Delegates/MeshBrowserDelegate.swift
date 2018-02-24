//
//  MeshBrowserDelegate.swift
//  MeshKit
//
//  Created by Joe Blau on 2/24/18.
//

import Foundation
import MultipeerConnectivity

internal class MeshBrowserDelegate: NSObject, MCNearbyServiceBrowserDelegate {
    private let invitationTimeout: TimeInterval = 20
    private let delegate: MeshNetworkDelegate
    private let session: MCSession

    init(session: MCSession, meshNetwork delegate: MeshNetworkDelegate) {
        self.session = session
        self.delegate = delegate
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        browser.invitePeer(peerID,
                           to: session,
                           withContext: nil,
                           timeout: invitationTimeout)
        delegate.update(message: MeshMessage(peerID: peerID, operation: .connected))
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        browser.invitePeer(peerID,
                           to: session,
                           withContext: nil,
                           timeout: invitationTimeout)
        delegate.update(message: MeshMessage(peerID: peerID, operation: .disconnected))
    }


}
