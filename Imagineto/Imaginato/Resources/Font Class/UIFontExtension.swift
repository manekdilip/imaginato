//
//  SOUIFontExtension.swift

import Foundation
import UIKit



extension UIFont {
    static var delatFontSize : CGFloat {
        return 0.0
    }
    class func NunitoSans_Bold(_ size : CGFloat) -> UIFont {
        return UIFont(name: "NunitoSans-Bold", size: size)!;
    }
    class func NunitoSans_Italic(_ size : CGFloat) -> UIFont {
        return UIFont(name: "NunitoSans-Italic.ttf", size: size)!;
    }
    class func NunitoSans_Light(_ size : CGFloat) -> UIFont {
        return UIFont(name: "NunitoSans-Light", size: size)!;
    }
    class func NunitoSans_Regular(_ size : CGFloat) -> UIFont {
        return UIFont(name: "NunitoSans-Regular", size: size)!;
    }
    class func NunitoSans_SemiBold(_ size : CGFloat) -> UIFont {
        return UIFont(name: "NunitoSans-SemiBold", size: size)!;
    }
    class func printFonts() {
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName)
            print("--- Font Names = [\(names)]")
        }
    }
}

extension UILabel
{
    open override func awakeFromNib()
    {
        super.awakeFromNib()
        self.font = self.font.withSize(self.font.pointSize.fontSize)
    }
}
extension UIButton
{
    open override func awakeFromNib()
    {
        super.awakeFromNib()
        self.titleLabel?.font = self.titleLabel?.font.withSize((self.titleLabel?.font.pointSize.fontSize)!)
    }
}
extension UITextField
{
    open override func awakeFromNib()
    {
        super.awakeFromNib()
        self.font = self.font?.withSize((self.font?.pointSize.fontSize)!)
    }
}
extension UITextView
{
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.font = self.font?.withSize((self.font?.pointSize.fontSize)!)
    }
}
