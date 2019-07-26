//
//  DetailsVC.swift
//  ManasekAlHajj
//
//  Created by Medhat Mebed on 7/26/19.
//  Copyright © 2019 Medhat Mebed. All rights reserved.
//

import UIKit
import MapKit

class DetailsVC: UIViewController {
    @IBOutlet weak var officeAppartmentNameLbl: UILabel!
    @IBOutlet weak var reponsibleName: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var mokhaiamLbl: UILabel!
    @IBOutlet weak var streetLbl: UILabel!
    @IBOutlet weak var coordinatesLbl: UILabel!
    @IBOutlet weak var currentLocationLbl: UILabel!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var directionBtn: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    var officeGroupAppartment : OfficeGroupAppartment?
    var locationManager = CLLocationManager()
    var locationCoordinates : String = "" {
        didSet {
            DispatchQueue.main.async {
                self.currentLocationLbl.text = self.locationCoordinates
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLabels()
        addCornerRadios()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "التفاصيل"
    }
    
    func setupLabels() {
        self.officeAppartmentNameLbl.text = officeGroupAppartment?.officeGroupName ?? ""
        self.reponsibleName.text = officeGroupAppartment?.responsibleName ?? ""
        self.phoneLbl.text = officeGroupAppartment?.phone ?? ""
        self.mokhaiamLbl.text = officeGroupAppartment?.mokhaiam ?? ""
        self.streetLbl.text = officeGroupAppartment?.street ?? ""
        self.coordinatesLbl.text = ""
        self.currentLocationLbl.text = ""
        self.coordinatesLbl.text = "\(officeGroupAppartment?.latitude ?? "") \(officeGroupAppartment?.longitude ?? "")"
    }
    
    func addCornerRadios(){
        containerView.roundCornersWithBorder(borderWidth: 1, borderColor: .lightGray, radius: 7, isClips: true)
        locationBtn.roundCornersWithBorder(borderWidth: 1, borderColor: .lightGray, radius: 10, isClips: true)
        directionBtn.roundCornersWithBorder(borderWidth: 1, borderColor: .lightGray, radius: 10, isClips: true)
    }
    
    @IBAction func directionBtnPressed(_ sender: Any) {
        if self.coordinatesLbl.text == " " {
            AppManager.displayOkayAlert(title: "", message: "لم يتم العثور على احداثيات الموقع", forController: self)
        } else {
            performSegue(withIdentifier: "goToDirection", sender: UIButton())
        }
        
    }
    
    @IBAction func locationBtnPressed(_ sender: Any) {
        if self.coordinatesLbl.text == " " {
            AppManager.displayOkayAlert(title: "", message: "لم يتم العثور على احداثيات الموقع", forController: self)
        } else {
            performSegue(withIdentifier: "goToLocation", sender: UIButton())
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToLocation" {
            if let destination = segue.destination as? LocationMapVC {
                destination.longitude = Double(officeGroupAppartment?.longitude ?? "0.0") ?? 0.0
                destination.latitude = Double(officeGroupAppartment?.latitude ?? "0.0") ?? 0.0
            }
        }
        else if segue.identifier == "goToDirection" {
            if let destination = segue.destination as? DirectionMapVC {
                destination.longitude = Double(officeGroupAppartment?.longitude ?? "0.0") ?? 0.0
                destination.latitude = Double(officeGroupAppartment?.latitude ?? "0.0") ?? 0.0
            }
        }
    }
    
}

extension DetailsVC : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        let userLocation = locations.last
        if let latitude = userLocation?.coordinate.latitude {
            if let longitude = userLocation?.coordinate.longitude {
                self.locationCoordinates = "\(latitude) \(longitude)"
            }
        }
    }}
