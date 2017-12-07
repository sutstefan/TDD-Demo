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
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
        dataProvider.itemManager = itemManager
        
        NotificationCenter.default.addObserver(self, selector: #selector(showDetails(sender:)), name: NSNotification.Name("ItemSelectedNotification"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @objc func showDetails(sender: NSNotification) {
        guard let index = sender.userInfo?["index"] as? Int else {
            fatalError()
        }
        
        if let nextViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            nextViewController.itemInfo = (itemManager, index)
            navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
    // MARK: IBAction
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        if let nextViewController = storyboard?.instantiateViewController(withIdentifier: "InputViewController") as? InputViewController {
            nextViewController.itemManager = itemManager
            present(nextViewController, animated: true, completion: nil)
        }
    }
    
}
