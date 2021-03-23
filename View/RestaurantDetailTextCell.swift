import UIKit

class RestaurantDetailTextCell: UITableViewCell {

    @IBOutlet var infTextLabel:UILabel!{
        didSet{
            infTextLabel.numberOfLines = 0 //讓文字可以多行顯示
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
