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
    
    func configureAttributedLbl(
        fullText: String,
        attributedText: String,
        defaultTextColor: UIColor,
        defaultFont: UIFont,
        specialTextColor: UIColor,
        specialFont: UIFont,
        alignment: NSTextAlignment = .left
    ) {
        let defaultAttributes = [
            NSAttributedString.Key.font: defaultFont,
            NSAttributedString.Key.foregroundColor: defaultTextColor
        ]
        
        let defaultAttributedString = NSMutableAttributedString(string: fullText, attributes: defaultAttributes)
        
        let specialAttributes = [
            NSAttributedString.Key.font: specialFont,
            NSAttributedString.Key.foregroundColor: specialTextColor
        ]
        
        if let specialRange = fullText.range(of: attributedText) {
            let nsRange = NSRange(specialRange, in: fullText)
            defaultAttributedString.setAttributes(specialAttributes, range: nsRange)
        }
        
        self.attributedText = defaultAttributedString
        self.numberOfLines = 0
        self.textAlignment = alignment
    }
}
