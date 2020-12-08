//
//  ErrorlineTextFiledCell.swift

// Refernce taken from : https://github.com/ninjaprox/NVActivityIndicatorView

import UIKit
import NVActivityIndicatorView
class loaderView: UIView {
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var viewLoader: NVActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func showHuder(){
        viewLoader.type = .circleStrokeSpin
        viewLoader.startAnimating()
    }
    func dismissHuder() {
        viewLoader.stopAnimating()
    }
}
