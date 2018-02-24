//
//  MeshDevice.swift
//  MeshKit
//
//  Created by Joe Blau on 2/24/18.
//

#if os(iOS) || os(tvOS)
    import UIKit
#elseif os(OSX)
    import Foundation
#endif

internal class MeshDevice {
    static var name: String {
        #if os(iOS) || os(tvOS)
            return UIDevice.current.name
        #elseif os(OSX)
            return Host.current().name ?? "Mac"
        #endif
    }
}
