//
//  SceneDelegate.swift
//  DefineXHomeAssigment
//
//  Created by Bekir Tek on 9.01.2025.
//

import UIKit

extension UIView {
    var isRTL: Bool {
        return UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
    }
    
    func setupRTLSupport() {
        if isRTL {
            self.semanticContentAttribute = .forceRightToLeft
        } else {
            self.semanticContentAttribute = .forceLeftToRight
        }
    }
}

extension UITextField {
    func setupRTLTextAlignment() {
        self.textAlignment = isRTL ? .right : .left
    }
}

extension UIButton {
    func setupRTLContentAlignment() {
        self.contentHorizontalAlignment = isRTL ? .right : .left
    }
}

extension UIStackView {
    func setupRTLArrangement() {
        self.semanticContentAttribute = isRTL ? .forceRightToLeft : .forceLeftToRight
    }
} 
