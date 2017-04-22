//
//  ViewController.swift
//  DreamLister
//
//  Created by Habibur Rahman on 4/7/17.
//  Copyright © 2017 Habibur Rahman. All rights reserved.
//

import UIKit
import CoreData
class MainVC: UIViewController , UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    var controller: NSFetchedResultsController<Item>!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        //generateTestData()
        attemptFetch()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    func configureCell(cell: ItemCell, indexPath: NSIndexPath){
        
        let item = controller.object(at: indexPath as IndexPath)
        
        cell.congifureCell(item: item)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections{
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections{
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }
    

    func attemptFetch(){
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        self.controller = controller
        
        do {
            try controller.performFetch()
        }catch{
            
            let error = error as NSError
            
            print("\(error)")
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case.insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
            
        case.update:
            if let indexPath = indexPath{
                
                let cell = tableView.cellForRow(at: indexPath) as? ItemCell
                
                configureCell(cell: cell!, indexPath: indexPath as NSIndexPath)
                // update the cell data
            }
            
        case.move:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            
            break
        
    }
    
    }
    
    func generateTestData(){
        
        let item = Item(context: context!)
        item.title = "MacBook Pro"
        item.price = "1800"
        item.details = "Kinna de keo"
        
        let item2 = Item(context: context!)
        item2.title = "Jaggernaut Immortal set"
        item2.price = "10"
        item2.details = "I am dying for this set"
        
        let item3 = Item(context: context!)
        item3.title = "Tesla Model S"
        item3.price = "11000"
        item3.details = "Oh man this the beautiful car. Oneday I will own it "
        
        let item4 = Item(context: context!)
        item4.title = "Play Station 4"
        item4.price = "500"
        item4.details = " Game khelte mon chai"
        
        
        ad?.saveContext()
    }
}

