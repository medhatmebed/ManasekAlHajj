//
//  LoaderView.swift
//  SelfServices
//
//  Created by Owen on 2018-06-11.
//  Copyright © 2018 Rent Centric. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoaderView: UIView {

    func showLoader()  {
        
        let color = UIColor.white
        let size:CGFloat = 50.0
        
        let loader = NVActivityIndicatorView(frame: CGRect(x:center.x - (size / 2) ,
                                                           y:center.y - (size / 2),
                                                           width:size,
                                                           height:size),
                                             type: .ballPulse,
                                             color: color,
                                             padding: nil)
        
        self.addSubview(loader)
        loader.startAnimating()
    }
}
