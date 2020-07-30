//
//  MapController.swift
//  Risk Inspections project
//
//  Created by Antoine Perry on 7/24/20.
//  Copyright © 2020 Antoine Perry. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapController: UIViewController {
    
    //MARK: - Properties
    
    var inspectionArray: [InspectionModel]? {
        didSet {
            guard let inspectionArray = inspectionArray else { return }
            for item in inspectionArray {
                customAnnotation(locations: [item])
            }
        }
    }
    
    var currentLocation: CLLocation!
    
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var searchInputView: SearchInputView!
    
    let centerMapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "location-arrow-flat").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCenterLocation), for: .touchUpInside)
        return button
    }()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        enableLocationServices()
        
        Service.shared.fetchInspections { (inspectionArray) in
            self.inspectionArray = inspectionArray
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        centerMapOnUser()
    }
    
    //MARK: - Seletors
    
    @objc func handleCenterLocation() {
        centerMapOnUser()
    }
    
    //MARK: - Helper Functions
    
    func customAnnotation(locations: [InspectionModel]) {
       
        for location in locations {
            let annotation = MKPointAnnotation()
            if location.risk.rawValue == self.getRiskString(risk: .risk2Medium) || location.risk.rawValue == self.getRiskString(risk: .risk3Low) {
                annotation.title = location.risk.rawValue

                guard let latDouble = location.latitude?.toDouble() else { return }
                guard let longDouble = location.longitude?.toDouble() else { return }

                annotation.coordinate = CLLocationCoordinate2D(latitude: latDouble, longitude: longDouble)

                mapView.addAnnotation(annotation)
            }
        }
    }
    
    func getRiskString(risk: Risk) -> String {
        return risk.rawValue
    }
    
    func riskCase(risk: Risk) {
        switch risk {
        case .risk1High:
            print("N/A")
        case .risk2Medium:
            print("Medium")
        case .risk3Low:
            print("Low")
        }
    }
    
    func configureUI() {
        view.backgroundColor = .blue
        configureMapView()
        searchInputView = SearchInputView()
        searchInputView.delegate = self
        
        view.addSubview(searchInputView)
        searchInputView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingBottom: -(view.frame.height - 88), height: view.frame.height)
        
        view.addSubview(centerMapButton)
        centerMapButton.anchor(bottom: searchInputView.topAnchor, right: view.rightAnchor, paddingBottom: 16, paddingRight: 16, width: 50, height: 50)
    }
    
    func configureMapView() {
        mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow

        
        view.addSubview(mapView)
        mapView.addConstraintsToFillView(view)
    }
}

// MARK: - SearchInputViewDelegate

extension MapController: SearchInputViewDelegate {
    func animateCenterMapButton(expansionState: SearchInputView.ExpansionState, hidebutton: Bool) {
        switch expansionState {
            
        case .NotExpanded:
            UIView.animate(withDuration: 0.25) {
                self.centerMapButton.frame.origin.y -= 250
            }
            
            if hidebutton {
                self.centerMapButton.alpha = 0
            } else {
                self.centerMapButton.alpha = 1
            }
            
        case .PartiallyExpanded:
            if hidebutton {
                self.centerMapButton.alpha = 0
            } else {
                UIView.animate(withDuration: 0.25) {
                    self.centerMapButton.frame.origin.y += 250
                }
            }
        case .FullyExpanded:
            if !hidebutton {
                UIView.animate(withDuration: 0.25) {
                    self.centerMapButton.alpha = 1
                }
            }
        }
    }
}

// MARK: - MapKit Helper Functions

extension MapController {
        
    func centerMapOnUser() {
        guard let coordinates = locationManager.location?.coordinate else { return }
        let coorinateRegion = MKCoordinateRegion(center: coordinates, latitudinalMeters: 2000, longitudinalMeters: 2000)
        mapView.setRegion(coorinateRegion, animated: true)
    }
}

extension MapController: CLLocationManagerDelegate {
    
    func enableLocationServices() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        switch CLLocationManager.authorizationStatus() {
            
        case .notDetermined:
            print("Location auth services is not determined")
            
            DispatchQueue.main.async {
                let controller = LocationRequestController()
                controller.locationManager = self.locationManager
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
            }
        case .restricted:
            print("Location auth services is restricted")
        case .denied:
            print("Location auth services is denied")
        case .authorizedAlways:
            print("Location auth services is Authorized always")
        case .authorizedWhenInUse:
            print("Location auth services is Authorized when in use")
        @unknown default:
            fatalError()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        mapView.userLocation.title = "lat = \(locValue.latitude), long = \(locValue.longitude)"
    }
}
