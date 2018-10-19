//
//  MeshKit.swift
//  MeshKit
//
//  Created by Joe Blau on 10/18/18.
//  Copyright © 2018 MeshKit. All rights reserved.
//

import Foundation
import MultipeerConnectivity

fileprivate let RECONNECT_TIMEOUT: TimeInterval = 5

public class MeshNetwork<T: Codable>: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate {
    
    public var state: MCSessionState = .notConnected
    
    private var session: MCSession
    private var received: ((MCPeerID, T?) -> ())?
    private let nearbyServiceAdvertiser: MCNearbyServiceAdvertiser
    private let nearbyServiceBrowser: MCNearbyServiceBrowser
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init(serviceType: String,
         displayName: String = MeshDevice.name,
         received: @escaping ((MCPeerID, T?) -> ()) ) {
        
        let peerID = MCPeerID(displayName: displayName)
        self.received = received
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .optional)
        nearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType.validated())
        nearbyServiceBrowser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType.validated())
        super.init()
        session.delegate = self
        nearbyServiceAdvertiser.delegate = self
        nearbyServiceBrowser.delegate = self
    }
    
    public func start() {
        nearbyServiceAdvertiser.startAdvertisingPeer()
        nearbyServiceBrowser.startBrowsingForPeers()
    }
    
    public func stop() {
        nearbyServiceAdvertiser.stopAdvertisingPeer()
        nearbyServiceBrowser.stopBrowsingForPeers()
    }
    
    public func disconnect() {
        session.disconnect()
    }
    
    public func send(codable: T) {
        guard let data = try? encoder.encode(codable) else { return }
        try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
    }
    
    private func decode(data: Data) -> T? {
        return try? decoder.decode(T.self, from: data)
    }
    
    // MARK: - MCSessionDelegate
    
    public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        self.state = state
    }
    
    public func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        received?(peerID, decode(data: data))
    }
    
    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        fatalError("Streaming is not supported")
    }
    
    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        fatalError("Receiving resources is not supported")
    }
    
    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        fatalError("Receiving resources is not supported")
    }
    
    // MARK: - MCNearbyServiceBrowserDelegate
    
    public func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: RECONNECT_TIMEOUT)
    }
    
    public func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: RECONNECT_TIMEOUT)
    }
    
    // MARK: - MCNearbyServiceAdvertiserDelegate
    
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }
}
