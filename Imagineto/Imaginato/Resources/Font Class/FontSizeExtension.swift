//
//  SOIntExtension.swift

import Foundation
import UIKit

extension Bool {
    var intValue: Int {
        return self ? 1 : 0
    }
}
extension CGFloat{ 
    var fontSize : CGFloat {
        var deltaSize : CGFloat = 0;
        switch (UIDevice.deviceType) {
        case .iPhone4_4s,
             .iPhone5_5s :
            deltaSize = -2;
        case .iPhone6_6s :
            deltaSize = 0;
        case .iPhone6p_6ps :
            deltaSize = 1;
        case .iPhoneXSMax :
            deltaSize = 1;
        case .iPhoneXR :
            deltaSize = 1;
        case .iPad :
            deltaSize = 5;
        case .iPadPro :
            deltaSize = 5;
        default:
            deltaSize = 0;
        }
        let selfValue = self;
        return CGFloat(selfValue) + deltaSize;
    }
}
