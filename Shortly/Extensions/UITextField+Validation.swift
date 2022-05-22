//
//  UITextField+Validation.swift
//  Shortly
//
//  Created by Abdullah Muhammad Zubair on 2/27/22.
//

import UIKit

extension UITextField {
    var isValid: Bool {
        return !(self.text?.isEmpty ?? false)
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[.foregroundColor: newValue!,
                            .font: UIFont(name: "Poppins-SemiBold", size: 17) ?? UIFont.systemFont(ofSize: 17)])
        }
    }
    
    func setupValidationDesign()
    {
        self.layer.borderWidth = 2
        self.layer.borderColor = isValid ? UIColor.clear.cgColor : Theme.validationColor.cgColor
        self.placeHolderColor = isValid ? UIColor.lightGray : Theme.validationColor
        self.placeholder = isValid ? "Shorten a link here ..." : "Please add a link here"
    }
}
