//
//  EmployeesController.swift
//  Intermediate App
//
//  Created by Jose L Sanchez on 6/19/18.
//  Copyright © 2018 Jose L Sanchez. All rights reserved.
//

import UIKit

class EmployeesController: UITableViewController {
    
    
    
    var company: Company?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.darkBlue
        
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
    }
      
       @objc private func handleAdd() {
        
        let createEmployeeController = CreateEmployeeController()
        let navController = UINavigationController(rootViewController: createEmployeeController)
        present(navController, animated: true, completion: nil)
        
    
        
        }
}
