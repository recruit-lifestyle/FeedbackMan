import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func showAlert(_ sender: Any) {
        let alert: UIAlertController = UIAlertController(title: "Alert", message: "For screenshot test", preferredStyle: .alert)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showActionSheet(_ sender: Any) {
        let actionSheet: UIAlertController = UIAlertController(title: "Action Sheet", message: "For screenshot test", preferredStyle: .actionSheet)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(defaultAction)
        present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func presentToNext(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Next", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "next") as! NextViewController
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

