//
//  DairyItemCell.swift


import UIKit

class DairyItemCell: UITableViewCell {

    @IBOutlet weak var viewTimerUper: UIView!
    @IBOutlet weak var lblTimeTextTop: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescp: UILabel!
    @IBOutlet weak var lblTimerNumBottom: UILabel!
    @IBOutlet weak var cntrEdit: UIControl!
    @IBOutlet weak var cntrlDelete: UIControl!
    @IBOutlet weak var conslineDeviderHeight: NSLayoutConstraint?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setUpCellData(aData:DairytemModel,aPrevDat:DairytemModel)  {
        let date  = getDateFrom(aData.date)
        let strSince = date?.timeAgoSince(date!)
        let strAgo = date?.timeAgoDisplay()
        self.viewTimerUper.isHidden = false
        self.conslineDeviderHeight?.constant = 28.0
        if !aPrevDat.date.isEmpty{
            let datePrev  = getDateFrom(aPrevDat.date)
            let strPrevSince = datePrev?.timeAgoSince(datePrev!)
            if strSince?.lowercased() == strPrevSince?.lowercased(){
                self.viewTimerUper.isHidden = true
                self.conslineDeviderHeight?.constant = 40.0
            }
        }
        self.lblTimeTextTop.text = strSince
        self.lblTitle.text = aData.title
        self.lblDescp.text = aData.content
        self.lblTimerNumBottom.text = strAgo
    }
    
}
