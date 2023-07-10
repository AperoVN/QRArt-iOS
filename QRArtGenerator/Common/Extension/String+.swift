//
//  String+.swift
//  QRArtGenerator
//
//  Created by ANH VU on 10/07/2023.
//

import Foundation
import UIKit

extension String {
    var trim: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
