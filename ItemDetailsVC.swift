//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Shengyu Cao on 6/3/17.
//  Copyright © 2017 Shengyu Cao. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var thumgImg: UIImageView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    @IBOutlet weak var storePicker: UIPickerView!
    
    
    var stores = [Store]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        

        if let topItem = self.navigationController?.navigationBar.topItem{
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        //addStores()
        
        getStore()
        
        if itemToEdit != nil {
            loadItemData()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        return store.name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // update when store selected
    }
    
    func addStores(){
        
                let store = Store(context: context)
                store.name = "Best Buy"
                let store2 = Store(context: context)
                store2.name = "Target"
                let store3 = Store(context: context)
                store3.name = "Walmark"
                let store4 = Store(context: context)
                store4.name = "Amazon"
                let store5 = Store(context: context)
                store5.name = "Sears"
                let store6 = Store(context: context)
                store6.name = "ebay"
                
                ad.saveContext()
    }
    
    func getStore(){
        
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        let nameData = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        fetchRequest.sortDescriptors = [nameData]
        
        
        do {
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
        
    }
    
    
    func loadItemData(){
        if let item = itemToEdit {
            
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.detail
            thumgImg.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore{
                var index = 0
                repeat {
                    let s = stores[index]
                    if s.name == store.name{
                        storePicker.selectRow(index, inComponent: 0, animated: true)
                        break
                    }
                    index += 1
                } while (index < stores.count)
            }
        }
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        var item: Item!
        
        let picture = Image(context: context)
        picture.image = thumgImg.image
        
        if itemToEdit == nil {
            item = Item(context: context) // if new, creat new context
        } else {
            item = itemToEdit // if editing exiting record, replace existing record
        }
//item.toImage need to go after above selection of Item. otherwise gets a nil  error.
        item.toImage = picture
        
        if let title = titleField.text{
            item.title = title
        } else {
            item.title = ""
        }
        
        if let price = priceField.text{
            item.price = (price as NSString).doubleValue
        } else {
            item.price = 0.0
        }
        
        if let details = detailsField.text{
            item.detail = details
        } else {
            item.detail = ""
        }
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        
        
        ad.saveContext()
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        
        _ = navigationController?.popViewController(animated: true)
    
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumgImg.image = img
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    
}
