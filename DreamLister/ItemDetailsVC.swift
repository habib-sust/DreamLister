//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Habibur Rahman on 4/22/17.
//  Copyright © 2017 Habibur Rahman. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    @IBOutlet weak var storePicker: UIPickerView!
    
    
    @IBOutlet weak var thumbImage: UIImageView!
    
    var stores = [Store]()
    var types = [ItemType]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController?
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let topItem = self.navigationController?.navigationBar.topItem{
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        
        let store = Store(context: context!)
        store.name = "eBay"

        let store2 = Store(context: context!)
        store2.name = "Amazon"
        
        let store3 = Store(context: context!)
        store3.name = "Wall Mart"
        
        let store4 = Store(context: context!)
        store4.name = "Tesla Deallership"
        
        let store5 = Store(context: context!)
        store5.name = "Steam Store"
        
        
        let type = ItemType(context: context!)
        type.type = "Game"
        
        let type2 = ItemType(context: context!)
        type2.type = "Electronics"
        
        let type3 = ItemType(context: context!)
        type3.type = "Car"
        
        let type4 = ItemType(context: context!)
        type4.type = "Sports"
        
        let type5 = ItemType(context: context!)
        type5.type = "Travels"
        ad?.saveContext()
        
        
       getStores()
        
        if itemToEdit != nil{
            loadItemData()
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        
        
        if component == 1{
            return types[row].type
            
        } else {
        
            return stores[row].name
        }
        
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0{
        
            return stores.count
        } else {
            
            return types.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // update when selected
    }
    
    
    func getStores(){
        
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        let fetchRequest2: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        
        
        
        do {
            let store = try context?.fetch(fetchRequest)
            stores = store!
            
            let type = try context?.fetch(fetchRequest2)
            types = type!
            
            self.storePicker.reloadAllComponents()
            
        } catch {
            //  handle the error
        }
    
    }
    
    
    
    
    @IBAction func saveButttonPressed(_ sender: Any) {
        
        
        var item: Item
        
        let picture = Image(context: context!)
        picture.image = thumbImage.image
        
        if itemToEdit == nil {
            item = Item(context: context!)
        } else{
          item = itemToEdit!
        }
        
        item.toImage = picture  
        
        if let title = titleField.text{
            
            item.title = title
        }
        
        if let price = priceField.text{
            item.price = Double(price)!
        }
        
        if let details = detailsField.text{
            item.details = details
        }
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        item.toItemType = types[storePicker.selectedRow(inComponent: 1)]
        
        ad?.saveContext()
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    
    func loadItemData(){
        
        if let item = itemToEdit {
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            thumbImage.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore {
                
                var index = 0
                repeat{
                    let s = stores[index]
                    if s.name == store.name {
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                }while (index < stores.count)
                
                
            }
            
            
            if let type = item.toItemType {
                var index = 0
                repeat{
                    let t = types[index]
                    
                    if t.type == type.type{
                        storePicker.selectRow(index, inComponent: 1, animated: false)
                        break
                    }
                    
                    index += 1
                }while(index < types.count)
            }
        }
        
    }
    
    
    
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        
        if itemToEdit != nil{
            
            context?.delete(itemToEdit!)
            
            ad?.saveContext()
        }
        
        _ = navigationController?.popViewController(animated: false)
    }
    
    @IBAction func addImageButtonPressed(_ sender: UIButton) {
        
        present(imagePicker!, animated: true, completion: nil)
        
        
        
        
    }
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            thumbImage.image = img
        }
        
        imagePicker?.dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
