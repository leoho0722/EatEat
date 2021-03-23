import UIKit
import IQKeyboardManagerSwift
import CoreData

class RestaurantTableViewController: UITableViewController,NSFetchedResultsControllerDelegate {
    
    @IBOutlet var editBtn:UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet var emptyRestaurantView:UIView!
    @IBOutlet var restaurantTableView: UITableView!
    
    var restaurants: [RestaurantMO] = []
    var fetchResultController: NSFetchedResultsController<RestaurantMO>!
    
    // MARK: - 程式一載入時會執行的
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //準備空視圖
        tableView.backgroundView = emptyRestaurantView
        tableView.backgroundView?.isHidden = true
        
        tableView.cellLayoutMarginsFollowReadableWidth = true //啟動自動調整 Cell 寬度
        navigationController?.navigationBar.prefersLargeTitles = false //啟用導覽列大標題
        
        readCoreData()
    }
    
    func readCoreData(){
        
        //從資料儲存區中讀取資料
        let fetchRequest:NSFetchRequest<RestaurantMO> = RestaurantMO.fetchRequest() //透過 fetchRequest 去建立讀取 RestaurantMO 的請求
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)] //用 name 作為由小到大排序資料的依據
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){ //取得 AppDelegate 的參照，才能使用 persistentContainer
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil) //初始化
            fetchResultController.delegate = self
            
            //例外處理
            do{
                try fetchResultController.performFetch() //執行資料庫查詢，並將查詢結果放到 restaurants 裡面
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    restaurants = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
    }
        
    // MARK: - NSFetchedResultsControllerDelegate 協定 (CoreData)
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject:Any, at indexPath:IndexPath?,for type:NSFetchedResultsChangeType,newIndexPath:IndexPath?){
        
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath{
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath{
            tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects{
            restaurants = fetchedObjects as! [RestaurantMO]
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // MARK: - UITableViewDataSource 協定

    override func numberOfSections(in tableView: UITableView) -> Int {
        if restaurants.count > 0 {
            tableView.backgroundView?.isHidden = true
            tableView.separatorStyle = .singleLine
        } else{
            tableView.backgroundView?.isHidden = false
            tableView.separatorStyle = .none
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "datacell", for: indexPath) as! RestaurantTableViewCell //重複使用 TableView Cell，提高執行效率
        
        cell.RestaurantName.text = restaurants[indexPath.row].name
        cell.RestaurantLocation.text = restaurants[indexPath.row].location
        cell.RestaurantType.text = restaurants[indexPath.row].type
        
        if let restaurantImage = restaurants[indexPath.row].image{
            cell.RestaurantImageView.image = UIImage(data: restaurantImage as Data)
        }
        return cell
    }

    //隱藏狀態列，預設 false
    override var prefersStatusBarHidden: Bool{
        return false
    }
    
    // MARK: - Cell 向左、向右滑動的動作
    
    //新增向左滑動時的動作
    override func tableView(_ tableView: UITableView,  trailingSwipeActionsConfigurationForRowAt indexPath:IndexPath) -> UISwipeActionsConfiguration?{
        
        //建立刪除按鈕
        let deleteAction = UIContextualAction(style: .destructive, title: "刪除"){(action,sourceView,completionHandler) in

            //從資料儲存區刪除一列
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
                let context = appDelegate.persistentContainer.viewContext
                let restaurantToDelete = self.fetchResultController.object(at: indexPath)
                context.delete(restaurantToDelete)
                appDelegate.saveContext()
            }
            completionHandler(true) //呼叫完成處理器來取消動作
        }
        
        //建立分享按鈕
        let shareAction = UIContextualAction(style: .normal, title: "分享"){(action,sourceView,completionHandler) in
            let defaultText = self.restaurants[indexPath.row].name!
            let activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
            
            //由於在 iPad 上提示控制器是儲存在 popoverPresentationController 屬性中的 UIPopoverPresentationController，所以透過 if let 來檢查 popoverPresentationController 是否有值
            if let popoverController = activityController.popoverPresentationController{
                if let cell = tableView.cellForRow(at: indexPath){
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            self.present(activityController,animated: true,completion:nil)
            completionHandler(true) //呼叫完成處理器來取消動作
        }
        shareAction.backgroundColor = UIColor(red: 243.0/255.0, green: 156.0/255.0, blue: 18.0/255.0, alpha: 1.0) //修改分享按鈕顏色
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction,shareAction])
        return swipeConfiguration
    }
    
    //新增向右滑動的動作
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //建立打卡按鈕
        let checkInActionTitle = (self.restaurants[indexPath.row].isCheckedIn) ? "取消打卡":"打卡"
        let checkInAction = UIContextualAction(style: .destructive, title: checkInActionTitle){(action,sourceView,completionHandler) in
            let cell = tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell
           
            self.restaurants[indexPath.row].isCheckedIn = (self.restaurants[indexPath.row].isCheckedIn) ? false:true
            
            cell.accessoryType = (self.restaurants[indexPath.row].isCheckedIn) ? .none:.checkmark
        }
        //建立編輯按鈕
        let editAction = UIContextualAction(style: .normal, title: "編輯"){(action,sourceView,completionHandler) in
            self.performSegue(withIdentifier: "addRestaurantInfo", sender: self)
        }
        editAction.backgroundColor = UIColor(red: 0.0/255.0, green: 127.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        let leadSwipeActionConfiguration = UISwipeActionsConfiguration(actions: [checkInAction,editAction])
        return leadSwipeActionConfiguration
    }
   
    // MARK: - 透過 Segue 傳遞資料 (顯示店家資訊)
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurantDetail"{
            if let indexPath = tableView.indexPathForSelectedRow{
                let destinationController = segue.destination as! RestaurantDetailViewController
                destinationController.restaurant = restaurants[indexPath.row]
            }
        }
    }
    
    // MARK: - 透過 Segue 傳遞資料 (新增店家資訊)
    
    @IBAction func toHome(segue:UIStoryboardSegue){
        dismiss(animated: true)
    }
   //
}

//iOS 13 的 StoryBoard 跳轉參考↓
//https://medium.com/彼得潘的-swift-ios-app-開發教室/簡易說明xcode中的顯示下一個畫面方法-由程式觸發的方式-5d0e49e4ae9a
//iOS 13 以前的 StoryBoard 跳轉參考↓
//https://codertw.com/ios/329830/
