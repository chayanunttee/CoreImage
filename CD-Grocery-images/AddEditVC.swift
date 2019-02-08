//
//  AddEditVC.swift
//  CD-Grocery-Images
//
//  Created by Jason Rybka on 8/16/15.
//  Copyright © 2015 Jason Rybka. All rights reserved.
//

import UIKit
import CoreData

class AddEditVC: UIViewController, NSFetchedResultsControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var item : Item? = nil
    

    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemPhone: UITextField!
    @IBOutlet weak var imageHolder: UIImageView!
    
    let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if item != nil {
            itemName.text = item?.name
            itemPhone.text = item?.phone
            imageHolder.image = UIImage(data: (item?.image)! as Data)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addImage(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        pickerController.allowsEditing = true
        
        self.present(pickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func addImageFromCamera(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerController.SourceType.camera
        pickerController.allowsEditing = true
        
        self.present(pickerController, animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.dismiss(animated: true, completion: nil)
        
        self.imageHolder.image = image
    }
    

    @IBAction func saveTapped(_ sender: Any) {
        if item != nil {
            editItem()
        } else {
            createNewItem()
        }
        dismissVC()
    }
    
    func dismissVC() {
        navigationController?.popViewController(animated: true)
    }
    
    func createNewItem(){
        let entityDescription = NSEntityDescription.entity(forEntityName: "Item", in: moc)
        
        let item = Item(entity: entityDescription!, insertInto: moc)
        
        item.name = itemName.text
        item.phone = itemPhone.text
        item.image = imageHolder.image!.pngData()! as? NSData
        
        do {
            try moc.save()
        } catch {
            return
        }
        
    }
    
    func editItem() {

        item?.name = itemName.text
        item?.phone = itemPhone.text
        item!.image = imageHolder.image!.pngData()! as? NSData
        
        do {
            try moc.save()
        } catch {
            return
        }
        
    }
    
}













