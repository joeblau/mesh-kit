//
//  MeshDevice.swift
//  MeshKit
//
//  Created by Joe Blau on 10/18/18.
//  Copyright © 2018 MeshKit. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit
#elseif os (OSX)
import Foundation
#endif

class MeshDevice {
    static var name: String {
        #if os(iOS) || os(tvOS)
        return UIDevice.current.name
        #elseif os(OSX)
        return Host.current().name ?? "Default-Mac"
        #endif
    }
}
