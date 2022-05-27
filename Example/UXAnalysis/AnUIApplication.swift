//
//  AnUIApplication.swift
//  EventsMonitoring
//
//  Created by vspl on 05/05/22.
//

import Foundation
import UIKit
import UXAnalysis

class AnUIApplication : UIApplication {
    
    override init() {
        
    }
    
//    override func sendAction(_ action: Selector, to target: Any?, from sender: Any?, for event: UIEvent?) -> Bool {
//        UXAnalysis.shared.sendAction(action, to: target, from: sender, for: event)
//        return super.sendAction(action, to: target, from: sender, for: event)
//    }
    
    override func sendEvent(_ event: UIEvent) {
        UXAnalysis.shared.sendEvent(event)
    }
}

@available(iOS 13.0, *)
extension UIApplication {
    
    var keyWindow: UIWindow? {
        // Get connected scenes
        return UIApplication.shared.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
            // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }
    
}
