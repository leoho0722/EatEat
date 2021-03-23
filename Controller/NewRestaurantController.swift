import UIKit
import CoreData
import IQKeyboardManagerSwift

class NewRestaurantController: UITableViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NSFetchedResultsControllerDelegate {
    
    var restaurants: [RestaurantMO] = []
    var restaurant:RestaurantMO!
    var fetchResultController: NSFetchedResultsController<RestaurantMO>!
    
    @IBOutlet var shopImageView:UIImageView!
    @IBOutlet var nameTextField:UITextField!{
        didSet{
            nameTextField.tag = 1
            nameTextField.becomeFirstResponder()
            nameTextField.delegate = self as UITextFieldDelegate
        }
    }
    @IBOutlet var phoneTextField:UITextField!{
        didSet{
            phoneTextField.tag = 2
            phoneTextField.delegate = self as UITextFieldDelegate
        }
    }
    @IBOutlet var addressTextField:UITextField!{
        didSet{
            addressTextField.tag = 3
            addressTextField.delegate = self as UITextFieldDelegate
        }
    }
    @IBOutlet var typeTextField:UITextField!{
        didSet{
            typeTextField.tag = 4
            typeTextField.delegate = self as UITextFieldDelegate
        }
    }
    
    //透過 Return 鍵移到下一個欄位
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1){
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        return true
    }
    
    // MARK: - 程式一載入時會執行的
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none //移除表格中的分隔線
    }
    
    // MARK: - 透過相機/照片圖庫新增店家圖片的部分
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let photoSourceRequestController = UIAlertController(title: "", message: "選擇照片來源", preferredStyle: .actionSheet)
            
            //相機按鈕
            let cameraAction = UIAlertAction(title: "相機", style: .default, handler: {(action) in
                
                if UIImagePickerController.isSourceTypeAvailable(.camera){
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .camera
                    imagePicker.delegate = self
                    
                    self.present(imagePicker,animated: true,completion: nil)
                }
            })
            
            //照片圖庫按鈕
            let photoLibraryAction = UIAlertAction(title: "照片圖庫", style: .default, handler: {(action) in
                
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.delegate = self
                    
                    self.present(imagePicker,animated: true,completion: nil)
                }
            })
            
            photoSourceRequestController.addAction(cameraAction)
            photoSourceRequestController.addAction(photoLibraryAction)
            
            //針對 iPad 顯示的部分
            if let popoverController = photoSourceRequestController.popoverPresentationController{
                if let cell = tableView.cellForRow(at: indexPath){
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            present(photoSourceRequestController,animated: true,completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            shopImageView.image = selectedImage.fixOrientation()
            shopImageView.contentMode = .scaleAspectFill
            shopImageView.clipsToBounds = true
        }
        dismiss(animated: true, completion:nil)
    }
    
    //儲存店家資訊
    @IBAction func saveInfoBtn(_ sender: Any) {
        let saveAlert = UIAlertController(title: "編輯店家資訊", message: "按下送出前，請再次確認資料是否正確！", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "送出", style: .default) { (okAction) in
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
                self.restaurant = RestaurantMO(context: appDelegate.persistentContainer.viewContext)
                self.restaurant.name = self.nameTextField.text
                self.restaurant.type = self.typeTextField.text
                self.restaurant.location = self.addressTextField.text
                self.restaurant.phone = self.phoneTextField.text
                self.restaurant.isCheckedIn = false
                
                if let restaurantImage = self.shopImageView.image{
                    self.restaurant.image = restaurantImage.pngData()
                    //restaurant.image = restaurantImage.jpegData(compressionQuality: 1) //compressionQuality 是壓縮品質
                }
                appDelegate.saveContext()
            }
            let alert = UIAlertController(title: "", message: "儲存成功！", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "關閉", style: .default) { (okAction) in
                self.dismiss(animated: true)
            }
            alert.addAction(okAction)
            self.present(alert,animated: true)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        saveAlert.addAction(saveAction)
        saveAlert.addAction(cancelAction)
        self.present(saveAlert,animated: true)
    }
    
    
}

    // MARK: - 解決在新增店家資訊時用相機拍照後照片被轉向的部分

extension UIImage {
    func fixOrientation() -> UIImage
    {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        
        var transform = CGAffineTransform.identity
        
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi));
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0);
            transform = transform.rotated(by: CGFloat(Double.pi / 2));
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height);
            transform = transform.rotated(by: CGFloat(-Double.pi / 2));
        case .up, .upMirrored:
            break
        }
        
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1);
        default:
            break;
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx = CGContext(
            data: nil,
            width: Int(self.size.width),
            height: Int(self.size.height),
            bitsPerComponent: self.cgImage!.bitsPerComponent,
            bytesPerRow: 0,
            space: self.cgImage!.colorSpace!,
            bitmapInfo: UInt32(self.cgImage!.bitmapInfo.rawValue)
        )
        
        ctx!.concatenate(transform);
        
        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            // Grr...
            ctx?.draw(self.cgImage!, in: CGRect(x:0 ,y: 0 ,width: self.size.height ,height:self.size.width))
        default:
            ctx?.draw(self.cgImage!, in: CGRect(x:0 ,y: 0 ,width: self.size.width ,height:self.size.height))
            break;
        }
        
        // And now we just create a new UIImage from the drawing context
        let cgimg = ctx!.makeImage()
        let img = UIImage(cgImage: cgimg!)
        
        return img;
    }
}

//出處：https://medium.com/彼得潘的-swift-ios-app-開發教室/手機拍照後-image旋轉問題-6437129adc24
