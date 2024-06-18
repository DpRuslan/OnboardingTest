//
//  StyledButton.swift
//

import UIKit

final class StyledButton: UIButton {
    enum ButtonStyle {
        case active, inactive
        
        var backgroundColor: UIColor {
            switch self {
            case .active:
                return UIColor(red: 16/255, green: 27/255, blue: 24/255, alpha: 1)
            case .inactive:
                return .white
            }
        }
        
        var titleColor: UIColor {
            switch self {
            case .active:
                return .white
            case .inactive:
                return UIColor(red: 202/255, green: 202/255, blue: 202/255, alpha: 1)
            }
        }
    }
    
    var style: ButtonStyle = .inactive {
        didSet {
            applyStyle(style)
        }
    }
    
    init(title: String) {
        super.init(frame: .zero)
        
        let attributes = [NSAttributedString.Key.font: UIFont(name: FontExtension.sfd600.rawValue, size: 17)!]
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        
        self.setAttributedTitle(attributedTitle, for: .normal)
        self.clipsToBounds = false
        
        applyStyle(style)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension StyledButton {
    private func applyStyle(_ style: ButtonStyle) {
        self.backgroundColor = style.backgroundColor
        self.setTitleColor(style.titleColor, for: .normal)
        self.layer.cornerRadius = 28
        
        // Shadow settings
        self.layer.shadowColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1).cgColor
        self.layer.shadowOpacity = 0.25
        self.layer.shadowOffset = CGSize(width: 0, height: -4)
        self.layer.shadowRadius = 36
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        
        self.isEnabled = style == .active ? true : false
    }
}

extension StyledButton {
    func updateTitle(title: String) {
        self.backgroundColor = UIColor(red: 71/255, green: 190/255, blue: 154/255, alpha: 1)
        
        let attributes = [NSAttributedString.Key.font: UIFont(name: FontExtension.sfd600.rawValue, size: 17)!]
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        
        self.setAttributedTitle(attributedTitle, for: .normal)
        self.setTitleColor(.white, for: .normal)
    }
}
