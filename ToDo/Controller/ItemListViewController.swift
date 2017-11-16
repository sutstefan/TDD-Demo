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
    @IBOutlet var dataProvider: (UITableViewDataSource & UITableViewDelegate & ItemManagerSettable)!
    
    // MARK: Public
    
    let itemManager = ItemManager()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
        dataProvider.itemManager = itemManager
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: IBAction
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        if let nextViewController = storyboard?.instantiateViewController(withIdentifier: "InputViewController") as? InputViewController {
            nextViewController.itemManager = itemManager
            present(nextViewController, animated: true, completion: nil)
        }
    }
}
