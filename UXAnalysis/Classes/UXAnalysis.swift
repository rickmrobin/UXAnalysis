//
//  EventsMonitor.swift
//  eventsMonitor
//
//  Created by vspl on 12/05/22.
//

import Foundation
import CoreData
import CoreLocation

public class UXAnalysis {
    
    
    private var observer: NSObjectProtocol?
    public static var shared = UXAnalysis()
    var latidue: Double!
    // User application instance everywhere where needed in your lib.
      private var application: UIApplication?
      
      public func setup(_ app: UIApplication) {
         application = app
          let sessionID = UserDefaults.standard.value(forKey: "sessionID") as? Int ?? 0
          UserDefaults.standard.set(sessionID+1, forKey: "sessionID")
          print("sessionID", sessionID)
      }
    
    init() {
        print("init called")
        LocationRequest.shared.startLocationUpdate()
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.UIApplicationWillResignActive,
            object: nil,
            queue: .main
        ) { (notification: Notification) in
                // Came from the background
                print("app moved to background")
                //make your API call here
            if #available(iOS 10.0, *) {
                CoreDataManager.shared.sendToServer()
            }
        }
    }
    
    
    func setLocation(latitude: Double, longitude: Double) {
        
    }
    
    func getScreenName() -> String {
        let viewController = UIApplication.shared.keyWindow!.rootViewController
        let viewControllerName =  NSStringFromClass(viewController!.classForCoder)
        let strArray = viewControllerName.split(separator: ".")
        let screenName = strArray[strArray.count-1]
        print("currentViewController",screenName)
        
        return String(screenName);
    }
    
    public func sendAction(_ action: Selector, to target: Any?, from sender: Any?, for event: UIEvent?) {
       print("FILE= \(NSStringFromSelector(action)) METHOD=\(String(describing: target!)) SENDER=\(String(describing: sender))")
       let actionString =  NSStringFromSelector(action)
       print("actionString", actionString)
        if let view = sender as? UIView {
            let  coordinates = view.frame.origin
            print("senderX",coordinates.x)
            print("senderY",coordinates.y)
            let latidue = UserDefaults.standard.value(forKey: "EventLatitude") as? Double ?? 0.00
            let longitude = UserDefaults.standard.value(forKey: "EventLongitude") as? Double ?? 0.00
            print("eventLatitude",latidue)
            print("eventLongitude", longitude)
        
        }
   }
    
    public func sendEvent(_ event: UIEvent)  {
        print("eventDetails",event.description)
        let latidue = UserDefaults.standard.value(forKey: "EventLatitude") as? Double ?? 0.00
        let longitude = UserDefaults.standard.value(forKey: "EventLongitude") as? Double ?? 0.00
        if let touch = event.allTouches?.first {
            let position = touch.location(in: UIApplication.shared.keyWindow!.rootViewController?.view)
               print(position.x)
               print(position.y)
                if #available(iOS 10.0, *) {
                    CoreDataManager.shared.saveEvent(eventType: "All", touchX: Float(position.x), touchY: Float(position.y), latitude: latidue, longitude: longitude, screenName: getScreenName(), screenSizeX: Int(UIScreen.main.bounds.width), screenSizeY: Int(UIScreen.main.bounds.height), sessionID: getSessionID(), uniqueID: "Robin", userToken: "token")
                }
           }
    }
    
    public func getSessionID() -> Int {
        let sessionID:Int =  UserDefaults.standard.value(forKey: "sessionID") as? Int ?? 0
        return sessionID;
    }
  
}
