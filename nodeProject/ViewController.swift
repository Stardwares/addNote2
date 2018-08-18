//
//  ViewController.swift
//  nodeProject
//
//  Created by Вадим Пустовойтов on 11.08.2018.
//  Copyright © 2018 Вадим Пустовойтов. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBAction func addNoteForm(_ sender: Any) {
        let vc2 = storyboard?.instantiateViewController(withIdentifier: "addNoteSID") as! addNote
        
        navigationController?.pushViewController(vc2, animated: true)
    }
    @IBOutlet weak var tableView: UITableView!
    
    var names = [Nodes]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\"The List\""
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        let node = names[indexPath.row]
        
        cell!.textLabel!.text = node.value(forKey: "name") as? String
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc2 = storyboard?.instantiateViewController(withIdentifier: "addNoteSID") as! addNote

     
        navigationController?.pushViewController(vc2, animated: true)
        vc2.titl = names[indexPath.row].name!
        vc2.info = names[indexPath.row].info!
        vc2.picture = UIImage(data: names[indexPath.row].picture!)!
        vc2.type = 1
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if editingStyle == .delete {
           // self.tableView.setEditing(true, animated: true)
            context.delete(names[indexPath.row])
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            do {
                names = try context.fetch(Nodes.fetchRequest())
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
            
            tableView.reloadData()
        }
    }

    @IBAction func addNotes(_ sender: Any) {
        
        let alert = UIAlertController(title: "New name", message: "Enter a new name", preferredStyle: UIAlertControllerStyle.alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            let textField = alert.textFields?.first
            self.saveName(name: textField!.text!)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField(configurationHandler: nil)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveName(name: String){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let node = Nodes(entity: Nodes.entity(), insertInto: context)
        
        node.setValue(name, forKey: "name")
        
        do {
            try context.save()
            names.append(node)
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            let result = try context.fetch(Nodes.fetchRequest())
            names = result as![Nodes]
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

