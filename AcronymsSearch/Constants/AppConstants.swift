//
//  AppConstants.swift
//  AcronymsSearch
//
//  Created by Gireesh on 11/02/23.
//

import Foundation

//MARK: Server end point
struct ApiEndPoints {
    static let search = "http://www.nactem.ac.uk/software/acromine/dictionary.py"
}

//MARK: App Messages
struct Messages {
    static let invalidInput = "Please enter a valid search keyword. The keyword should not contain numbers and special characters"
    static let apiError = "Oops, there is an error while loading your acronyms. Please try again"
    static let emptySearchField = "Type a keyword to load the abbreviations"
    static let noResultFound = "Oops, We are not able to find any matches for your keyword."
}
