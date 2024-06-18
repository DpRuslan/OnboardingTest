//
//  StringExtension.swift
//

import UIKit

extension String {
    func openTermsURL() {
        if let url = URL(string: self) {
            UIApplication.shared.open(url)
        }
    }
}
