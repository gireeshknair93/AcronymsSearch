//
//  String+Extension.swift
//  AcronymsSearch
//
//  Created by Gireesh on 11/02/23.
//

import Foundation

extension String {
    
    var isEmpty: Bool {
        return self.count == 0
    }
    
    var containsSpecialCharacters: Bool {
        return self.range(of: "[!\"#$%&'()*+,-./:;<=>?@\\[\\\\\\]^_`{|}~]+", options: .regularExpression) != nil
    }
        
    var isStartWithNumber: Bool {
        let firstChar = self.first
        return firstChar?.isNumber ?? false
    }
    
    var isStartWithWhiteSpace: Bool {
        return self.hasPrefix(" ")
    }
}
