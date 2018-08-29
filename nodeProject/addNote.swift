//
//  addNote.swift
//  nodeProject
//
//  Created by Вадим Пустовойтов on 11.08.2018.
//  Copyright © 2018 Вадим Пустовойтов. All rights reserved.
//

import UIKit

//Review: Code-style (https://github.com/raywenderlich/swift-style-guide) - Классы с заглавной буквы. Для наследников от Cocoa-классов имя должно заканчиваться на базовый класс. Т.е. AddNoteViewController
class addNote: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, ImageViewCellDelegate {
    
    //Review: Должны быть private, должны быть в MARK секции (код контроллера на несколько страниц)
    @IBOutlet weak var nameNoteText: UITextField!
    @IBOutlet weak var infoNoteText: UITextView!
    //Review: Опечатка
    @IBOutlet weak var colleectionViewImages: UICollectionView!
    @IBOutlet weak var begDateText: UITextField!
    @IBOutlet weak var updateDateText: UITextField!
    
    //Review: Те поля что дальше должны быть собраны в модель заметки, инициализированной по умолчанию, чтобы не захламлять контроллер и оперировать уже этой моделью
    
    //Review: Должны быть приватными хотя бы сеттеры - private (set)
    var names = [Nodes]()
    var picturesNode = [Pictures]()
    //Review: Code-style, именование переменных
    var titl :String = ""
    var info = ""
    //Review: Должен быть enum тип
    var type = 0
    //Review: Зачем пустое изображение?, пусть будет неинициализировано
    var picture = UIImage() //
    let imagePicker =  UIImagePickerController()
    var arrayImage: [UIImage] = [UIImage]()
    //Review: Делегаты должны храниться по weak ссылкам (https://medium.com/@JoyceMatos/arc-strong-and-weak-references-in-swift-f2a085a17119, https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html)
    /* weak */ var delegate: addNoteDelegate? = nil
    
    //Review: Должен быть Bool тип
    var isEdit = 0
    
    
    //Review: методы которые используются только кнутри класса должны быть private
    @IBAction func saveNote(_ sender: Any) {
        //Review: не стоит использовать force cast (!), лучше заменить на (nameNoteText.text ?? "")
        self.saveName(name: nameNoteText.text!, info: infoNoteText.text, pictures: arrayImage)
        delegate?.updateTable()
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Review: Хоть что-то кинуть в NSLog в обратном случае
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

    //Review: Ненужный код
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveName(name: String, info: String, pictures: [UIImage]) {
        //Review: Работу с базой данных надо выносить в отдельный класс
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let node = Nodes(entity: Nodes.entity(), insertInto: context)
        let pictureSave = Pictures(entity: Pictures.entity(), insertInto: context)
        
        node.setValue(name, forKey: "name")
        node.setValue(info, forKey: "info")
        //Review: Code-style
        if isEdit == 0
        {
         node.setValue(NSDate(), forKey: "begDate")
        }
        else
        {
         node.setValue(NSDate(), forKey: "updateDate")
        }
     
//        let pictureCount = pictures.count // цикл по колличеству картинок если разберусь с таблицей!!!
        
        //Review: Лучше так
        /*
        for picture in pictures {
            let pictureN = UIImageJPEGRepresentation(picture, 0.0)
            pictureSave.setValue(pictureN, forKey: "picture")
            node.addToPicturesN(pictureSave)
        }
        */
        if( pictures.count > 0 ) {
            for index in 0...pictures.count - 1 {
                let pictureN = UIImageJPEGRepresentation(pictures[index], 0.0)
                pictureSave.setValue(pictureN, forKey: "picture")
                node.addToPicturesN(pictureSave)
            }
        }
 
        do {
            try context.save()
            picturesNode.append(pictureSave)
            names.append(node)
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    //Review: Плохо выделять функцию ради одной строчки
    func presentImagePicker() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func setup(){
        nameNoteText.text = titl
        infoNoteText.text = info
     //   arrayImage.append(picture)
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
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if( indexPath.row == arrayImage.count) {
            presentImagePicker()
        }
        //Review: Добавить сюда снятие выделения
        //collectionView.deselectItem(at: indexPath, animated: false)
    }
    
    //Review: Зачем на Deselect?
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if( indexPath.row == arrayImage.count) {
            presentImagePicker()
        }
    }
}
//Review: Если не получается вынести иточник данных и делегат в отдельный класс (хотя в этом случае можно было бы), то лучше делать вот так:
/*
 extension addNote: UICollectionViewDelegate {
    ...
}
 */



protocol addNoteDelegate {
    func updateTable()
}
