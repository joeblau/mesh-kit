//
//  MeshBrowserDelegate.swift
//  MeshKit
//
//  Created by Joe Blau on 2/24/18.
//

import Foundation
import MultipeerConnectivity

internal class MeshBrowserDelegate: NSObject, MCNearbyServiceBrowserDelegate {
    private let invitationTimeout: TimeInterval = 10
    private let delegate: MeshNetworkDelegate
    private let session: MCSession
    private let autoReconnect: Bool

    init(session: MCSession, meshNetwork delegate: MeshNetworkDelegate, autoReconnect: Bool) {
        self.session = session
        self.delegate = delegate
        self.autoReconnect = autoReconnect
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        browser.invitePeer(peerID,
                           to: session,
                           withContext: nil,
                           timeout: invitationTimeout)
        delegate.update(message: MeshMessage(peerID: peerID, operation: .foundPeer))
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        delegate.update(message: MeshMessage(peerID: peerID, operation: .lostPeer))
        if (autoReconnect) {
            browser.invitePeer(peerID,
                               to: session,
                               withContext: nil,
                               timeout: invitationTimeout)
        }
    }
}
