//
//  ViewController.swift
//  werkstuk2Ios
//
//  Created by Admin on 5/06/17.
//  Copyright © 2017 Geordy. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        self.makeGetCall()
        self.addToMap()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
    }

    func makeGetCall() {
        
        let url = URL(string: "https://opendata.brussel.be/api/records/1.0/search/?dataset=opmerkelijke-bomen&rows=15")
        
        let urlRequest = URLRequest(url: url!)
        
        
        // set up the session
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            
            // check for any errors
            guard error == nil else {
                print("error calling GET")
                print(error!)
                return
            }
            
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            dump(data)
            // parse the result
           
            do {
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                
                guard let json = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? NSDictionary else {
                    print("error trying to convert data to JSON")
                    return
                }
                
                
                
            
                //init belangrijkebomen
                let opmerkelijkeBomen = NSEntityDescription.insertNewObject(forEntityName: "OpmerkelijkeBomen", into: context) as! OpmerkelijkeBomen
                
                
                opmerkelijkeBomen.nhits = json.value(forKey: "nhits") as! int_fast16_t
                
                //init parameters
                let parameter = NSEntityDescription.insertNewObject(forEntityName: "Parameter", into: context) as! Parameter
                
                let parameterjson = json.value(forKey: "parameters") as! [String: Any]
                
                //parameters aanvullen
                parameter.timezone = parameterjson["timezone"] as? String
                parameter.rows = parameterjson["rows"] as! Int16
                parameter.format = parameterjson["format"] as? String
                
                //toevoeging parameters
                opmerkelijkeBomen.parameters = parameter
                
                
                //init records
                let records = json.value(forKey: "records") as! [[String : Any]]
                
                
                let recordSet = NSSet()
                
                
                //records aanvullen
                for recordjson in records{
                    let record = NSEntityDescription.insertNewObject(forEntityName: "Record", into: context) as! Record
                    
                    record.datasetid = recordjson["datasetid"] as? String
                    record.recordid = recordjson["recordid"] as? String
                    record.record_timestamp = recordjson["record_timestamp"] as? String
                    
                    
                    let fieldsjson = recordjson["fields"] as! [String: Any]
                    
                    let field = NSEntityDescription.insertNewObject(forEntityName: "Field", into: context) as! Field
                    
                    if fieldsjson["status"] != nil
                    {
                        field.status = fieldsjson["status"] as? String
                    }
                   
                    if fieldsjson["omtrek"] != nil
                    {
                        field.omtrek = fieldsjson["omtrek"] as! Int16
                    }
                    
                    
                    if fieldsjson["straat"] != nil
                    {
                        field.straat = fieldsjson["straat"] as? String
                    }
                    
                    if fieldsjson["beplanting"] != nil
                    {
                        field.beplanting = fieldsjson["beplanting"] as? String
                    }
                    
                    
                    if fieldsjson["diameter_van_de_kroon"] != nil
                    {
                        field.diameter_van_de_kroon = fieldsjson["diameter_van_de_kroon"] as! Int16
                    }
                    
                    
                    if fieldsjson["soort"] != nil
                    {
                        field.soort = fieldsjson["soort"] as? String
                    }
                    
                    
                    if fieldsjson["positie"] != nil
                    {
                        field.positie = fieldsjson["positie"] as? String
                    }
                    
                    if fieldsjson["id"] != nil
                    {
                        field.id = fieldsjson["id"] as! Int16
                    }
                    
                    
                    if fieldsjson["gemeente"] != nil
                    {
                        field.gemeente = fieldsjson["gemeente"] as? String
                    }
                    
                   
                    if fieldsjson["landschap"] != nil
                    {
                        field.landschap = fieldsjson["landschap"] as? String
                    }
                    
                
                    
                    record.fielden = field
                    
                    recordSet.adding(record)
                }
                
                opmerkelijkeBomen.records = recordSet
                
                
            } catch  {
                print("error trying to convert data to JSON")
                return
            }

            
            

            
           
            
            
            
            
            
            
        }
        
        task.resume()
    }
    
    func addToMap() {
        do
        {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var recordsOpmerkelijkeBomen = [Record]()
        
        let recordFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Record")
        recordsOpmerkelijkeBomen = try context.fetch(recordFetch) as! [Record]
        
        for record in recordsOpmerkelijkeBomen
        {
            let field = record.fielden
            let location = "\(field?.straat), \(field?.gemeente), Belgie"
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(location)
            { [weak self] placemarks, error in
            if let placemark = placemarks?.first, let location = placemark.location
            {
                
                
                let mark = MKPlacemark(placemark: placemark)
                //mark.title = field?.soort
                
                if var region = self?.mapView.region {
                    region.center = location.coordinate
                    region.span.longitudeDelta /= 8.0
                    region.span.latitudeDelta /= 8.0
                    //self?.mapView.setRegion(region, animated: true)
                    self?.mapView.addAnnotation(mark)
                }
            }

            
        }
        
                } 
        } catch let error as NSError
        {
            print("could not fetch \(error)")
        }
        
        
        
    }
   
    
    


}

