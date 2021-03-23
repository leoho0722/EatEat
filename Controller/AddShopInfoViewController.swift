import UIKit

class AddShopInfoViewController: UIViewController {
    
    @IBOutlet var shopName:UITextField!
    @IBOutlet var shopType:UITextField!
    @IBOutlet var shopLocation:UITextField!
    @IBOutlet var shopPhone:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //啟用導覽列大標題
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    @IBAction func saveInfoBtn(_ sender: Any) {
        let controller = UIAlertController(title: "新增店家資訊", message: "新增成功！", preferredStyle: .alert)
        
        let closeAction = UIAlertAction(title: "關閉", style: .default, handler: {(action:UIAlertAction!) -> Void in
        
        })
        
        controller.addAction(closeAction)
        
        self.present(controller,animated: true,completion: nil)
    }
    
}
