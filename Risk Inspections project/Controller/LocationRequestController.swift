//
//  LocationRequestController.swift
//  Risk Inspections project
//
//  Created by Antoine Perry on 7/24/20.
//  Copyright © 2020 Antoine Perry. All rights reserved.
//

import UIKit
import CoreLocation

class LocationRequestController: UIViewController {
    
    //MARK: - Properties
    
    var locationManager: CLLocationManager?
    var inspection = [InspectionModel]()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "blue-pin")
        return iv
    }()
    
    let allowLocationLabel : UILabel = {
       let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "Allow Location\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 24), NSAttributedString.Key.foregroundColor : UIColor.black])
        
        attributedText.append(NSAttributedString(string: "Please enable location services so that we can show nearby inspections", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.black]))
        
        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = attributedText
        
        return label
    }()
    
    let enableLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Enable Location", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = .mainBlue
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleRequestLocation), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    //MARK: - Selelctors
    
    @objc func handleRequestLocation() {
        guard let locationManager = self.locationManager else { return }
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    //MARK: - Helper Functions
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        imageView.anchor(top: view.topAnchor, paddingTop: 140, width: 200, height: 200)
        imageView.centerX(inView: view)
        
        view.addSubview(allowLocationLabel)
        allowLocationLabel.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        allowLocationLabel.centerX(inView: view)
        
        view.addSubview(enableLocationButton)
        enableLocationButton.anchor(top: allowLocationLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingRight: 32, height: 50)
    }
}

extension LocationRequestController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard locationManager?.location != nil else {
            print("Error setting location..")
            return
        }
        
        dismiss(animated: true, completion: nil)
    }
}
