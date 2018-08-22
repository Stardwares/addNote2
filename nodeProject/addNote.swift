//
//  addNote.swift
//  nodeProject
//
//  Created by Вадим Пустовойтов on 11.08.2018.
//  Copyright © 2018 Вадим Пустовойтов. All rights reserved.
//

import UIKit

class addNote: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, ImageViewCellDelegate {
    
    @IBOutlet weak var nameNoteText: UITextField!
    @IBOutlet weak var infoNoteText: UITextView!
    @IBOutlet weak var colleectionViewImages: UICollectionView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var begDateLabel: UILabel!
    @IBOutlet weak var updateDateLabel: UILabel!
    
    var names = [Nodes]()
    var indexNode :Int = 0
    var picturesNode = [Pictures]()
    var titl :String = ""
    var info = ""
    var type = 0
    var picture = UIImage()
    let imagePicker =  UIImagePickerController()
    var arrayImage: [UIImage] = [UIImage]()
    var delegate: addNoteDelegate? = nil
    var isEdit :Int = 0
    var begDateString :String = "None"
    var updateDateString :String = "None"
    
    @IBAction func saveNote(_ sender: Any) {
        self.saveName(name: nameNoteText.text!, info: infoNoteText.text, pictures: arrayImage)
        delegate?.updateTable()
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveName(name: String, info: String, pictures: [UIImage]){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let node = Nodes(entity: Nodes.entity(), insertInto: context)
        
     //   let pictureSave = Pictures(entity: Pictures.entity(), insertInto: context)
        if isEdit == 0
        {
            node.setValue(name, forKey: "name")
            node.setValue(info, forKey: "info")
            node.setValue(NSDate(), forKey: "begDate")
        }
        else
        {   names[indexNode].name = name
            names[indexNode].info = info
            names[indexNode].updateDate = NSDate() as Date
            names[indexNode].picturesN = nil
        }
     
//        let pictureCount = pictures.count // цикл по колличеству картинок если разберусь с таблицей!!!
        if( pictures.count > 0 ) {
            for index in 0...pictures.count - 1 {
                let context1 = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                let pictureSave = Pictures(entity: Pictures.entity(), insertInto: context1)
                let pictureN = UIImageJPEGRepresentation(pictures[index], 0.0)
                pictureSave.setValue(pictureN, forKey: "picture")
                if isEdit == 1 {
                names[indexNode].addToPicturesN(pictureSave)
                }
                else
                {
                node.addToPicturesN(pictureSave)
                }
                do {
                    try context1.save()
                        picturesNode.append(pictureSave)
                    
                } catch let error as NSError {
                    print("Could not save \(error), \(error.userInfo)")
                }
                
            }
        }
        if isEdit == 0 {
            do {
                try context.save()
                   names.append(node)
                
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
    
    func presentImagePicker() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func setup(){
        nameNoteText.text = names[indexNode].name
        infoNoteText.text = names[indexNode].info
        begDateLabel.text = begDateString
        updateDateLabel.text = updateDateString
        if isEdit == 1 {
            label1.isHidden = false
            label2.isHidden = false
            begDateLabel.isHidden = false
            updateDateLabel.isHidden = false
        }
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayImage.count + 1
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell" , for: indexPath as IndexPath) as! ImageViewCell
        if( indexPath.row != arrayImage.count)  {
            cell.index = indexPath.row
            cell.imageView.image = arrayImage[indexPath.row]
            cell.delegate = self
        } else {
            cell.index = indexPath.row
            cell.imageView.image = nil
        }
        
        return cell
    }
    

}


protocol addNoteDelegate {
    func updateTable()
}
