//
//  ViewController.swift
//  werkstuk2Ios
//
//  Created by Admin on 5/06/17.
//  Copyright © 2017 Geordy. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.makeGetCall()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func makeGetCall() {
        
        let url = URL(string: "https://opendata.brussel.be/api/records/1.0/search/?dataset=opmerkelijke-bomen")
        
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
                    
                    field.status = fieldsjson["status"] as? String
                    field.omtrek = fieldsjson["omtrek"] as! Int16
                    field.straat = fieldsjson["straat"] as? String
                    field.beplanting = fieldsjson["beplanting"] as? String
                    field.diameter_van_de_kroon = fieldsjson["diameter_van_de_kroon"] as! Int16
                    field.soort = fieldsjson["soort"] as? String
                    field.positie = fieldsjson["positie"] as? String
                    field.id = fieldsjson["id"] as! Int16
                    field.gemeente = fieldsjson["gemeente"] as? String
                    
                    record.fielden = field
                    
                    recordSet.adding(record)
                }
                
                opmerkelijkeBomen.records = recordSet
                
                
            } catch  {
                print("error trying to convert data to JSON")
                return
            }

            
            

            
           
            //catch  {
               // print("error trying to convert data to JSON")
               // return
           // }
            
            
            
            
            
        }
        
        task.resume()
    }
    
    func toevoegenBoom(Boom: String)
    {
        
    }
    
    


}

