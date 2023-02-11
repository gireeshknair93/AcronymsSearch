//
//  UITableView+Extension.swift
//  AcronymsSearch
//
//  Created by Gireesh on 11/02/23.
//

import UIKit

extension UITableView {
    
    // To register cell on the table view
    func registerCell(identifier: String) {
        let cellId = String(describing: identifier)
        register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: identifier)
    }
}

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
