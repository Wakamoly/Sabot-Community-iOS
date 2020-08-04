//
//  SearchViewController.swift
//  Sabot Community
//
//  Created by Wakamoly on 7/14/20.
//  Copyright © 2020 LucidSoftworksLLC. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var search = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.searchController = search
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
