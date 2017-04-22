//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Habibur Rahman on 4/22/17.
//  Copyright © 2017 Habibur Rahman. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource{

    
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    @IBOutlet weak var storePicker: UIPickerView!
    
    
    var stores = [Store]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let topItem = self.navigationController?.navigationBar.topItem{
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        
//        let store = Store(context: context!)
//        store.name = "Amazon"
//
//        let store2 = Store(context: context!)
//        store2.name = "eBay"
//        
//        let store3 = Store(context: context!)
//        store3.name = "Wall Mart"
//        
//        let store4 = Store(context: context!)
//        store4.name = "Tesla Deallership"
//        
//        let store5 = Store(context: context!)
//        store5.name = "Steam Store"
//        
        
//        ad?.saveContext()
        
        
        
        getStores()
        // Do any additional setup after loading the view.
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        
        return store.name
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // update when selected
    }
    
    
    func getStores(){
        
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        
        
        do {
            let store = try context?.fetch(fetchRequest)
            stores = store!
            self.storePicker.reloadAllComponents()
            
        } catch {
            //  handle the error
        }
    
    }
    
    
    
    
    @IBAction func saveButttonPressed(_ sender: Any) {
        
        let item = Item(context: context!)
        
        if let title = titleField.text{
            
            item.title = title
        }
        
        if let price = priceField.text{
            item.price = price
        }
        
        if let details = detailsField.text{
            item.details = details
        }
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        
        ad?.saveContext()
        
        navigationController?.popViewController(animated: true)
    }
    
    
    
}
