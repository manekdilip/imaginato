//
//  MyUserDefault.swift


import UIKit
import Foundation

//MARK: - MyUserDefaults Constant
struct MyUserDefaults {
    static let uniqueID:String = "uniqueID"
 }
//MARK: - Get/Set UserDefaults
func setMyUserDefaults(value:Any, key:String){
    UserDefaults.standard.set(value, forKey: key)
    UserDefaults.standard.synchronize()
}
func isKeyPresentInUserDefaults(key: String) -> Bool {
    return UserDefaults.standard.object(forKey: key) != nil
}
func getMyUserDefaults(key:String)->Any{
    return UserDefaults.standard.value(forKey: key) ?? ""
}
func getMyUserDefaultsBoolVal(key:String)->Bool{
    return UserDefaults.standard.bool(forKey: key)
}
func clearMyUserDefaluts(){
    let appDomain = Bundle.main.bundleIdentifier!
    UserDefaults.standard.removePersistentDomain(forName: appDomain)
    UserDefaults.standard.synchronize()
}
func removeMyUserDefaults(key:String){
    UserDefaults.standard.removeObject(forKey: key)
}

