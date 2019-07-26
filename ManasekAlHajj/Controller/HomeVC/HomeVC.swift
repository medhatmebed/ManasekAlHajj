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
    @IBOutlet weak var searchBtn: UIButton!
    
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
    var selectedmashaerId = ""
    var selectedDirectionTypesId = ""
    var selectedDirectionsId = ""
    
    let homeVCRepo = HomeVCRepo()
    var officeGroupAppartment = [OfficeGroupAppartment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFieldsPicker()
        self.homeVCRepo.delegate = self
        setRounConrner()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.homeVCRepo.getMashaer()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "جمعية الكشافة العربية السعودية"
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.title = "الرئيسية"
    }
    
    private func setupTextFieldsPicker() {
        mashaerTxtField.isOptionalDropDown = false
        directionTypesTxtField.isOptionalDropDown = false
        directionsTxtField.isOptionalDropDown = false
    }
    private func setRounConrner() {
        searchBtn.roundCornersWithBorder(borderWidth: 1, borderColor: .lightGray, radius: 20, isClips: true)
        containerView.roundCornersWithBorder(borderWidth: 1, borderColor: .lightGray, radius: 10, isClips: true)
    }
    
    @IBAction func searchBtnPressed(_ sender: UIButton) {
        
        if selectedmashaerId == "" {
            AppManager.displayOkayAlert(title: AppManager.G_APP_NAME, message: "من فضلك ادخل المشعر", forController: self)
        } else {
            AppManager.showLoaderForController(self)
            self.homeVCRepo.GetOfficeGroupAppartment(mashaerId: String(selectedmashaerId),
                                                     directionTypeId: String(selectedDirectionTypesId),
                                                     directionId: String(selectedDirectionsId))
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SearchResultVC {
            destination.officeGroupAppartment = self.officeGroupAppartment
        }
    }
    
    
}

extension HomeVC : IQDropDownTextFieldDelegate, IQDropDownTextFieldDataSource {
    func textField(_ textField: IQDropDownTextField, didSelectItem item: String?) {
        if textField == self.mashaerTxtField {
            for index in 1...(mashaerArray?.count ?? 0) - 1 where mashaerArray?[index] == item {
                self.selectedmashaerId = String(mashaerIds[index - 1])
            }
        }
        else if textField == self.directionTypesTxtField {
            for index in 1...(directionTypes?.count ?? 0) - 1 where directionTypes?[index] == item {
                self.selectedDirectionTypesId = String(directionTypeIds[index - 1])
                self.homeVCRepo.getDirections(directionTypeId: directionTypeIds[index - 1])
            }
        }
        else if textField == self.directionsTxtField {
            for index in 1...(directions?.count ?? 0) - 1 where directions?[index] == item {
                self.selectedDirectionsId = String(directionsIds[index - 1])
            }
        }
    }
}

extension HomeVC : HomeVCRepoDelegate {
    
    func getMashaerSuccess(mashaer: [Mashaer]) {
        self.homeVCRepo.getDirectionTypes()
        self.mashaerArray = [""]
        self.mashaerIds.removeAll()
        for item in mashaer {
            self.mashaerArray?.append(item.name ?? "")
            self.mashaerIds.append(item.mashaerID ?? 0)
        }
    }
    
    func getMashaerFail(error: String) {
        print(error)
    }
    
    func getDirectionTypesSuccess(directiontypes: [DirectionType]) {
        self.directionTypes = [""]
        self.directionTypeIds.removeAll()
        for item in directiontypes {
            self.directionTypes?.append(item.directionTypeName ?? "")
            self.directionTypeIds.append(item.directionTypeID ?? 0)
        }
    }
    
    func getDirectionTypesFail(error: String) {
        print(error)
    }
    
    func getDirectionsSuccess(directions: [Direction]) {
        self.directions = [""]
        self.directionsIds.removeAll()
        for item in directions {
            self.directions?.append(item.directionName ?? "")
            self.directionsIds.append(item.directionID ?? 0)
        }
    }
    
    func getDirectionsFail(error: String) {
        print(error)
    }
    
    func getOfficeGroupAppartmentsSuccess(officGroupAppartments: [OfficeGroupAppartment]) {
        AppManager.hideLoaderForController(self)
        if officGroupAppartments.count > 0 {
            self.officeGroupAppartment = officGroupAppartments
            performSegue(withIdentifier: "goToSearchResultVC", sender: nil)
        } else {
            AppManager.displayOkayAlert(title: AppManager.G_APP_NAME, message: "لم يتم العثور على البيانات", forController: self)
        }
        
    }
    
    func getOfficeGroupAppartmentsSuccessFail(error: String) {
        AppManager.hideLoaderForController(self)
        AppManager.displayOkayAlert(title: AppManager.G_APP_NAME, message: "لم يتم العثور على البيانات", forController: self)
        print(error)
    }
    
    
}

