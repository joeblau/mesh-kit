//
//  MeshNetwork.swift
//  MeshKit
//
//  Created by Joe Blau on 2/24/18.
//

import Foundation
import MultipeerConnectivity

public protocol MeshNetworkDelegate {
    func update(message: MeshMessage)
}

public class MeshNetwork<T: Codable> {

    private let session: MCSession
    private let peerID: MCPeerID
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    private let serviceBrowser: MCNearbyServiceBrowser

    private let meshSessionDelegate: MeshSessionDelegate
    private let advertiserDelegate: MeshAdvertiserDelegate
    private let browserDelegate: MeshBrowserDelegate
    private let jsonEncoder = JSONEncoder()

    init(serviceType: String, displayName: String = MeshDevice.name, delegate: MeshNetworkDelegate) {
        meshSessionDelegate = MeshSessionDelegate(meshNetwork: delegate)

        peerID = MCPeerID(displayName: displayName)
        session = MCSession(peer: peerID)
        session.delegate = meshSessionDelegate

        advertiserDelegate = MeshAdvertiserDelegate(meshNetwork: delegate)
        browserDelegate = MeshBrowserDelegate(session: session, meshNetwork: delegate)
        
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType.verify())
        serviceAdvertiser.delegate = advertiserDelegate

        serviceBrowser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType.verify())
        serviceBrowser.delegate = browserDelegate
    }

    public func start() {
        serviceAdvertiser.startAdvertisingPeer()
        serviceBrowser.startBrowsingForPeers()
    }

    public func stop() {
        serviceAdvertiser.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
    }

    public func disconnecd() {
        session.disconnect()
    }

    public func broadcast<T: Codable>(message: T, mode: MCSessionSendDataMode = .reliable) {
        do {
            let data = try jsonEncoder.encode(message).base64EncodedData()
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            debugPrint("Error \(error)")
        }
    }


}
