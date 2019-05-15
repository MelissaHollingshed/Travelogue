//
//  EntriesViewController.swift
//  Travelogue
//
//  Created by Melissa Hollingshed on 4/29/19.
//  Copyright © 2019 Melissa Hollingshed. All rights reserved.
//

import UIKit
import CoreData

class EntriesViewController: UITableViewController {

    var trip : Trip?
    var entries : [Entry]?
    var dateFormatter = DateFormatter()
    
    @IBOutlet var entriesTableView: UITableView!
    @IBOutlet weak var addEntry: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.timeStyle = .long
        dateFormatter.dateStyle = .long
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        /*
         //not sure that this actually makes sense or that I need it 
         guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<Entry> = Entry.fetchRequest()
        do{
            entries = try managedContext.fetch(fetchRequest)
        
        }catch{
            print("Could not fetch categories")
        }
        */
        entriesTableView.reloadData()
        //print(trip?.entries?.count)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print( trip?.entries?.count ?? 0)
        return trip?.entries?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = entriesTableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
        if let entry = trip?.entries?[indexPath.row]{
            cell.textLabel?.text = entry.entryTitle
        }
        return cell
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func addEntryPressed(_ sender: Any) {
        performSegue(withIdentifier: "newEntrySegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? SingleEntryViewController
            else{
                print("returning early")
                return
        }
        
        if let selectedRow = self.entriesTableView.indexPathForSelectedRow?.row {
            destination.entry = trip?.entries?[selectedRow]
        }
        
        destination.trip = trip
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteEntry(at: indexPath)
        }
    }
    
    func deleteEntry(at indexPath: IndexPath){
        guard let entry = trip?.entries?[indexPath.row], let managedContext = entry.managedObjectContext else{
            return
        }
        managedContext.delete(entry)
        do{
            try managedContext.save()
            entriesTableView.deleteRows(at: [indexPath], with: .automatic)
        }catch{
            print("Entry could not be deleted")
            entriesTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    
        
    }
    
}
