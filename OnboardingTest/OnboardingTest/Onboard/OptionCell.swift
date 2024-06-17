//
//  OptionCell.swift
//

import UIKit
import SnapKit

final class OptionCell: UITableViewCell {
    
    private let containerView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let optionLabel = {
        let label = UILabel()
        label.configure(
            color: UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1),
            font: UIFont(name: FontExtension.sfd500.rawValue, size: 16)!
        )
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(containerView)
        containerView.addSubview(optionLabel)
        
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension OptionCell {
    func configureCell(optionTitle: String, activeState: Bool) {
        optionLabel.text = optionTitle
        
        switch activeState {
        case true:
            optionLabel.textColor = .white
            containerView.backgroundColor = UIColor(red: 71/255, green: 190/255, blue: 154/255, alpha: 1)
        default:
            optionLabel.textColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1)
            containerView.backgroundColor = .white
        }
    }
}

extension OptionCell {
    private func setUpConstraints() {
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
        }
        
        optionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
}
