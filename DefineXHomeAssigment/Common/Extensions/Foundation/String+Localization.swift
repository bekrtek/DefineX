//
//  SceneDelegate.swift
//  DefineXHomeAssigment
//
//  Created by Bekir Tek on 9.01.2025.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
} 
