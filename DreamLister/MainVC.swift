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
        generateTestData()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objs = controller.fetchedObjects, objs.count > 0 {
            let item = objs[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetailsVC"{
            if let destination = segue.destination as? ItemDetailsVC{
                
                if let item = sender as? Item{
                    destination.itemToEdit = item
                }
            }
        }
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
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        
        
        if segment.selectedSegmentIndex == 0{
        
            fetchRequest.sortDescriptors = [dateSort]
        } else if segment.selectedSegmentIndex == 1 {
            
            fetchRequest.sortDescriptors = [priceSort]
        } else if segment.selectedSegmentIndex == 2{
            
            fetchRequest.sortDescriptors = [titleSort]
        }
        
        
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
    
    
    @IBAction func segmentSelected(_ sender: UISegmentedControl) {
        
        if segment.selectedSegmentIndex != 3{
        
            attemptFetch()
            
            tableView.reloadData()
        }
        
    }
    
    
    
    
    
    
    func generateTestData(){
        
        let item = Item(context: context!)
        item.title = "XBox360"
        item.price = 500
        item.details = "Kinna de keo"
        let picture = Image(context: context!)
        picture.image = UIImage(named: "xbox360.jpg")
        item.toImage = picture
        
        let item2 = Item(context: context!)
        item2.title = "Jaggernaut Immortal set"
        item2.price = 10
        item2.details = "I am dying for this set"
        let picture2 = Image(context: context!)
        picture2.image = UIImage(named: "jugg.jpeg")
        item2.toImage = picture2
        
        let item3 = Item(context: context!)
        item3.title = "Tesla Model S"
        item3.price = 11000
        item3.details = "Oh man this the beautiful car. Oneday I will own it "
        let picture3 = Image(context: context!)
        picture3.image = UIImage(named: "Tesla-Model-S-1")
        item3.toImage = picture3
        
        let item4 = Item(context: context!)
        item4.title = "Play Station 4"
        item4.price = 550
        item4.details = " Game khelte mon chai"
        let picture4 = Image(context: context!)
        picture4.image = UIImage(named: "ps4.jpeg")
        item4.toImage = picture4
        
        
        let item5 = Item(context: context!)
        item5.title = "Uncharted 4"
        item5.price = 90
        item5.details = " Game khelte mon chai"
        let picture5 = Image(context: context!)
        picture5.image = UIImage(named: "uncharted-4-a-thiefs-end.jpg")
        item5.toImage = picture5
        
        
        ad?.saveContext()
    }
}

