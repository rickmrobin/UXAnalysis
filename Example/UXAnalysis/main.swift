//  main.swift
//  EventsMonitoring
//
//  Created by vspl on 05/05/22.
//

import Foundation
import UIKit


UIApplicationMain( CommandLine.argc,  UnsafeMutableRawPointer(CommandLine.unsafeArgv)
    .bindMemory(
        to: UnsafeMutablePointer<Int8>.self,
        capacity: Int(CommandLine.argc)), NSStringFromClass(AnUIApplication.self), NSStringFromClass(AppDelegate.self))
