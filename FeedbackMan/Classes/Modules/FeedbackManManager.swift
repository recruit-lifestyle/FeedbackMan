import UIKit
import Foundation

public final class FeedbackManManager {
    
    public struct APIConstants {
        public static var token = ""
        public static var channel = ""
    }

    public static let sharedInstance : FeedbackManManager = {
        let instance = FeedbackManManager()
        return instance
    }()
    
    private init() {
        // Intentionally unimplemented
    }
    
    public lazy var debugBtn: UIButton = {
        let btnWidth: CGFloat = 100
        let deviceWidth = UIScreen.main.bounds.size.width
        let position = deviceWidth/2 - btnWidth/2
        let btn = UIButton(frame: CGRect(x: position, y: 50, width: btnWidth, height: 30))
        btn.layer.cornerRadius = 6
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.blue.cgColor
        btn.backgroundColor = .white
        btn.setTitle("Debug", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.addTarget(self, action: #selector(FeedbackManManager.sharedInstance.showModal), for: .touchUpInside)
        return btn
    }()
    
    public func showDebugBtn() {
        guard let window = UIApplication.shared.keyWindow else { return }
        
        if !debugBtn.isDescendant(of: window) {
            window.addSubview(debugBtn)
        }
    }
    
    @objc public func showModal(){
        guard let topVC = UIApplication.topViewController() else{
            return
        }
        FeedbackManManager.sharedInstance.debugBtn.isHidden = true
        let modalVC = ModalVC.instantiate()
        modalVC.modalPresentationStyle = .overFullScreen
        topVC.present(modalVC, animated: true, completion: nil)
    }
}
