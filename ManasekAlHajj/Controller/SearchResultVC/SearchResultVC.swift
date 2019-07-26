//
//  SearchResultVC.swift
//  ManasekAlHajj
//
//  Created by Medhat Mebed on 7/26/19.
//  Copyright © 2019 Medhat Mebed. All rights reserved.
//

import UIKit

class SearchResultVC: UIViewController {

    @IBOutlet weak var resultTableView: UITableView!
    
    var officeGroupAppartment = [OfficeGroupAppartment]()
    var officeGroup : OfficeGroupAppartment?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "نتيجة البحث"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailsVC {
            destination.officeGroupAppartment = self.officeGroup
        }
    }
 

}

extension SearchResultVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return officeGroupAppartment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell") as? SearchResultCell
        cell?.feedCell(officeGroupAppartment: officeGroupAppartment[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.officeGroup = officeGroupAppartment[indexPath.row]
        performSegue(withIdentifier: "goToDetails", sender: nil)
    }
    
    
}
