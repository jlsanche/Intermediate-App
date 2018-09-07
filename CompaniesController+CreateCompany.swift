//
//  CompaniesController+CreateCompany.swift
//  Intermediate App
//
//  Created by Jose L Sanchez on 6/19/18.
//  Copyright © 2018 Jose L Sanchez. All rights reserved.
//

import UIKit

extension CompaniesController: CreateCompanyControllerDelegate {
    //specify extension methods here
    
    func didEditCompany(company: Company) {
        // update my tableview somehow
        let row = companies.index(of: company)
        let reloadIndexPath = IndexPath(row: row!, section: 0)
        tableView.reloadRows(at: [reloadIndexPath], with: .middle)
    }
    
    
    func didAddCompany(company: Company) {
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    
}
