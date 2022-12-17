//
//  ViewController.swift
//  MapApplication
//
//  Created by Hüdahan Altun on 17.12.2022.
//


import UIKit
import MapKit
import CoreLocation
import CoreData



class MapsViewController: UIViewController {
    
    var locationManager = CLLocationManager()//created to get location
    
    var choosenLatitude:Double?
    var choosenLongitude:Double?
    
    var choosenPlaceName:String?
    var choosenPlaceID:UUID?
   
    
    @IBOutlet weak var titleTextField: UITextField!
    
    
    @IBOutlet weak var noteTextField: UITextField!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //get best location
        locationManager.requestWhenInUseAuthorization() // ask to permisson from user
        locationManager.startUpdatingLocation()
        
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        
        if choosenPlaceName != ""{
            
            //fetch data from coredata
            if let uuid = choosenPlaceID?.uuidString{
                
                print("uuid:\(uuid)")
            }
            
        }else{
            
            //add new place
            
        }
        
        gestureRecognizer.minimumPressDuration = 3 // you need to tap 3 second to get location
        
        mapView.addGestureRecognizer(gestureRecognizer) // add gestureRec to mapview
    }


    
    @IBAction func saveLocationPressed(_ sender: Any) {
        
        let AppDelegatee = UIApplication.shared.delegate as! AppDelegate //core data
        let contextt = AppDelegatee.persistentContainer.viewContext // coredata access
        
        let newPlace = NSEntityDescription.insertNewObject(forEntityName: "Place", into: contextt)
        
        newPlace.setValue(titleTextField.text, forKey: "name")
        newPlace.setValue(noteTextField.text, forKey: "note")
        newPlace.setValue(choosenLatitude,forKey: "latitude")
        newPlace.setValue(choosenLongitude, forKey: "longitude")
        newPlace.setValue(UUID(), forKey: "id")
        
        do{
            
            try contextt.save()
            print("save succesfully")
        }catch{
            
            print("save not successfully")
        }
    }
    

}


extension MapsViewController:MKMapViewDelegate{
    
    @objc func chooseLocation(gestureRecognizer:UILongPressGestureRecognizer){
        
        if gestureRecognizer.state == .began{ //when gestureRec began
            
           
            let touchedPoint = gestureRecognizer.location(in: mapView) // get point when you touch mapview
            
            let touchedCoord = mapView.convert(touchedPoint, toCoordinateFrom: mapView) //convert point to coordinate form
            
            
            choosenLatitude = touchedCoord.latitude
            choosenLongitude = touchedCoord.longitude
            let annonation = MKPointAnnotation() //create pin
            
            annonation.coordinate = touchedCoord // load coordinate
            //set titles
            annonation.title = titleTextField.text
            annonation.subtitle = noteTextField.text
            
            mapView.addAnnotation(annonation)// add annonation
            
        }
    }
    
}

extension MapsViewController:CLLocationManagerDelegate{
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude) // get locaiton
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) // create span
        
        let region = MKCoordinateRegion(center: myLocation, span: span) // create region
        
        mapView.setRegion(region, animated: true) // set region
        
        
        print("latitude: \(locations[0].coordinate.latitude)")
        print("longitutde: \(locations[0].coordinate.longitude)")
        
    }
    
    
}

