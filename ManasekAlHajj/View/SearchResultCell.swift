//
//  SearchResultCell.swift
//  ManasekAlHajj
//
//  Created by Medhat Mebed on 7/26/19.
//  Copyright © 2019 Medhat Mebed. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {

    @IBOutlet weak var officeGroupNameLbl: UILabel!
    @IBOutlet weak var nationalityLbl: UILabel!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var mokhayamLbl: UILabel!
    @IBOutlet weak var streetLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        initializeCell()
        
    }

    func initializeCell() {
        self.officeGroupNameLbl.text = "المقر"
        self.nationalityLbl.text = "الجنسية"
        self.phoneNumberLbl.text = "الهاتف"
        self.streetLbl.text = "الشارع"
        self.mokhayamLbl.text = "المخيم"
    }
    
    func feedCell(officeGroupAppartment : OfficeGroupAppartment){
        self.officeGroupNameLbl.text = officeGroupAppartment.officeGroupName
        self.nationalityLbl.text = "الجنسية" + (officeGroupAppartment.nationalityName ?? " ")
        self.phoneNumberLbl.text = "الهاتف" + (officeGroupAppartment.phone ?? "")
        self.mokhayamLbl.text = "المخيم" + (officeGroupAppartment.mokhaiam ?? "")
        self.streetLbl.text = "الشارع" + (officeGroupAppartment.street ?? "")
        
    }

}
