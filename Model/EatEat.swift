import Foundation

class Restaurant{
    var name:String
    var type:String
    var location:String
    var image:String
    var isCheckedIn:Bool
    var phone:String
    var opentime:String
    var latitude:Double //經度
    var longitude:Double //緯度
    
    init(name:String,type:String,location:String,image:String,isCheckedIn:Bool,phone:String,opentime:String,latitude:Double,longitude:Double){
        self.name = name
        self.type = type
        self.location = location
        self.image = image
        self.isCheckedIn = isCheckedIn
        self.phone = phone
        self.opentime = opentime
        self.latitude = latitude
        self.longitude = longitude
    }
    
    convenience init(){
        self.init(name:"",type:"",location:"",image:"",isCheckedIn:false,phone:"",opentime:"",latitude:0.0,longitude:0.0)
    }
}
