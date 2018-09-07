//
//  EmployeesController.swift
//  Intermediate App
//
//  Created by Jose L Sanchez on 6/19/18.
//  Copyright © 2018 Jose L Sanchez. All rights reserved.
//

import UIKit

class CreateEmployeeController: UIViewController {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        //label.backgroundColor = .red
        //enable auto-layout
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.title = "Create Employee"
        
        setupCancelButton()
        
        view.backgroundColor = UIColor.darkBlue
        
         _ = setupLightBlueBackgroundiew(height: 50)
        
        setupUI()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "save", style: .plain, target: self, action: #selector(handleSave))
        
        
    }
    
    @objc private func handleSave() {
        
        guard let employeeName = nameTextField.text else {return}
         let error = CoreDataManager.shared.createEmployee(employeeName: employeeName )
        
        
        
        if let error = error {
            //present error modal use UIAlertController
            print(error)
            
            } else {
            
            dismiss(animated: true, completion: nil)
            
        }
    
        
        
        
    }
    
    func setupUI() {
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        //push namelabel 16
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        /***********************************************
         * anchor text field to name label
         ***********************************************/
        view.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        
      
    }
}


