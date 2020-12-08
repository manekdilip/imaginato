//
//  NSMutableArrayExtension.swift

import UIKit

//Create arrar from any object
func creatArray(value: AnyObject) -> NSMutableArray {
    
    var tempArray = NSMutableArray()
    
    if let arrData: NSArray = value as? NSArray {
        
        tempArray = NSMutableArray.init(array: arrData)
    }
    else if let _: NSNull = value as? NSNull {
        
        tempArray = NSMutableArray.init()
    }
    
    return tempArray
}
