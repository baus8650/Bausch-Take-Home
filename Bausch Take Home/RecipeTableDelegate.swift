//
//  RecipeTableDelegate.swift
//  Bausch Take Home
//
//  Created by Tim Bausch on 1/19/22.
//

import Foundation
import UIKit

class RecipeTableDelegate: NSObject, UITableViewDelegate {
    // #1
//    weak var delegate: ViewControllerDelegate?
    
    // #2
//    init(withDelegate delegate: ViewControllerDelegate) {
//        self.delegate = delegate
//    }
    
    // #3
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.delegate?.selectedCell(row: indexPath.row, section: indexPath.section)
//    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor(named: "default")
        header.textLabel?.text = header.textLabel?.text?.capitalized
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        header.textLabel?.frame = header.bounds

    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
