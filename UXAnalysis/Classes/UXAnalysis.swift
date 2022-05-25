//
//  EventsMonitor.swift
//  eventsMonitor
//
//  Created by vspl on 12/05/22.
//

import Foundation
import CoreData
import CoreLocation

@available(iOS 13.0, *)
public class UXAnalysis {
    
    
    private var observer: NSObjectProtocol?
    public static var shared = UXAnalysis()
    var latidue: Double!
    // User application instance everywhere where needed in your lib.
      private var application: UIApplication?
      
      public func setup(_ app: UIApplication) {
         application = app
      }
    
    init() {
        print("init called")
        LocationRequest.shared.startLocationUpdate()
        
        let token = NotificationCenter.default.addObserver(
            forName: NSNotification.Name.UIApplicationWillResignActive,
            object: nil,
            queue: .main
        ) { (notification: Notification) in
                // Came from the background
                print("app moved to background")
                //make your API call here
            
        }
    }
    
    
    func setLocation(latitude: Double, longitude: Double) {
        
    }
    
    
    
    public func sendAction(_ action: Selector, to target: Any?, from sender: Any?, for event: UIEvent?) {
    
       
       print("FILE= \(NSStringFromSelector(action)) METHOD=\(String(describing: target!)) SENDER=\(String(describing: sender))")
       
       let actionString =  NSStringFromSelector(action)
       print("actionString", actionString)
        let viewController = UIApplication.shared.keyWindow!.rootViewController
        let viewControllerName =  NSStringFromClass(viewController!.classForCoder)
       
        let strArray = viewControllerName.split(separator: ".")
        
        let screenName = strArray[1]
        print("currentViewController",screenName)
       
        if let view = sender as? UIView {
         
            let  coordinates = view.frame.origin
            print("senderX",coordinates.x)
            print("senderY",coordinates.y)
            print("senderName",view.largeContentTitle!)
            let latidue = UserDefaults.standard.value(forKey: "EventLatitude") as? Double ?? 0.00
            let longitude = UserDefaults.standard.value(forKey: "EventLongitude") as? Double ?? 0.00
            print("eventLatitude",latidue)
            print("eventLongitude", longitude)
        
        }
 
   }
    
    public func sendEvent(_ event: UIEvent)  {
        print("eventDetails",event.description)
        
        if let touch = event.allTouches?.first {
            let position = touch.location(in: UIApplication.shared.keyWindow!.rootViewController?.view)
               print(position.x)
               print(position.y)
//            CoreDataManager.shared.saveEvent()
           }
       
    }
  
}
