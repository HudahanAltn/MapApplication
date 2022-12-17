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
   
    var annotationTitle:String?
    var annotationSubTitle:String?
    var annotationLat:Double?
    var annotationLong:Double?
    
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
                
                let AppDelegatee = UIApplication.shared.delegate as! AppDelegate //core data
                let contextt = AppDelegatee.persistentContainer.viewContext // coredata access
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Place")
                fetchRequest.predicate = NSPredicate(format: "id = %@", uuid)
                fetchRequest.returnsObjectsAsFaults = false
                
                do{
                    
                    let results = try contextt.fetch(fetchRequest)
                    
                    if results.count > 0 {
                        
                        for i in results as! [NSManagedObject]{
                            
                            if let name = i.value(forKey: "name") as? String, let note = i.value(forKey: "note") as? String,let lati = i.value(forKey: "latitude") as? Double, let longi = i.value(forKey: "longitude") as? Double {
                                
                                annotationTitle = name
                                annotationSubTitle = note
                                annotationLat = lati
                                annotationLong = longi
                                
                                let annotation = MKPointAnnotation() //create annotation
                                //pass data to annonation
                                annotation.title = annotationTitle
                                annotation.subtitle = annotationSubTitle
                                
                                //create coordianae a pass param from coredata to class
                                let coordinate = CLLocationCoordinate2D(latitude: annotationLat!, longitude: annotationLong!)
                                
                                annotation.coordinate = coordinate // set coordinate
                                mapView.addAnnotation(annotation)// add
                                
                                //add tf
                                titleTextField.text = annotationTitle
                                noteTextField.text = annotationSubTitle
                                
                                locationManager.stopUpdatingLocation()//user want to see added location on map . Mapview have to stop your current location because map view show us current locaiton not added place location
                                
                                
                                //added place location span and region
                                let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) // create span
                                
                                let region = MKCoordinateRegion(center: coordinate, span: span) // create region
                                
                                mapView.setRegion(region, animated: true) // set region
                                
                            }
                            
                          
                        }
                        
                    }
                    
                }catch{
                    
                    print("Error")
                }
                
                
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
            
            //if new place created . we broadcasting .
            NotificationCenter.default.post(name: NSNotification.Name("newPlaceCreated"), object: nil)
            navigationController?.popViewController(animated: true)//return listVC
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
        
        if choosenPlaceName == ""{ // user choose add to newplace
            
            // we will get user location
            let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude) // get locaiton
            
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) // create span
            
            let region = MKCoordinateRegion(center: myLocation, span: span) // create region
            
            mapView.setRegion(region, animated: true) // set region
            
            
            print("latitude: \(locations[0].coordinate.latitude)")
            print("longitutde: \(locations[0].coordinate.longitude)")
        }
        
    }
    
    
}

