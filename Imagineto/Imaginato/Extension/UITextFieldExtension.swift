//
//  UITextFieldExtension.swift


import UIKit
//MARK: - UITextfield Extension
private var __maxLengths = [UITextField: Int]()
extension UITextField {
    //Set placeholder font
    func setPlaceholderFont(font: UIFont) {
        
        let lblPlaceHolder:UILabel = self.value(forKey: "_placeholderLabel") as! UILabel
        lblPlaceHolder.font = font
    }
    //Set placeholder color
    func setPlaceholderColor(color: UIColor) {
        let lblPlaceHolder:UILabel = self.value(forKey: "_placeholderLabel") as! UILabel
        lblPlaceHolder.textColor = color
    }
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
}

extension String
{
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
}
