//
//  addNote.swift
//  nodeProject
//
//  Created by Вадим Пустовойтов on 11.08.2018.
//  Copyright © 2018 Вадим Пустовойтов. All rights reserved.
//

import UIKit

class addNote: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, ImageViewCellDelegate {
    
    @IBOutlet weak var nameNoteText: UITextField!
    @IBOutlet weak var infoNoteText: UITextView!
    @IBOutlet weak var colleectionViewImages: UICollectionView!
    
    var names = [Nodes]()
    var titl :String = ""
    var info = ""
    var type = 0
    var picture = UIImage()
    
    let imagePicker =  UIImagePickerController()
    
    var arrayImage: [UIImage] = [UIImage]()
    
    @IBAction func saveNote(_ sender: Any) {
        
        self.saveName(name: nameNoteText.text!, info: infoNoteText.text, pictures: arrayImage)
        
        
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if( UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
        }
        
        colleectionViewImages.dataSource = self
        colleectionViewImages.delegate = self
        
        if( type == 1 ) {
            setup()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveName(name: String, info: String, pictures: [UIImage]){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let node = Nodes(entity: Nodes.entity(), insertInto: context)
    //    let picture = Pictures(entity: Pictures.entity(), insertInto: context)
        
        node.setValue(name, forKey: "name")
        node.setValue(info, forKey: "info")
        node.setValue(NSDate(), forKey: "begDate")
        
        let pictureCount = pictures.count // цикл по колличеству картинок если разберусь с таблицей!!!
        
        let picture = UIImageJPEGRepresentation(pictures[0], 0.0)
        
        node.setValue(picture, forKey: "picture")
        
        do {
            try context.save()
            names.append(node)
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    func presentImagePicker() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func removePhoto() {
        
    }
    
    func setup(){
        nameNoteText.text = titl
        infoNoteText.text = info
        arrayImage.append(picture)
        colleectionViewImages.reloadData()
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        
        arrayImage.insert((info[UIImagePickerControllerOriginalImage] as? UIImage)!, at: arrayImage.count)
        
        updateCells()
    }
    
    func updateCells() {
        
        
        colleectionViewImages.reloadData()
    }
    
    func removePhoto(index: NSInteger) {
        if( index != arrayImage.count) {
            arrayImage.remove(at: index)
            updateCells()
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayImage.count + 1
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell" , for: indexPath as IndexPath) as! ImageViewCell
        if( indexPath.row != arrayImage.count)  {
            cell.index = indexPath.row
            cell.imageView.image = arrayImage[indexPath.row]
            cell.delegate = self
            cell.show()
        } else {
            cell.index = indexPath.row
            cell.imageView.image = nil
            cell.hidden()
        }
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        // make cell more visible in our example project
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if( indexPath.row == arrayImage.count) {
            presentImagePicker()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if( indexPath.row == arrayImage.count) {
            presentImagePicker()
        }
    }
    
    

    
   
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
