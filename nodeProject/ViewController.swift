//
//  ViewController.swift
//  nodeProject
//
//  Created by Вадим Пустовойтов on 11.08.2018.
//  Copyright © 2018 Вадим Пустовойтов. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, addNoteDelegate {

    @IBAction func addNoteForm(_ sender: Any) {
        let vc2 = storyboard?.instantiateViewController(withIdentifier: "addNoteSID") as! addNote
        vc2.delegate = self
        navigationController?.pushViewController(vc2, animated: true)
    }
    @IBAction func deleteAll(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        for name in names {
            context.delete(name)
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        do {
            names = try context.fetch(Nodes.fetchRequest())
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        tableView.reloadData()
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
        vc2.info = (names[indexPath.row].info)!
        let adv: Int = (names[indexPath.row].picturesN?.count)!
        for index in 0...adv {
            vc2.arrayImage.append(UIImage(data: names[indexPath.row].picturesN?.allObjects[index] as! Data)!)
        }
        vc2.type = 1
        vc2.isEdit = 1
        vc2.delegate = self
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        readData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTable() {
        
        readData()
        tableView.reloadData()
        
    }
    
    func readData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            let result = try context.fetch(Nodes.fetchRequest())
            names = result as![Nodes]
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
}

