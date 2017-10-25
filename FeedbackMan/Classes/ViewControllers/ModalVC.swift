import Foundation
import UIKit

public final class ModalVC: UIViewController, UITextViewDelegate, UIScrollViewDelegate {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var screenshotImageView: UIImageView!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var fileNameField: UITextField!
    @IBOutlet var channelNameField: UITextField!
    @IBOutlet var feedbackTextView: UITextView!
    @IBOutlet var likeBtn: UIButton!
    
    private var presenter = ModalPresenter()
    var activeTextView = UITextView()
    var indicator: UIActivityIndicatorView!
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        feedbackTextView.delegate = self
        setupLikeBtn()
        setupDoneBtn()
        setupIndicator()
        screenshotImageView.image = presenter.uiScreenImage
        fileNameField.text = "screenshot-" + getNowClockString()
        channelNameField.text = FeedbackManManager.APIConstants.channel
        feedbackTextView.textColor = UIColor.lightGray
        presenter.fbdata.viewControllerName = UIApplication.topViewController()?.className ?? ""
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(ModalVC.handleKeyboardWillShowNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(ModalVC.handleKeyboardWillHideNotification(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    public static func instantiate() -> ModalVC {
        let podBundle = Bundle(for: ModalVC.self)
        guard let url = podBundle.url(forResource: "FeedbackMan", withExtension: "bundle") else {
            fatalError("ModalVC could not be loaded.")
        }
        let sb = UIStoryboard(name: "ModalVC", bundle: Bundle(url:url))
        return sb.instantiateInitialViewController() as! ModalVC
    }
    
    func setupLikeBtn() {
        let podBundle = Bundle(for: ModalVC.self)
        if let url = podBundle.url(forResource: "FeedbackMan", withExtension: "bundle") {
            let likeImage = UIImage(named: "like_button.png", in: Bundle(url: url), compatibleWith: nil)
            likeBtn.setImage(likeImage, for: .normal)
        } else {
            print("Like button image could not be loaded.")
        }
    }
    
    func setupDoneBtn() {
        nameField.returnKeyType = .done
        fileNameField.returnKeyType = .done
        channelNameField.returnKeyType = .done
        
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        kbToolBar.barStyle = .default
        kbToolBar.sizeToFit()
        
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(ModalVC.doneBtnTapped))
        
        kbToolBar.items = [spacer, doneBtn]
        feedbackTextView.inputAccessoryView = kbToolBar
    }
    
    func setupIndicator() {
        indicator = UIActivityIndicatorView()
        indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(indicator)
    }
    
    func getNowClockString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let now = Date()
        return formatter.string(from: now)
    }
    
    @IBAction func editBtnTapped(_ sender: Any) {
        let podBundle = Bundle(for: ImageEditVC.self)
        guard let url = podBundle.url(forResource: "FeedbackMan", withExtension: "bundle") else {
            fatalError("ImageEditVC could not be loaded.")
        }
        let sb = UIStoryboard(name: "ImageEditVC", bundle: Bundle(url: url))
        let vc = sb.instantiateViewController(withIdentifier: "ImageEditVC") as! ImageEditVC
        self.present(vc, animated: true, completion: nil)
        vc.screenshotImageView.image = screenshotImageView.image
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        if feedbackTextView.textColor != UIColor.lightGray {
            let detail = feedbackTextView.text ?? ""
            sendFeedbackData(with: detail)
        } else {
            sendFeedbackData(with: "")
        }
    }
    
    @IBAction func likeBtnTapped(_ sender: Any) {
        let liketext = "Like button pressed!"
        sendFeedbackData(with: liketext)
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dismissModal()
    }
    
    func sendFeedbackData(with description: String) {
        var fbdata = presenter.setFeedbackData()
        fbdata.title = fileNameField.text ?? ""
        fbdata.userName = nameField.text ?? ""
        FeedbackManManager.APIConstants.channel = channelNameField.text ?? ""
        fbdata.description = description
        fbdata.image = screenshotImageView.image
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.view.endEditing(true)
        indicator.startAnimating()
        
        presenter.postFeedbackData(fbdata) { result in
            UIApplication.shared.endIgnoringInteractionEvents()
            DispatchQueue.main.async {
            self.indicator.stopAnimating()
                switch result {
                case .success:
                    self.showSuccessAlert()
                case .failure:
                    self.showFailureAlert()
                }
            }
        }
    }
    
    func showSuccessAlert() {
        let alert = UIAlertController(title: "Succeeded", message: "Your feedback data has sent successfully!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            self.dismissModal()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showFailureAlert() {
        let alert = UIAlertController(title: "Failed", message: "Please retry or check your code.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func dismissModal() {
        self.dismiss(animated: true, completion: nil)
        FeedbackManManager.sharedInstance.debugBtn.isHidden = false
    }
    
    @IBAction func endEditingTextField(_ sender: UITextField) {
        // No other implements
    }
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        activeTextView = textView
        if feedbackTextView.textColor == UIColor.lightGray {
            feedbackTextView.text = ""
            feedbackTextView.textColor = UIColor.black
        }
        return true
    }
    
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        activeTextView = UITextView()
        scrollView.contentOffset.y = 0
        if feedbackTextView.text == "" {
            feedbackTextView.textColor = UIColor.lightGray
            feedbackTextView.text = "Write description here"
        }
        return true
    }
    
    func handleKeyboardWillShowNotification(_ notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let myBoundSize: CGSize = UIScreen.main.bounds.size
        
        let txtLimit = activeTextView.frame.origin.y + activeTextView.frame.height + 20.0
        let kbdLimit = myBoundSize.height - keyboardScreenEndFrame.size.height
        
        if txtLimit >= kbdLimit, activeTextView == feedbackTextView {
            scrollView.contentOffset.y = txtLimit - kbdLimit
        }
    }
    
    func handleKeyboardWillHideNotification(_ notification: Notification) {
        scrollView.contentOffset.y = 0
    }
    
    func doneBtnTapped() {
        self.view.endEditing(true)
    }
}
