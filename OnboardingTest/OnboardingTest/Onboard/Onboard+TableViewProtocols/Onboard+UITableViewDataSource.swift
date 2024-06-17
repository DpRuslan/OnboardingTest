//
//  Onboard+UITableViewDataSource.swift
//

import UIKit

extension OnboardController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource else {
            return 0
        }
        
        return dataSource.items[currentQuestionIndex].answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OptionCell.self), for: indexPath) as! OptionCell
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        guard let dataSource else {
            return cell
        }
        
        let isActive = (activeAnswerStateIndex == .some(ind: indexPath.row))
        
        cell.configureCell(
            optionTitle: dataSource.items[currentQuestionIndex].answers[indexPath.row] ?? "None",
            activeState: isActive
        )
        
        return cell
    }
}
