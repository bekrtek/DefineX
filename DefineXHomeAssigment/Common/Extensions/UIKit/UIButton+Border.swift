//
//  UIButton+Border.swift
//  DefineXHomeAssigment
//
//  Created by Bekir Tek on 9.01.2025.
//

import UIKit

extension UIButton {
    func configureBorder(color: UIColor, width: CGFloat, cornerRadius: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true 
    }
}
