import UIKit
import MapKit
import CoreLocation //取得目前位置

class RestaurantMapCell: UITableViewCell {
    
    @IBOutlet var mapView:MKMapView!
    
    func configure(location: String){
        
        //取得位置
        let geoCoder = CLGeocoder()
        print(location)
        
        geoCoder.geocodeAddressString(location, completionHandler: { placemarks,error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let placemarks = placemarks{
                
                //取得第一個地點標記
                let placemark = placemarks[0]
                
                //加上標記
                let annotation = MKPointAnnotation()
                
                if let location = placemark.location{
                    
                    //顯示標記
                    annotation.coordinate = location.coordinate
                    self.mapView.addAnnotation(annotation)
                    
                    //設定縮放程度
                    let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 150, longitudinalMeters: 150)
                    self.mapView.setRegion(region, animated: false)
                }
            }
        })
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
