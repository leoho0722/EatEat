import UIKit

class UpdateShopInfoViewController: UIViewController {
    
    @IBOutlet var updateShopName:UITextField!
    @IBOutlet var updateShopType:UITextField!
    @IBOutlet var updateShopLocation:UITextField!
    @IBOutlet var updateShopPhone:UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        //啟用導覽列大標題
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @IBAction func updateShopInfoBtn(_ sender: Any) {
        let controller = UIAlertController(title: "更新店家資訊", message: "更新成功！", preferredStyle: .alert)
        
        let closeAction = UIAlertAction(title: "關閉", style: .default, handler: {(action:UIAlertAction!) -> Void in
            
        })
        
        controller.addAction(closeAction)
        
        self.present(controller,animated: true,completion: nil)
    }
    
}
