//
//  CreateCompanyController.swift
//  Intermediate App
//
//  Created by Jose L Sanchez on 6/9/18.
//  Copyright © 2018 Jose L Sanchez. All rights reserved.
//

import UIKit
import CoreData
//custom delegation makes it not tightly coupled

protocol CreateCompanyControllerDelegate {
    func didAddCompany(company: Company)
    func didEditCompany(company: Company)
}

class CreateCompanyController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var company: Company? {
        didSet {
            
            nameTextField.text = company?.name  //prefill form with row name to update
            
            if let imageData = company?.imageData {
                companyImageVIew.image = UIImage(data: imageData)
                setupCircularImageStyle()
                
               
            }
            
            guard let founded = company?.founded else {return }
            datePicker.date = founded
        }
    }
    
    private func setupCircularImageStyle() {
        //make image circular with border
        companyImageVIew.layer.cornerRadius = companyImageVIew.frame.width / 2
        companyImageVIew.clipsToBounds = true
        companyImageVIew.layer.borderColor = UIColor.darkBlue.cgColor
        companyImageVIew.layer.borderWidth = 2
    }
    
    var delegate: CreateCompanyControllerDelegate?
    
    //var companiesController: CompaniesController?
    
    //closures , lazy allows self to be other than nil
    lazy var companyImageVIew : UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true  //make images interactive
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
        return imageView
        
    }()
    
    @objc private func handleSelectPhoto() {
        print("trying to to select photo ...")
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            companyImageVIew.image = editedImage
            
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage { companyImageVIew.image = originalImage}
        
        setupCircularImageStyle()
        
      
        
        dismiss(animated: true, completion: nil)
    }
    

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
    
    let datePicker : UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.translatesAutoresizingMaskIntoConstraints = false
         return dp
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //ternary syntax will change title to appropriate action
        navigationItem.title = company == nil ? "Create Company" : "Edit Company"
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        setupCancelButton()
        
        //create save button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        
        view.backgroundColor = .darkBlue
       
    }
    
    private func createCompany(){
        
        /***********************************************
         * loading of Core Data Stack
         ***********************************************/
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        
        
        //grab user input
        company.setValue(nameTextField.text, forKey: "name")
        company.setValue(datePicker.date, forKey: "founded")
        
        if let companyImage = companyImageVIew.image {
            let imageData = UIImageJPEGRepresentation(companyImage, 0.8)
            
            company.setValue(imageData, forKey: "imageData")
        }
        
        
        
        //perform save
        do{
            
            try context.save()
            
            //success
            
            dismiss(animated: true, completion: {
                self.delegate?.didAddCompany(company: company as! Company)
                
            })
            
        } catch let saveErr{
            print("failed to save company", saveErr)
        }
        
    }
    
   @objc private func handleSave() {
    if company == nil {
        createCompany()
    } else {
        saveCompanyChanges()
    }
 }
    
    private func saveCompanyChanges() {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        company?.name = nameTextField.text
        company?.founded = datePicker.date
        
        if let companyImage = companyImageVIew.image {
            let imageData = UIImageJPEGRepresentation(companyImage, 0.8)
            company?.imageData = imageData
            
        }
        
        do{
            try context.save()
            //save succeeded
            dismiss(animated: true) {
                self.delegate?.didEditCompany(company: self.company!)
            }
        } catch let saveErr {
            print("Failed to save company changes", saveErr)
        }
        
        
    }
    
    private func setupUI() {
        
        let lightBlueBackgroundView = setupLightBlueBackgroundiew(height: 350)
        
        view.addSubview(companyImageVIew)
        companyImageVIew.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        companyImageVIew.heightAnchor.constraint(equalToConstant: 100).isActive = true
        companyImageVIew.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        companyImageVIew.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: companyImageVIew.bottomAnchor, constant: 5).isActive = true
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
        
        //setup data picker-
        view.addSubview(datePicker)
        datePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        datePicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        datePicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: lightBlueBackgroundView.bottomAnchor )
    }
    
    
    }
