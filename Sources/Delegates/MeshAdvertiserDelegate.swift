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
    init(meshNetwork delegate: MeshNetworkDelegate) {
        self.delegate = delegate
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        delegate.update(message: MeshMessage(peerID: peerID, operation: .data(context)))
    }

}
