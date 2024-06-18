//
//  OnboardViewModel.swift
//

import Foundation

protocol PopulatableDataSourceProtocol: AnyObject {
    func updateUI(data: Item)
    func showError(error: CustomError)
}

final class OnboardViewModel {
    weak var delegate: PopulatableDataSourceProtocol?
    
    init() {
        doRequest()
    }
}

extension OnboardViewModel {
    func doRequest() {
        APIManager.shared.doRequest {[weak self] result in
            switch result {
            case .success(let data):
                ParseManager.shared.parseResponse(data: data) { status in
                    switch status {
                    case .success(let data):
                        self?.delegate?.updateUI(data: data)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                switch error {
                case .urlSession, .uknown:
                    self?.delegate?.showError(error: error)
                default:
                    print(error.localizedDescription)
                }
            }
        }
    }
}
