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
                //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                
                guard let json = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? NSDictionary else {
                    print("error trying to convert data to JSON")
                    return
                }
                
                let records : NSArray = json.value(forKey: "records") as! NSArray
                
                dump(records)
//                guard let recordsjson = json["records"] as? NSArray else
//                {
//                    print("Error: geen records aanwezig.")
//                    return
//                }
//            
//            
//                let opmerkelijkeBomen = OpmerkelijkeBomenMO(context: context)
//                
//                var records = NSSet()
//                for recordjson in recordsjson
//                {
//                    let record = RecordMO(context: context)
//                    record.datasetid = recordjson["datasetid"]
//                    
//                }
//                
            
                
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

