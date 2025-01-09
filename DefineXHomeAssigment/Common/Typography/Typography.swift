//
//  SceneDelegate.swift
//  DefineXHomeAssigment
//
//  Created by Bekir Tek on 9.01.2025.
//

import UIKit

enum Typography {
    case headlin24
    case title20
    case subheading16
    case medium14
    case regular14
    case regular12
    case miniCaps10
    
    var font: UIFont {
        switch self {
        case .headlin24:
            return .systemFont(ofSize: 24, weight: .bold)
        case .title20:
            return .systemFont(ofSize: 20, weight: .semibold)
        case .subheading16:
            return .systemFont(ofSize: 16, weight: .medium)
        case .medium14:
            return .systemFont(ofSize: 14, weight: .medium)
        case .regular14:
            return .systemFont(ofSize: 14, weight: .regular)
        case .regular12:
            return .systemFont(ofSize: 12, weight: .regular)
        case .miniCaps10:
            return .systemFont(ofSize: 10, weight: .regular)
        }
    }
}

extension UILabel {
    func setTypography(_ typography: Typography) {
        self.font = typography.font
    }
}

extension UITextField {
    func setTypography(_ typography: Typography) {
        self.font = typography.font
    }
}

extension UIButton {
    func setTypography(_ typography: Typography) {
        self.titleLabel?.font = typography.font
    }
} 
