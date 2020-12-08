//
//  NitroLog.swift
//  HurbaScooter
//
//  Created by Apple on 19/02/19.
//

import Foundation

public class SnapLog: TextOutputStream {
    
    var logFile : String = "SnapLog.txt"
    
    public init() {} // we are sure, nobody else could create it
    
    public func write(_ string: String) {
        
        let printStr = "\n" + "\(Date()) \(string) " + "\n"
        
        let fm = FileManager.default
        let log = fm.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(logFile)
        
        if let handle = try? FileHandle(forWritingTo: log) {
            handle.seekToEndOfFile()
            handle.write(printStr.data(using: .utf8)!)
            handle.closeFile()
        } else {
            print("\n\nLog File Path : \(log.absoluteString)\n\n")
            try? printStr.data(using: .utf8)?.write(to: log)
        }
    }
    
    func getLogFileData(completionHandler: @escaping (_ fileData : Data) -> Void) {
        let allPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = allPaths.first!
        let pathForLog = documentsDirectory.appending("/\(logFile)")
        if let fileData = NSData(contentsOfFile: pathForLog) {
            completionHandler(fileData as Data)
        }else {
            self.write("Error in load logfile data from document directory path")
        }
    }
    
    func removeLogFile() {
        let fileManager = FileManager.default
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        guard let dirPath = paths.first else {
            return
        }
        let filePath = "\(dirPath)/\(logFile)"
        do {
            try fileManager.removeItem(atPath: filePath)
            self.write(appName())
        } catch let error as NSError {
            self.write("Error in remove logfile from document directory path\n\(error.debugDescription)")
        }
    }
    
    func appName() -> String {
        return createString(value: Bundle.main.infoDictionary![kCFBundleNameKey as String] as AnyObject)
    }
}
