//
//  EditViewController.swift
//  testProject
//
//  Created by Roman Mishchenko on 11.04.2018.
//  Copyright © 2018 Roman Mishchenko. All rights reserved.
//

import UIKit
import CoreData
class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var yearEdit: UITextField!
    @IBOutlet weak var infoEdit: UITextView!
    @IBOutlet weak var genreEdit: UITextField!
    @IBOutlet weak var titleEdit: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imageFromDevice = info[UIImagePickerControllerOriginalImage] as! UIImage // 1
        imageView.image = imageFromDevice // 2
        self.dismiss(animated: true, completion: nil) // 3
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    var modelController: ModelController!
    var number: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let quote = modelController.quote
        if(quote.filmsArray[number!].poster != nil)
        {
            imageView.image = UIImage(data: quote.filmsArray[number!].poster! as Data)
        }
        genreEdit.text = quote.filmsArray[number!].genre
        titleEdit.text = quote.filmsArray[number!].title
        yearEdit.text = String(quote.filmsArray[number!].year)
        if(quote.filmsArray[number!].info != nil)
        {
            infoEdit.text = quote.filmsArray[number!].info
        }
    }

    
    @IBAction func chooseFotoButtonAction(_ sender: Any)
    {
        let imagePicker = UIImagePickerController() // 1
        imagePicker.delegate = self // 2
        self.present(imagePicker, animated: true, completion: nil) // 3
    }
    
    @IBAction func saveButtonAction(_ sender: Any)
    {
        var newQuote = Quote(filmsArray: modelController.quote.filmsArray, index: modelController.quote.index)
        if(infoEdit.text != "")
        {
            newQuote.filmsArray[number!].info = infoEdit.text
        }
        if(titleEdit.text != "")
        {
            newQuote.filmsArray[number!].title = titleEdit.text
        }
        if(genreEdit.text != "")
        {
            newQuote.filmsArray[number!].genre = genreEdit.text
        }
        if(yearEdit.text != "")
        {
            newQuote.filmsArray[number!].year = Int16(yearEdit.text!)!
        }
        
        let nsTitle = titleEdit.text! as NSString
        if nsTitle.length >= 20
        {
            titleEdit.text = nsTitle.substring(with: NSRange(location: 0, length: nsTitle.length > 20 ? 20 : nsTitle.length))
        }
        let nsGenre = genreEdit.text! as NSString
        if nsGenre.length > 40
        {
            genreEdit.text = nsGenre.substring(with: NSRange(location: 0, length: nsGenre.length > 40 ? 40 : nsGenre.length))
        }
        let nsYear = yearEdit.text! as NSString
        if nsYear.length > 4
        {
            yearEdit.text = nsYear.substring(with: NSRange(location: 0, length: nsYear.length > 4 ? 4 : nsYear.length))
        }
        genreEdit.text = genreEdit.text?.replacingOccurrences(of: ", ", with: ",\n")
        
        newQuote.filmsArray[number!].poster = UIImagePNGRepresentation(imageView.image!) as NSData?
        PersistentService.saveContext()
        
        dismiss(animated: true, completion: nil)
    }
   

}
