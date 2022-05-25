//
//  CoreDataManager.swift
//  eventsMonitor
//
//  Created by vspl on 13/05/22.
//

import Foundation
//1.
import CoreData
import UIKit
@available(iOS 10.0, *)
public class CoreDataManager : NSObject {
    //2.
    public static let shared = CoreDataManager()
//3.
   let identifier: String  = "org.cocoapods.UXAnalysis"       //Your framework bundle ID
    let model: String       = "UXAModel"                      //Model name
    var time:DispatchTime! {
        return DispatchTime.now() + 10.0 // seconds
       }

    // 4.
    lazy var persistentContainer: NSPersistentContainer = {
            //5
            let messageKitBundle = Bundle(identifier: self.identifier)
            let modelURL = messageKitBundle!.url(forResource: self.model, withExtension: "momd")!
            let managedObjectModel =  NSManagedObjectModel(contentsOf: modelURL)
            
    // 6.
            let container = NSPersistentContainer(name: self.model, managedObjectModel: managedObjectModel!)
            container.loadPersistentStores { (storeDescription, error) in
                if let err = error{
                    fatalError("❌ Loading of store failed:\(err)")
                }
            }
            
            return container
        }()
    
    func saveEvent(eventType: String, touchX: Float, touchY: Float, latitude: Double, longitude: Double, screenName: String, screenSizeX: Int, screenSizeY: Int, sessionID: Int, uniqueID: String, userToken: String)  {
        
        
        let context = persistentContainer.viewContext
        let event = NSEntityDescription.insertNewObject(forEntityName: "Event", into: context) as! Event
        
        event.eventType = eventType
        event.touchX  = touchX
        event.touchY = touchY
        event.latitude = latitude
        event.longitude = longitude
        event.screenName = screenName
        event.screenSizeX = Int32(screenSizeX)
        event.screenSizeY = Int32(screenSizeY)
        event.sessionID = Int32(sessionID)
        event.uniqueID = uniqueID
        event.userToken = userToken
        
        
        do {
            try context.save()
            print("✅ Event saved succesfuly")
            
        } catch let error {
            print("❌ Failed to create Event: \(error.localizedDescription)")
        }
        
    }
    
    func deleteAllData(entity: String){
        
        let managedContext =  persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false

        do {
            let arrUsrObj = try managedContext.fetch(fetchRequest)
            for usrObj in arrUsrObj as! [NSManagedObject] {
                managedContext.delete(usrObj)
            }
           try managedContext.save() //don't forget
            } catch let error as NSError {
            print("delete fail--",error)
          }

    }
    
    public func fetch(){
            
            let context = persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<Event>(entityName: "Event")
            
            do{
                
                let events = try context.fetch(fetchRequest)
                
                for (index,event) in events.enumerated() {
                    print("Event \(index): \(event.screenName ?? "N/A") touchY: \(event.touchX) touchX: \(event.touchY)")
                }
                
            }catch let fetchErr {
                print("❌ Failed to fetch Person:",fetchErr)
            }
        }
    
    
    
    let url = URL(string: "http://uxveu.azurewebsites.net/v1/api/ScreenDataDump")!
  
    func sendToServer() {
//        var dic : NSDictionary = [ "screenData" :
//            [
//                ["touchX" : 22,"touchY" : 33,"screenSizeX" : 250,"screenSizeY" : 500,"screenName" : "sample string 6","latitude" : 7.1,"longitude" : 8.1],
//                ["touchX" : 2.1,"touchY" : 3.1,"screenSizeX" : 250,"screenSizeY" : 500,"screenName" : "sample string 6","latitude" : 7.1,"longitude" : 8.1],
//            ]
//        ]
        
        // This is the code for Swift 2.x. In Swift 3.x this call is a bit different.
       
        let mySessionID = "com.example.bgSession"
        
        let bgSessionConfig = URLSessionConfiguration.background(withIdentifier: mySessionID)
        
//        let session = URLSession(configuration: bgSessionConfig)
        let session = URLSession(configuration: bgSessionConfig, delegate: self, delegateQueue: OperationQueue())
        BackgroundTask.run(application: UIApplication.shared) { backgroundTask in
           // Do something
            
            let context = persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<Event>(entityName: "Event")
            
            do{
                let events = try context.fetch(fetchRequest)
                var touchArray = [NSDictionary]()
                for (index,event) in events.enumerated() {
                    print("Event log \(index): \(event.screenName ?? "N/A") touchY: \(event.touchX) touchX: \(event.touchY)")
                    let touchEvent: NSMutableDictionary = [:]
                    touchEvent["touchX"] = calculatePercentage(value: Double(event.screenSizeX), percentageVal: Double(event.touchX))
                    touchEvent["touchY"] =  calculatePercentage(value: Double(event.screenSizeY), percentageVal: Double(event.touchY))
                    touchEvent["screenSizeX"] = event.screenSizeX
                    touchEvent["screenSizeY"] = event.screenSizeY
                    touchEvent["screenName"] = event.screenName
                    touchEvent["latitude"] = Double("12.9716")
                    touchEvent["longitude"] = Double("77.5946")
                    touchEvent["uniqueId"] = "Robin"
                    touchArray.append(touchEvent)
                }
                
                let inputDict = ["screenData": touchArray]
                let jsonData = try? JSONSerialization.data(withJSONObject: inputDict, options: [])
                let jsonString = String(data: jsonData!, encoding: .utf8)
                print(jsonString!)
                        
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
                guard let httpBody = try? JSONSerialization.data(withJSONObject: inputDict, options: []) else {
                    return
                }
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = httpBody

                let task = session.dataTask(with: request)
                task.resume()
                
              // Open the operations queue after 1 second
              DispatchQueue.main.asyncAfter(deadline: self.time, execute: {[weak self] in
                  print("Opening the OperationQueue")
                  self!.deleteAllData(entity: "Event")
              })
            }catch let fetchErr {
                print("❌ Failed to fetch Person:",fetchErr)
            }
            
            
           backgroundTask.end()
        }
    }
        
    //Calucate percentage based on given values
    public func calculatePercentage(value:Double,percentageVal:Double)->Double{
        let val = value * percentageVal
        return val / 100.0
    }

}



@available(iOS 10.0, *)
extension CoreDataManager:URLSessionDelegate {
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("didReceive challenge")
    }
    
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print("invalid")
    }

//    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        // We've got a URLAuthenticationChallenge - we simply trust the HTTPS server and we proceed
//        print("didReceive challenge")
//        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
//    }
//
//    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
//        // We've got an error
//        if let err = error {
//            print("Error: \(err.localizedDescription)")
//        } else {
//            print("Error. Giving up")
//        }
////        PlaygroundPage.current.finishExecution()
//    }
}
