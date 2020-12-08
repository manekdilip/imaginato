//
//  DairyItemEditingVC.swift


import UIKit

class DairyItemEditingVC: UIViewController {
    //All Outletes
    @IBOutlet weak var textTitle: UITextField!
    @IBOutlet weak var txtViewContent: UITextView!
    @IBOutlet weak var consHightTextView: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var consBottomScrlView: NSLayoutConstraint!
    
    // variables
    var item = DairytemModel()
    var completionEditing :((Int,DairytemModel) -> Void)?
    var indexItem = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
}
// MARK: - All Custom class
extension DairyItemEditingVC{
    func setupUI()  {
        self.textTitle.text = item.title
        self.txtViewContent.setPlaceholder(placeholder: txtplaceHolderItem, color: greyColor)
        self.txtViewContent.text = item.content
        self.textViewDidChange(self.txtViewContent)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
// MARK: - All click events
extension DairyItemEditingVC{
    @IBAction func clickOnBack(_ sender: UIControl) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func clickOnEdit(_ sender: UIControl) {
        self.item.title = self.textTitle.text!
        self.item.content = self.txtViewContent.text!
        self.completionEditing?(indexItem,item)
        self.clickOnBack(UIControl())
    }
}
// MARK: - TextView Delegate Methods
extension DairyItemEditingVC :UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        DispatchQueue.main.async {
            self.scrollView.scrollToBottom(iSAnimated: false)
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    func textViewDidChange(_ textView: UITextView) {
        self.txtViewContent.text =  self.txtViewContent.text.trimmingCharacters(in: CharacterSet.whitespaces)
        DispatchQueue.main.async {
            self.txtViewContent.checkPlaceholder()
            self.adjustTextViewHeight()
        }
    }
    func adjustTextViewHeight() {
        let fixedWidth = self.txtViewContent.frame.size.width
        self.txtViewContent.sizeToFit()
        let newSize = self.txtViewContent.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        if newSize.height > 30.0 {
            self.consHightTextView.constant = newSize.height
        }else{
            self.consHightTextView.constant = newSize.height
        }
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
        }
    }
}
// MARK: - keyboard classes
extension DairyItemEditingVC{
       @objc func keyboardWillShow(notification: NSNotification) {
        let _: CGFloat = 20 // Padding between the bottom of the view and the top of the keyboard
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = value.cgRectValue.height
        self.consBottomScrlView.constant = keyboardHeight
        layoutTableView()
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.consBottomScrlView.constant = 110
        layoutTableView()
    }
    
    private func layoutTableView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
