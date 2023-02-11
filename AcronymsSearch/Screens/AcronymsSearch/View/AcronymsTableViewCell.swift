//
//  AcronymsTableViewCell.swift
//  AcronymsSearch
//
//  Created by Gireesh on 11/02/23.
//

import UIKit

class AcronymsTableViewCell: UITableViewCell {

    @IBOutlet weak var acronymsLabel: UILabel!
    
    // Use this view model to bind the data to cell
    var cellViewModel: AcronymsCellViewModel? {
        didSet {
            acronymsLabel.text = cellViewModel?.acronyms
        }
    }
    
}
