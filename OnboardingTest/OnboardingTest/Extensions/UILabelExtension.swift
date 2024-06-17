//
//  UILabelExtension.swift
//

import UIKit.UILabel

extension UILabel {
    func configure(text: String? = nil, color: UIColor = .white, lines: Int = 0, alignment: NSTextAlignment = .left, font: UIFont) {
        self.text = text
        self.textColor = color
        self.numberOfLines = lines
        self.textAlignment = alignment
        self.font = font
    }
}
