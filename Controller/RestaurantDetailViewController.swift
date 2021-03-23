import UIKit

class RestaurantDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView:RestaurantDetailHeaderView!
    
    var restaurant: RestaurantMO!
    
    // MARK: - 程式一載入時會執行的
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none //移除表格中的分隔線
        navigationItem.largeTitleDisplayMode = .never //取消大標題
        
        headerView.nameLabel.text = restaurant.name
        headerView.typeLabel.text = restaurant.type
        
        if let restaurantImage = restaurant.image {
            headerView.headerImageView.image = UIImage(data:restaurantImage as Data)
        }
    }
    
    // MARK: - UITableViewDataSource 協定
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailTextCell.self), for:indexPath) as! RestaurantDetailTextCell
            cell.infTextLabel.text = "電話：" + (restaurant.phone ?? "")
            cell.selectionStyle = .none
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailTextCell.self), for:indexPath) as! RestaurantDetailTextCell
            cell.infTextLabel.text = "地址：" + (restaurant.location ?? "")
            cell.selectionStyle = .none
            
            return cell
          
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantOpenTimeCell.self), for:indexPath) as! RestaurantOpenTimeCell
            cell.opentimeLabel.text = "營業時間：\n" + (restaurant.opentime ?? "")
              cell.selectionStyle = .none
              
              return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantMapCell.self), for:indexPath) as! RestaurantMapCell
            cell.configure(location: restaurant.location ?? "")
            cell.selectionStyle = .none
            
            return cell
            
        default:
            fatalError("Failed to instantiate the Table View Cell for Detail View Controller")
        }
    }
    
    // MARK: - 透過 Segue 傳遞資料
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap" {
            let destinationController = segue.destination as! MapViewController
            destinationController.restaurant = restaurant
        }
    }
}
