//
//  PurchaseController.swift
//

import UIKit
import SnapKit

protocol ClosablePurchaseDelegate: AnyObject {
    func closePurchase()
}

final class PurchaseController: UIViewController {
    weak var delegate: ClosablePurchaseDelegate?
    private var purchaseViewModel: PurchaseViewModel
    private var hasSubscription: Bool = false
    
    init() {
        purchaseViewModel = PurchaseViewModel()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private lazy var illustrationImageView = {
        let imageView = UIImageView(image: UIImage(named: "Illustration")!)
        return imageView
    }()
    
    private lazy var closeButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "closePurchase")!, for: .normal)
        button.addTarget(self, action: #selector(closeBtnPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var discoverLabel = {
       let label = UILabel()
        label.configure(
            text: "Discover all\nPremium features",
            color: UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1),
            font: UIFont(name: FontExtension.sfd700.rawValue, size: 32)!
        )
        
        return label
    }()
    
    private lazy var autoRenewableLabel = {
        let label = UILabel()
        
        label.configureAttributedLbl(
            fullText: "Try 7 days for free\nthen \(PurchaseManager.shared.subscriptions[0].displayPrice) per week, auto-renewable",
            attributedText: "\(PurchaseManager.shared.subscriptions[0].displayPrice)",
            defaultTextColor: UIColor(red: 110/255, green: 110/255, blue: 115/255, alpha: 1),
            defaultFont: UIFont(name: FontExtension.sfd500.rawValue, size: 16)!,
            specialTextColor: UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1),
            specialFont: UIFont(name: FontExtension.sfd700.rawValue, size: 16)!
        )
        
        return label
    }()
    
    private lazy var startButton = {
       let button = StyledButton(title: "Start Now")
        button.style = .active
        button.addTarget(self, action: #selector(startBtnPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var termsLabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        
        label.configureAttributedLbl(
            fullText: "By continuing you accept our:\nTerms of Use, Privacy Policy, Subscription Terms",
            attributedText: "Terms of Use, Privacy Policy, Subscription Terms",
            defaultTextColor:  UIColor(red: 110/255, green: 110/255, blue: 115/255, alpha: 1),
            defaultFont: UIFont(name: FontExtension.sfd400.rawValue, size: 12)!,
            specialTextColor: UIColor(red: 32/255, green: 139/255, blue: 1, alpha: 1),
            specialFont: UIFont(name: FontExtension.sfd400.rawValue, size: 12)!,
            alignment: .center
        )
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(termsGesturePressed))
        label.addGestureRecognizer(gesture)
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 245/255, alpha: 1)
        
        view.addSubview(illustrationImageView)
        view.addSubview(closeButton)
        view.addSubview(discoverLabel)
        view.addSubview(autoRenewableLabel)
        view.addSubview(startButton)
        view.addSubview(termsLabel)
        
        setUpConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hasSubscription = !PurchaseManager.shared.purchasedSubscriptions.isEmpty
        if hasSubscription {
            startButton.updateTitle(title: "Purchased")
            startButton.isEnabled = false
        }
    }
}

extension PurchaseController {
    @objc private func closeBtnPressed(_ sender: UIButton) {
        delegate?.closePurchase()
    }
    
    @objc private func termsGesturePressed(_ sender: UITapGestureRecognizer) {
        Configuration.termsLink.openTermsURL()
    }
    
    @objc private func startBtnPressed(_ sender: UIButton) {
        Task {
            do {
                if ((try await purchaseViewModel.purchase(product: PurchaseManager.shared.subscriptions[0])) != nil) {
                    DispatchQueue.main.async {[weak self] in
                        guard let self = self else { return }
                        self.delegate?.closePurchase()
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    print("Purchase failed: \(error)")
                }
            }
        }
    }
}

extension PurchaseController {
    private func setUpConstraints() {
        closeButton.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        
        illustrationImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(illustrationImageView.snp.width).multipliedBy(hasPhysicalHomeBtn() ? 0.9 : 1.08)
        }
        
        discoverLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.top.equalTo(illustrationImageView.snp.bottom).offset(40)
        }
        
        autoRenewableLabel.snp.makeConstraints { make in
            make.leading.equalTo(discoverLabel)
            make.top.equalTo(discoverLabel.snp.bottom).offset(16)
        }
        
        startButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(56)
            make.bottom.equalTo(termsLabel.snp.top).offset(-20)
        }
        
        termsLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
