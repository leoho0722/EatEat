import UIKit
import MapKit
import CoreLocation //取得目前位置

class MapViewController: UIViewController {

    @IBOutlet var bigMapView:MKMapView!
    
    var restaurant:RestaurantMO!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocation()
    }
    
    func getLocation(){
        bigMapView.delegate = self as? MKMapViewDelegate
        bigMapView.showsCompass = true
        bigMapView.showsScale = true
        bigMapView.showsTraffic = true
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location!, completionHandler: {
            placemarks, error in
            if error != nil {
                print(error!)
                return
            }
            if let placemarks = placemarks {
                
                let placemark = placemarks[0] //取得第一個座標
                let annotation = MKPointAnnotation()
                annotation.title = self.restaurant.name //加上地圖標註
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    self.bigMapView.addAnnotation(annotation) //顯示標註(大頭針)
                    let region =
                        MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 150, longitudinalMeters: 150) //設定縮放程度
                    self.bigMapView.setRegion(region, animated: false)
                }
            }
        })
    }
    //
}


//https://medium.com/@cwlai.unipattern/app開發-使用swift-17-地圖-83fce8358c43
//https://medium.com/@cwlai.unipattern/app開發-使用swift-17-1-地圖標註-map-annotation-bffb1989426a
