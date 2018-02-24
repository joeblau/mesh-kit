//
//  MeshDeviceTests.swift
//  MeshKit
//
//  Created by Joe Blau on 2/24/18.
//

import XCTest

@testable import MeshKit

class MeshDeviceTests: XCTestCase {
    
    func testValidName() {
        XCTAssertFalse(MeshDevice.name.count == 0)
    }

}
