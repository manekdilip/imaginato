//
//  UITableViewExtension.swift
//  Imaginato

import UIKit

extension UITableView {
    func reloadTableView() {
        DispatchQueue.main.async {
            self.reloadData()
            DispatchQueue.main.async {
                let dataCount = self.numberOfRows(inSection: 0)
                if dataCount == 0 {
                    //label add
                    let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
                    lbl.textColor = UIColor.gray
                    lbl.contentMode = .center
                    lbl.text = "No data found"
                    self.backgroundView = lbl
                }else {
                    self.backgroundView = nil
                }
            }
        }
    }
}
