//
//  ViewController.swift

import UIKit

class DairyListVC: UIViewController {
    // MARK:  All outlets and varibles
    @IBOutlet weak var tblView: UITableView!
    var arrItems = [DairytemModel]()
    
    // MARK: - override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.setUpData()
    }
}
// MARK: - All Custome methods
extension DairyListVC {
    func setUpUI()  {
        self.tblView.tableFooterView = UIView()
    }
    func setUpData()  {
        self.arrItems = retrieveData()
        if self.arrItems.isEmpty{
            self.webapi_for_get_dairy_listing()
        }else{
            self.reflectDataTotable()
        }
    }
    func reflectDataTotable()  {
        self.arrItems = retrieveData()
        self.tblView.reloadTableView()
    }
}
// MARK: - TableView DataSource and Delegate methods
extension DairyListVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrItems.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "DairyItemCell") as? DairyItemCell
        if cell == nil {
            let arrNib : Array = Bundle.main.loadNibNamed("DairyItemCell",owner: self, options: nil)!
            cell = arrNib[0] as? DairyItemCell
            cell?.selectionStyle = .none
        }
        let row:Int = indexPath.row
        cell?.cntrEdit.tag = row
        cell?.cntrlDelete.tag = row
        let itemData = self.arrItems[row]
        if let prevIndex:Int = (row - 1), prevIndex <= (self.arrItems.count - 1) , prevIndex > 0{
            let itemDataPrev = self.arrItems[prevIndex]
            cell?.setUpCellData(aData:itemData, aPrevDat: itemDataPrev)
        }else{
            cell?.setUpCellData(aData:itemData, aPrevDat:DairytemModel() )
        }
        cell?.cntrEdit.removeTarget(self, action: #selector(self.clickOnEditItem(_:)), for: .touchUpInside)
        cell?.cntrlDelete.removeTarget(self, action: #selector(self.clickOnDeleteItem(_:)), for: .touchUpInside)
        cell?.cntrEdit.addTarget(self, action: #selector(self.clickOnEditItem(_:)), for: .touchUpInside)
        cell?.cntrlDelete.addTarget(self, action: #selector(self.clickOnDeleteItem(_:)), for: .touchUpInside)
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
// MARK: - All click events
extension DairyListVC {
    @IBAction func clickOnEditItem(_ sender: UIControl) {
        let vcDetail = storyBoards.Main.instantiateViewController(withIdentifier: "DairyItemEditingVC") as?  DairyItemEditingVC
        let dataItem = self.arrItems[sender.tag]
        vcDetail?.item = dataItem
        vcDetail?.indexItem  = sender.tag
        vcDetail?.completionEditing = { [weak self] (Index,dataEditItem) in
            updateData(aItem: dataEditItem)
            self?.reflectDataTotable()
        }
        self.navigationController?.pushViewController(vcDetail!, animated: true)
    }
    @IBAction func clickOnDeleteItem(_ sender: UIControl) {
        showAlert(msg: MyAlertDefault.deleteNote) { (isFinished) in
            if isFinished {
                let item = self.arrItems[sender.tag]
                deleteData(aItem: item)
                self.reflectDataTotable()
            }
        }
    }
}
// MARK: - Web APi classed
extension DairyListVC {
    func webapi_for_get_dairy_listing() {
        appDelegate.showLoader(message: loading)
        apiManager.callGetApi(url: WebURL.notes, perameter: [:], header: nil ){ (response,error) in
            appDelegate.hideLoader()
            if error != nil{
                showNetworAlert(completion: nil)
                return
            }else if response!.response?.statusCode == 200 {
                 if let dicResult = response!.result.value as? [[String:Any]] {
                    let arrIemData = creatArray(value: dicResult as AnyObject)
                    var arrDataitems = [DairytemModel]()
                    for itemData in arrIemData{
                        let modelItem = DairytemModel(withJason:itemData as! [String : Any] )
                        arrDataitems.append(modelItem)
                    }
                    createData(arrIemData: arrDataitems)
                }
            }else{
                showNetworAlert(completion: nil)
            }
            self.reflectDataTotable()
        }
    }
}

