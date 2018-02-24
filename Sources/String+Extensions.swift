//
//  String+Extensions.swift
//  MeshKit
//
//  Created by Joe Blau on 2/24/18.
//

import Foundation

fileprivate let maxServiceTypeCharacterCount = 15

extension String {
    func verify() -> String {
        return String(describing: self.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: "-") .prefix(maxServiceTypeCharacterCount))
    }
}
