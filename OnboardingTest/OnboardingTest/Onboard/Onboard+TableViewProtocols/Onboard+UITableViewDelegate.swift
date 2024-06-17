//
//  Onboard+UITableViewDelegate.swift
//

import UIKit

extension OnboardController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if case .some(let ind) = activeAnswerStateIndex, ind == indexPath.row {
            return
        } else {
            activeAnswerStateIndex = .some(ind: indexPath.row)
        }
    }
}
