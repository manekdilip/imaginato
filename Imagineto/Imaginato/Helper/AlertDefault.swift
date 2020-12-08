//
//  AlertDefault.swift

import UIKit

struct MyAlertDefault {
    //login
    //Enter Wrong mobile number in
    static var ok:String = "OK"
    static var canel:String = "CANCEL"
    static var btnYes : String = "Yes"
    static var btnNo : String = "No"
    static var success:String = "Success"
    static var network_error:String = "Network error"
    static var server_error:String = "Network error"
    static var deleteNote = "Are you sure, you want to delete?"

}
//MARK: - Show Alert
func showNetworAlert( completion:((Bool)->())?){
    let alert = UIAlertController(title: MyAlertDefault.network_error, message:MyAlertDefault.server_error, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: MyAlertDefault.ok, style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
        if completion != nil {
            completion?(true)
        }
    }))
    UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
}
func showAlert(msg:String,completion:((Bool)->())?) {
    let alert = UIAlertController(title: "", message:msg, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: MyAlertDefault.btnYes, style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
        if completion != nil {
            completion?(true)
        }
    }))
    alert.addAction(UIAlertAction(title: MyAlertDefault.btnNo, style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
        if completion != nil {
            completion?(false)
        }
    }))

    UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
}
