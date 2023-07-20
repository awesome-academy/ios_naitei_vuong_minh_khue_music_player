//
//  AppDelegate.swift
//  MusicApp
//
//  Created by Khue on 13/07/2023.
//

import UIKit
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            application.beginReceivingRemoteControlEvents()
            becomeFirstResponder()
        } catch {
          print(error)
        }
        return true
    }
}

