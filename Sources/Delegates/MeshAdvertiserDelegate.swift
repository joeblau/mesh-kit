//
//  MeshAdvertiserDelegate.swift
//  MeshKit
//
//  Created by Joe Blau on 2/24/18.
//

import Foundation
import MultipeerConnectivity

internal class MeshAdvertiserDelegate: NSObject, MCNearbyServiceAdvertiserDelegate {
    private let delegate: MeshNetworkDelegate
    private let session: MCSession

    init(session: MCSession, meshNetwork delegate: MeshNetworkDelegate) {
        self.session = session
        self.delegate = delegate
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, self.session)
        delegate.update(message: MeshMessage(peerID: peerID, operation: .invited))
    }
}
