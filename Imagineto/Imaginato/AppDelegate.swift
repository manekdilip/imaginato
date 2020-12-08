//
//  AppDelegate.swift


import UIKit
import FirebaseCrashlytics
import IQKeyboardManagerSwift
import Firebase
import CoreData

var appDelegate = UIApplication.shared.delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var removeHudderCompletion:(() ->Void)?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        return true
    }
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
}
// MARK: -Loader for api call
extension AppDelegate {
    func showLoader(message:String, parentView : UIView? = nil) {
        hideLoader()// already show then first  dismiss it
        //for - show hudder
        if let loaderView = Bundle.main.loadNibNamed("loaderView", owner: self, options: nil)?[0] as? loaderView{
            loaderView.lblMessage.text = message
            loaderView.frame = UIScreen.main.bounds
            if parentView != nil{
                parentView?.layoutIfNeeded()
                loaderView.frame = CGRect(x: 0, y: 0, width: (parentView?.frame.size.width)!, height:  (parentView?.frame.size.height)!)
                parentView?.addSubview(loaderView)
            }else {
                self.fetchTopWindownsView(aView: loaderView)
            }
            loaderView.showHuder()
            //for - Dismiss hudder
            appDelegate.removeHudderCompletion = {
                if loaderView != nil {
                    loaderView.dismissHuder()
                    loaderView.removeFromSuperview()
                  
                }
            }
        }
    }
    func hideLoader(){
        appDelegate.removeHudderCompletion?()
    }
}
// MARK: - Get top UIs
extension AppDelegate {
    func fetchTopWindownsVC() -> UIViewController {
        if let VC = self.window?.rootViewController?.presentedViewController {
            if  VC is UINavigationController {
                let navVC = VC as? UINavigationController
                if  let lastVC:UIViewController = navVC?.viewControllers.last {
                    return lastVC
                }else{
                    return self.window!.rootViewController!
                }
            }else{
                return self.window!.rootViewController!
            }
        }else{
            return self.window!.rootViewController!
        }
    }
    func fetchTopWindownsView(aView:UIView)  {
        if let VC = self.window?.rootViewController?.presentedViewController {
            if  VC is UINavigationController {
                let navVC = VC as? UINavigationController
                if  let lastVC:UIViewController = navVC?.viewControllers.last {
                    lastVC.view.addSubview(aView)
                }else{
                    self.window?.rootViewController?.view.addSubview(aView)
                }
            }else{
                self.window?.rootViewController?.view.addSubview(aView)
            }
        }else{
            self.window?.rootViewController?.view.addSubview(aView)
        }
    }
}
// MARK: - Core Data stack
extension AppDelegate {
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = Datamanager.shared.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
