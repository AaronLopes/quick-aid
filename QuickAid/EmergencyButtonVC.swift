//
//  EmergencyButtonVC.swift
//  QuickAid
//
//  Created by Aaron Lopes on 12/4/17.
//  Copyright © 2017 Aaron Lopes. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import UserNotifications
import CoreLocation

class EmergencyButtonVC: UIViewController, CLLocationManagerDelegate {
    
     let manager = CLLocationManager()
     
    
     var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    
    @IBOutlet weak var breath: UISwitch!
    @IBOutlet weak var allergy: UISwitch!
    @IBOutlet weak var epiPen: UISwitch!
    @IBOutlet weak var inhaler: UISwitch!
    
    @IBOutlet weak var mapView: MKMapView!
    

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region, animated: true)
        
   
        
        self.mapView.showsUserLocation = true
    }
    
    @IBAction func helpButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "Help is on the way!", message: "People in your area have been notified. You will be told when somebody responds. Remeber to also call 911, this is a backup measure.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("def")
            default:
                print("def");
            }
        }))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func notifyTapped(_ sender: Any) {
        scheduleNotifications(inSeconds: 5, completion:  { success in
            if success {
                 print("Success!")
            } else {
                print("error")
            }
            
            
        })
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        // Resquest Notifcation Permission
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {
            (granted, error) in
            
            if granted {
                print("Notification Access granted")
            } else{
                print(error?.localizedDescription)
            }
        })
    
    
    }
    
    func scheduleNotifications(inSeconds: TimeInterval, completion: @escaping (_ Success: Bool) -> ()) {
        
        let notif = UNMutableNotificationContent()
        
        notif.title = "Assistance Needed"
        notif.body = "Somebody nearby needs your help!"
        
        let notifTrigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats:
            false)
        
        let request = UNNotificationRequest(identifier: "QuickAidNotification", content: notif, trigger: notifTrigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil {
                print(error)
                completion(false)
            } else {
                completion(true)
            }
            
        })
        
    }
 
}
