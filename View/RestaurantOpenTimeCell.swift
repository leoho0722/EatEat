import UIKit

class RestaurantOpenTimeCell: UITableViewCell {
    
    @IBOutlet var opentimeLabel:UILabel!{
        didSet{
            opentimeLabel.numberOfLines = 0
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
