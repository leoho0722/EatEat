import UIKit

class RestaurantTableViewCell: UITableViewCell {
    @IBOutlet var RestaurantName: UILabel!
    @IBOutlet var RestaurantLocation: UILabel!
    @IBOutlet var RestaurantType: UILabel!
    @IBOutlet var RestaurantImageView: UIImageView!{
        didSet {
            //修改圓角半徑
            RestaurantImageView.layer.cornerRadius = RestaurantImageView.bounds.width / 2
            RestaurantImageView.clipsToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
                
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
