//
//  OnboardController.swift
//

import UIKit
import SnapKit

enum ActiveAnswerState: Equatable {
    case none
    case some(ind: Int)
}

final class OnboardController: UIViewController {
    private var onboardViewModel: OnboardViewModel
    var dataSource: Item?
    
    var currentQuestionIndex = 0 {
        didSet {
            animateQuestionChangeWithTransform()
        }
    }
    
    var activeAnswerStateIndex: ActiveAnswerState = .none {
        didSet {
            if let prevIndexPath = previousActiveIndexPath,
               case .some(let newIndex) = activeAnswerStateIndex {
                let newIndexPath = IndexPath(row: newIndex, section: 0)
                optionTableView.reloadRows(at: [prevIndexPath, newIndexPath], with: .automatic)
                previousActiveIndexPath = newIndexPath
            } else if case .some(let newIndex) = activeAnswerStateIndex {
                let newIndexPath = IndexPath(row: newIndex, section: 0)
                optionTableView.reloadRows(at: [newIndexPath], with: .automatic)
                previousActiveIndexPath = newIndexPath
                continueButton.style = .active
            }
        }
    }
    
    var previousActiveIndexPath: IndexPath? = nil
    
    init() {
        onboardViewModel = OnboardViewModel()
        
        super.init(nibName: nil, bundle: nil)
        
        self.onboardViewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private let setUpLabel = {
       let label = UILabel()
        
        label.configure(
            text: "Let’s setup App for you",
            color: UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1),
            font: UIFont(name: FontExtension.sfd700.rawValue, size: 26)!
        )
        
        return label
    }()
    
    private let questionView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var questionLabel = {
       let questionLabel = UILabel()
        questionLabel.configure(color: UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1),
                                font: UIFont(name: FontExtension.sfu600.rawValue, size: 20)!
        )
        
        return questionLabel
    }()
    
    lazy var optionTableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(OptionCell.self, forCellReuseIdentifier: String(describing: OptionCell.self))
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var downloadingDataLoader = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.hidesWhenStopped = true
        loader.color = .gray
        return loader
    }()
    
    private lazy var continueButton = {
       let button = StyledButton(title: "Continue")
        button.addTarget(self, action: #selector(continueBtnPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 245/255, alpha: 1)
        
        view.addSubview(setUpLabel)
        view.addSubview(questionView)
        view.addSubview(downloadingDataLoader)
        questionView.addSubview(questionLabel)
        questionView.addSubview(optionTableView)
        view.addSubview(continueButton)
        
        downloadingDataLoader.startAnimating()
        
        setUpConstraints()
    }
}

extension OnboardController {
    private func setUpConstraints() {
        setUpLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
        }
        
        questionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(setUpLabel.snp.bottom).offset(32)
            make.bottom.equalTo(continueButton.snp.top).offset(-10)
        }
        
        questionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
        }
        
        optionTableView.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        downloadingDataLoader.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        continueButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-48)
            make.height.equalTo(56)
        }
    }
}

extension OnboardController {
    @objc private func continueBtnPressed(_ sender: UIButton) {
        if let items = dataSource?.items, currentQuestionIndex == items.count - 1 {
            print("PremiumControllerShow")
        } else {
            currentQuestionIndex += 1
            activeAnswerStateIndex = .none
            continueButton.style = .inactive
        }
    }
}

extension OnboardController {
    private func doNextQuestion() {
        optionTableView.reloadData()
        questionLabel.text = dataSource?.items[currentQuestionIndex].question
        previousActiveIndexPath = nil
    }
}

extension OnboardController {
    private func animateQuestionChangeWithTransform() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.questionView.transform = CGAffineTransform(translationX: -self.view.bounds.width, y: 0)
        }) {[weak self] _ in
            self?.doNextQuestion()
            self?.questionView.transform = CGAffineTransform(translationX: self!.view.bounds.width, y: 0)
            UIView.animate(withDuration: 0.3) {
                self?.questionView.transform = CGAffineTransform.identity
            }
        }
    }
}

extension OnboardController: PopulatableDataSourceProtocol {
    func updateUI(data: Item) {
        dataSource = data
        DispatchQueue.main.async {[weak self] in
            self?.downloadingDataLoader.stopAnimating()
            self?.optionTableView.reloadData()
            self?.questionLabel.text = data.items[self!.currentQuestionIndex].question
        }
        
    }
    
    func showError(error: CustomError) {
        print(error.localizedDescription)
    }
}
