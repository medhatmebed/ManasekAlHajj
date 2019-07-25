//
//  ViewController.swift
//  RitesOfPilgrimage
//
//  Created by Medhat Mebed on 7/24/19.
//  Copyright © 2019 Medhat Mebed. All rights reserved.
//

import UIKit
import IQDropDownTextField

class HomeVC: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var mashaerTxtField: IQDropDownTextField!
    @IBOutlet weak var directionTypesTxtField: IQDropDownTextField!
    @IBOutlet weak var directionsTxtField: IQDropDownTextField!
    @IBOutlet weak var officeOrCampainTxtField: UITextField!
    @IBOutlet weak var contractorTxtField: UITextField!
    @IBOutlet weak var phoneTxtField: UITextField!
    @IBOutlet weak var nationalityTxtField: UITextField!
    
    
    var mashaerArray : [String]? = [""] {
        didSet {
            DispatchQueue.main.async {
                self.mashaerTxtField.itemList = self.mashaerArray ?? []
            }
        }
    }
    var mashaerIds = [Int]()
    
    var directionTypes : [String]? = [""] {
        didSet {
            DispatchQueue.main.async {
                self.directionTypesTxtField.itemList = self.directionTypes ?? [""]
            }
        }
    }
    var directionTypeIds = [Int]()
    
    var directions : [String]? = [""] {
        didSet {
            DispatchQueue.main.async {
                self.directionsTxtField.itemList = self.directions ?? [""]
            }
        }
    }
    var directionsIds = [Int]()
    
    var selectedmashaerId = 0
    var selectedDirectionTypesId = 0
    var selectedDirectionsId = 0
    
    let homeVCRepo = HomeVCRepo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFieldsPicker()
        self.homeVCRepo.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.homeVCRepo.getMashaer()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    private func setupTextFieldsPicker() {
        mashaerTxtField.isOptionalDropDown = false
        directionTypesTxtField.isOptionalDropDown = false
        directionsTxtField.isOptionalDropDown = false
    }
    
    
}

extension HomeVC : IQDropDownTextFieldDelegate, IQDropDownTextFieldDataSource {
    func textField(_ textField: IQDropDownTextField, didSelectItem item: String?) {
        if textField == self.mashaerTxtField {
            for index in 0...(mashaerArray?.count ?? 0) - 1 where mashaerArray?[index] == item {
                self.selectedmashaerId = mashaerIds[index - 1]
                print("selected Mashaer Id is \(selectedmashaerId)")
            }
        }
        else if textField == self.directionTypesTxtField {
            for index in 0...(directionTypes?.count ?? 0) - 1 where directionTypes?[index] == item {
                self.selectedDirectionTypesId = directionTypeIds[index - 1]
                self.homeVCRepo.getDirections(directionTypeId: selectedDirectionTypesId)
                print("selected Mashaer Id is \(selectedDirectionTypesId)")
            }
        }
        else if textField == self.directionsTxtField {
            for index in 0...(directions?.count ?? 0) - 1 where directions?[index] == item {
                self.selectedDirectionsId = directionsIds[index - 1]
                print("selected Mashaer Id is \(selectedDirectionsId)")
            }
        }
    }
}

extension HomeVC : HomeVCRepoDelegate {
    
    func getMashaerSuccess(mashaer: [Mashaer]) {
        self.homeVCRepo.getDirectionTypes()
        for item in mashaer {
            self.mashaerArray?.append(item.name ?? "")
            self.mashaerIds.append(item.mashaerID ?? 0)
        }
    }
    
    func getMashaerFail(error: String) {
        print(error)
    }
    
    func getDirectionTypesSuccess(directiontypes: [DirectionType]) {
        for item in directiontypes {
            self.directionTypes?.append(item.directionTypeName ?? "")
            self.directionTypeIds.append(item.directionTypeID ?? 0)
        }
    }
    
    func getDirectionTypesFail(error: String) {
        print(error)
    }
    
    func getDirectionsSuccess(directions: [Directions]) {
        for item in directions {
            self.directions?.append(item.directionName ?? "")
            self.directionsIds.append(item.directionID ?? 0)
        }
    }
    
    func getDirectionsFail(error: String) {
        print(error)
    }
    
    func getOfficeGroupAppartmentsSuccess(officGroupAppartments: [OfficeGroupAppartment]) {
        print(officGroupAppartments)
    }
    
    func getOfficeGroupAppartmentsSuccessFail(error: String) {
        print(error)
    }
    
    
}

