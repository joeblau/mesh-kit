//
//  String+ServiceTypeValidator.swift
//  MeshKit
//
//  Created by Joe Blau on 10/18/18.
//  Copyright © 2018 MeshKit. All rights reserved.
//

import Foundation

fileprivate let MAX_SERVICE_TYPE_CHARACTER_COUNT = 15

extension String {
    func validated() -> String {
        return String(describing: trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: " ", with: "-")
            .prefix(MAX_SERVICE_TYPE_CHARACTER_COUNT))
    }
}
