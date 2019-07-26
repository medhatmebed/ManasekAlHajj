//
//  DetailsVC.swift
//  ManasekAlHajj
//
//  Created by Medhat Mebed on 7/26/19.
//  Copyright © 2019 Medhat Mebed. All rights reserved.
//

import UIKit

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
    
    var officeGroupAppartment : OfficeGroupAppartment?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLabels()
        
    }
    
    func setupLabels() {
        self.officeAppartmentNameLbl.text = officeGroupAppartment?.officeGroupName ?? ""
        self.reponsibleName.text = officeGroupAppartment?.responsibleName ?? ""
        self.phoneLbl.text = officeGroupAppartment?.phone ?? ""
        self.mokhaiamLbl.text = officeGroupAppartment?.mokhaiam ?? ""
        self.streetLbl.text = officeGroupAppartment?.street ?? ""
        self.coordinatesLbl.text = ""
        self.currentLocationLbl.text = ""
    }

}
