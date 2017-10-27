//
//  DetailViewController.swift
//  ToDo
//
//  Created by Stefan Sut on 10/26/17.
//  Copyright © 2017 Stefan Sut. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    
    var itemInfo: (ItemManager, Int)?
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let itemInfo =  itemInfo else { return }
        let item = itemInfo.0.item(at: itemInfo.1)
        titleLabel.text = item.title
        locationLabel.text = item.location?.name
        descriptionLabel.text = item.itemDescription
        
        if let timestamp = item.timestamp {
            let date = Date(timeIntervalSince1970: timestamp)
            dateLabel.text = dateFormatter.string(from: date)
        }
        
        if let coortinate = item.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coortinate, 100, 100)
            mapView.region = region
        }
    }
    
    func checkItem() {
        if let itemInfo = itemInfo {
            itemInfo.0.checkItem(at: itemInfo.1)
        }
    }
    
}
