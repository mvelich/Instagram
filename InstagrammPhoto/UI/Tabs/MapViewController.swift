//
//  MapViewController.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 17.02.21.
//  Copyright © 2021 Maksim Velich. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var backButton: UIButton! {
        didSet {
            backButton.setRounded()
        }
    }
    @IBOutlet weak var saveButton: UIButton! {
        didSet {
            saveButton.setRounded()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func savedButtonPressed(_ sender: UIButton) {
        
    }
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mapView.mapType = MKMapType.standard
        if let location = locations.first {
            locationManager.stopUpdatingLocation()
            showLocation(location)
        }
    }
    
    func showLocation(_ location: CLLocation) {
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
        let pinAnnotation = MKPointAnnotation()
        pinAnnotation.coordinate = center
        mapView.addAnnotation(pinAnnotation)
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error: \(error)")
            }
            
            guard let placemark = placemarks?.first else { return }
            let streetName = placemark.thoroughfare
            DispatchQueue.main.async {
                self.locationLabel.text = streetName
            }
        }
    }
}

