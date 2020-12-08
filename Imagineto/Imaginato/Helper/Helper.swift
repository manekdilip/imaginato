//
//  Helper.swift


import Foundation
import UIKit
import SystemConfiguration
import Toast_Swift //https://github.com/scalessec/Toast-Swift

enum social_type:String {
    case normal = "1"
    case facebook = "2"
    case google = "3"
    case instagram = "4"
    case apple = "5"

}

enum langCodes:String {
    case english = "en"
    case german = "de"
}


var topSafeAreaHeight: CGFloat?  = 0
var bottomSafeAreaHeight: CGFloat? = 0

//MARK: - longuage code
var currentLanguage = systemLanguage()
var safeAreaHeight = systemLanguage()

//MARK: - Media file name with extension
var cancelSoundFile: String = "PopOutKlick"
var cancelSoundExtension: String = "WAV"
var okSoundFile: String = "PopOutKlick"
var okSoundExtension: String = "WAV"
var pushNotiFile: String = "Pushnotify"
var pushNotiExtension: String = "wav"
var coinFile: String = "CoinList"
var coinExtension: String = "mp3"
var awardNotiFile: String = "AwardReach"
var isSocketConnect:Bool = false

var isPicTaken: Bool = false
var sharableUserId: String = ""
var storeVersion: String = "1"
var valueRedirection: String = "1"
/*TODO redirection
 Main Globle Pair screen - (valueRedirection == 0)
 pair(detail) - (valueRedirection == 1)
 Trophy(Expired challenge screen) - (valueRedirection == 2)
 own profile -> myshots -> comments - (valueRedirection == 3)
 other profile -> myshots -> comments - (valueRedirection == 4)*/

var isGiftSendback: Bool = true // Flag for put sendback btn in gift alert - TRUE for see sendback button, FALSE for not
var isCameraFlashlight: Bool = true // Flag for put Flashlight when capture picture in snapcamera screen - TRUE for see Flashlight, FALSE for not
var isAwardPopupOnNotification: Bool = true // Flag for awards popup when notification comes - TRUE for see Popup, FALSE for not
var isGiftsSend: Bool = true // Flag for send tab in gift list screen - TRUE for send list, FALSE for not
var isUserVotesScreen: Bool = true // Flag for user votes screen with voter to show - TRUE for see new cell, FALSE for not
var isAwardScreenTab: Bool = true // Flag for award screen tab - TRUE for show tab, FALSE for not

func systemLanguage() -> String {
    let langCode = Locale.preferredLanguages.first?.components(separatedBy: "-").first
    if langCode == "de"{
        return langCodes.german.rawValue
    }
    return langCodes.english.rawValue
}

//MARK: - Validate Phone number
func isValidPhone(phone: String) -> Bool {
    let phoneRegex = "^09[0-9]{8}$";
    let valid = NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
    return valid
}

//MARK: - Validate Email
func isValidEmail(testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

//MARK: - Check internet connection event
func isConnectedToNetwork() -> Bool {
    var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    }
    var flags = SCNetworkReachabilityFlags()
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
        return false
    }
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    return (isReachable && !needsConnection)
}

func hasTimerVal(startTime : String, endTime : String, currentServerTime:String) -> (Bool,CGFloat,(Int, Int, Int)) {
    let startDate = getDateFrom(startTime)
    let endDate = getDateFrom(endTime)
    let currentTime = getDateFrom(currentServerTime)
    if let objCurrentTime = currentTime, let objStartDate = startDate, let objEndDate = endDate {
        if objCurrentTime > objEndDate || objCurrentTime < objStartDate { // Check current server time condition
            return (false,0.0,(0,0,0))
        }
        let totalSeconds = getDiff(firstDate: objStartDate, secondDate: objEndDate)
        let completedSeconds = getDiff(firstDate: objStartDate, secondDate: objCurrentTime)
        let reamingTime = secondsToHoursMinutesSeconds(firstDate: objCurrentTime, secondDate: objEndDate)
        let endVaule = CGFloat(Double(completedSeconds)/Double(totalSeconds))
        return (endVaule > 0, endVaule,reamingTime)
    }
    return (false,0.0,(0,0,0))
}
func secondsToHoursMinutesSeconds (firstDate : Date, secondDate : Date) -> (Int, Int, Int) {
    let components = NSCalendar.current.dateComponents([.hour,.minute,.second], from: firstDate, to: secondDate)
    return (components.hour!, components.minute!, components.second!)
}
func totalSecondsToHoursMinutesSeconds (seconds : Double) -> (Double, Double, Double) {
    let (hr,  minf) = modf (seconds / 3600)
    let (min, secf) = modf (60 * minf)
    return (hr, min, 60 * secf)
}

func getDateFrom(_ strDate : String)-> Date? {
    if strDate.isEmpty { return Date() }
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.preferredLocale()
    dateFormatter.calendar = Calendar(identifier: .gregorian)
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    return dateFormatter.date(from: strDate)
}
func getGermanDate(_ strDate : String) -> String? {
    if strDate.isEmpty { return "" }
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.preferredLocale()
    dateFormatter.calendar = Calendar(identifier: .gregorian)
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    let germanDateFormatter = DateFormatter()
    germanDateFormatter.dateFormat = "dd.MM.yyyy"
    return germanDateFormatter.string(from: dateFormatter.date(from: strDate)!)
}
func getupdateDateFormate(_ strDate : String) -> String? {
    if strDate.isEmpty { return "" }
    let dateFormatter = DateFormatter()
   /// dateFormatter.calendar = Calendar(identifier: .gregorian)
    dateFormatter.timeZone = TimeZone(identifier: "CEST")
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let germanDateFormatter = DateFormatter()
    germanDateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
    germanDateFormatter.locale = Locale(identifier: "en_US_POSIX")
    if let dateNew = dateFormatter.date(from: strDate) as? Date{
        if let strDate = germanDateFormatter.string(from: dateNew) as? String{
            return strDate
        }else{
            return ""
        }
    }else{
        return ""
    }
}
func getLocalDate(date:String, getDateFormat: String = "dd.MM.yyyy HH:mm:ss") -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    if let dt = dateFormatter.date(from: date){
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = getDateFormat // yyyy-MM-dd HH:mm:ss
        if let dateChnged = dateFormatter.string(from: dt) as? String{
            return dateChnged
        }else{
            return ""
        }
    }else{
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let dt = dateFormatter.date(from: date){
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = getDateFormat // yyyy-MM-dd HH:mm:ss
            if let dateChnged = dateFormatter.string(from: dt) as? String{
                return dateChnged
            }else{
                return ""
            }
        }
        return ""
    }
}
func CESTToLocal(date:String , getDateFormat: String = "dd.MM HH:mm") -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    if currentLanguage == langCodes.german.rawValue {
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "CEST")
        // dateFormatter.timeZone = TimeZone.current
        if let dt = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = getDateFormat
            if let strDate = dateFormatter.string(from: dt) as? String{
                return strDate
            }else{
                return ""
            }
        }else{
            return ""
        }
    }else{
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let berlin = TimeZone(identifier: "Europe/Berlin")!
        dateFormatter.timeZone = berlin
        if let dt = dateFormatter.date(from: date){
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = getDateFormat
            if let strDate = dateFormatter.string(from: dt) as? String{
                return strDate
            }else{
                return ""
            }
        }else{
            return ""
        }
    }
}
func getDiff(firstDate : Date, secondDate : Date) -> Int {
    let components = NSCalendar.current.dateComponents([.second], from: firstDate, to: secondDate)
    return components.second!
}
func getDiffTime(firstDate : Date) -> (Int, Int, Int, Int) {
    let components = NSCalendar.current.dateComponents([.day, .hour, .minute, .second], from: NSDate() as Date, to: firstDate)
    return (components.day!, components.hour!, components.minute!, components.second!)
}
extension Locale {
    static func preferredLocale() -> Locale {
        guard let preferredIdentifier = Locale.preferredLanguages.first else {
            return Locale.current
        }
        return Locale(identifier: preferredIdentifier)
    }
}
func counterRetunWithText(aCount:String) -> String{
    if aCount.isEmpty{
        return "0"
    }else if aCount.count <= 3{
        return aCount
    }else if aCount.count <= 6{
        let firstValue = NSDecimalNumber(string: aCount)
        let secondValue = NSDecimalNumber(string: "1000")
        let result = firstValue.dividing(by: secondValue)
        //if round(result)
        if aCount.count <= 5{//Below or equal 1 lac
            return String(format: "%.1f Tsd", result.floatValue)
        }else{
            // Above 1 lac
            return String(format: "%.0f Tsd", round(result.doubleValue))
        }
    }else if aCount.count <= 8{
        let firstValue = NSDecimalNumber(string: aCount)
        let secondValue = NSDecimalNumber(string: "1000000")
        let result = firstValue.dividing(by: secondValue)
        if aCount.count <= 7{//Below or equal 10 lac
            return String(format: "%.1f M", result.floatValue)
        }else{//above 10 lac
            return String(format: "%.0f M", round(result.doubleValue))
        }
        
    }else if aCount.count > 8{
        let firstValue = NSDecimalNumber(string: aCount)
        let secondValue = NSDecimalNumber(string: "100000000")
        let result = firstValue.dividing(by: secondValue)
        return String(format: "%.1f B", result.floatValue)
    }else{
        return aCount
    }
}
func suffixNumber(aStr:String) -> String {
    
    if !aStr.isEmpty , aStr != "0" , let num1:Double = Double(aStr) {
        //func format(number: Double) -> String {
        
        let sign = ((num1 < 0) ? "-" : "" )
        let num = fabs(num1)
        
        // If its only three digit:
        if (num < 1000.0){
            return String(format:"\(sign)%g", num)
        }
        
        // Otherwise
        let exp: Int = Int(log10(num)/3.0)
        let units: [String] = ["k","M","B","T","P","E"]
        
        let roundedNum: Double = round(10 * num / pow(1000.0,Double(exp))) / 10
        
        return String(format:"\(sign)%g\(units[exp-1])", roundedNum)
    }else{
        return ""
    }
}
