//
//  HomeController.swift
//  ClickNride
//
//  Created by Geetanjali on 16/09/20.
//  Copyright © 2020 Geetanjali. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import MapKit

class HomeController: UIViewController {
    
    // MARK: - Properties
    
    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ceckIfUserLogedIn()
        logOut()
        view.backgroundColor = .red

        // Do any additional setup after loading the view.
    }
    
    //MARK: - API
    
    func ceckIfUserLogedIn() {
        
        if Auth.auth().currentUser?.uid == nil {
            DispatchQueue.main.async {
                let vc = UINavigationController(rootViewController: LoginController())
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }else {
            configureUI()
        }
        
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch  {
            print("DEBUG: Error signing out")
        }
    }
    
    func configureUI() {
        configureMapView()
        enableLocationServices()

    }
    
    func configureMapView() {
        view.addSubview(mapView)
        mapView.frame = view.frame
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
}

// MARK: - LocationServices

extension HomeController: CLLocationManagerDelegate {
    
    func enableLocationServices() {
        
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        
        case .notDetermined:
            print("DEBUG: Not Determined...")
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            print("DEBUG: Auth Always...")
        case .authorizedWhenInUse:
            print("DEBUG: Auth when in use...")
            locationManager.requestAlwaysAuthorization()
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        }
        
    }
}
