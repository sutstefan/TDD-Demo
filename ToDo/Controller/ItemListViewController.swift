//
//  ItemListViewController.swift
//  ToDo
//
//  Created by Stefan Sut on 10/18/17.
//  Copyright © 2017 Stefan Sut. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {
    
    // MARK: IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var dataProvider: (UITableViewDataSource & UITableViewDelegate)!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
    }
    
}
