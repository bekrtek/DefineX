//
//  SceneDelegate.swift
//  DefineXHomeAssigment
//
//  Created by Bekir Tek on 9.01.2025.
//

import UIKit

struct Colors {
    static let primary = UIColor(red: 67/255, green: 134/255, blue: 244/255, alpha: 1) // Blue color for title
    
    struct Button {
        static let loginGradientStart = UIColor(red: 69/255, green: 227/255, blue: 177/255, alpha: 1)
        static let loginGradientEnd = UIColor(red: 69/255, green: 217/255, blue: 177/255, alpha: 1)
        static let facebook = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1)
        static let twitter = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
    }
    
    struct TextField {
        static let title = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
        static let text = UIColor.black
        static let placeholder = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
        static let icon = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
        
        struct Line {
            static let `default` = UIColor(red: 229/255, green: 229/255, blue: 234/255, alpha: 1)
            static let focused = UIColor(red: 69/255, green: 227/255, blue: 177/255, alpha: 1)
            static let error = UIColor.systemRed
        }
    }
    
    struct ForgotPassword {
        static let text = UIColor(red: 67/255, green: 134/255, blue: 244/255, alpha: 1)
        static let border = UIColor(red: 229/255, green: 229/255, blue: 234/255, alpha: 1)
    }
} 
