//
//  UITextViewExtension.swift

import UIKit

extension UITextView {
    
    func setPlaceholder(placeholder:String, color:UIColor,whiteWithAlpha:Bool = false) {
        let placeholderLabel = UILabel()
        placeholderLabel.text = placeholder
        placeholderLabel.font = UIFont.init(name: (self.font?.fontName)!, size: (self.font?.pointSize)!)
        placeholderLabel.numberOfLines = 0
        placeholderLabel.sizeToFit()
        placeholderLabel.tag = 222
        placeholderLabel.textAlignment = .left
        placeholderLabel.frame = CGRect(x: 3, y: 8, width: placeholderLabel.frame.width, height: placeholderLabel.frame.height)
        placeholderLabel.isHidden = !self.text.isEmpty
        placeholderLabel.textColor = whiteWithAlpha ? UIColor(white: 1.0, alpha: 0.6) : color
        self.addSubview(placeholderLabel)
        self.layoutIfNeeded()
    }
    
    func checkPlaceholder() {
        let placeholderLabel = self.viewWithTag(222) as! UILabel
        placeholderLabel.isHidden = !self.text.isEmpty
        self.layoutIfNeeded()
    }
    func numberOfLinesText() -> Int {
        let layoutManager = self.layoutManager
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var lineRange: NSRange = NSMakeRange(0, 1)
        var index = 0
        var numberOfLines = 0

        while index < numberOfGlyphs {
            layoutManager.lineFragmentRect(
                forGlyphAt: index, effectiveRange: &lineRange
            )
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }
        return numberOfLines
    }
}
