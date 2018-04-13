//
//  EditViewController.swift
//  testProject
//
//  Created by Roman Mishchenko on 11.04.2018.
//  Copyright © 2018 Roman Mishchenko. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var infoView: UILabel!
    @IBOutlet weak var yearView: UILabel!
    @IBOutlet weak var genreView: UILabel!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var posteImageView: UIImageView!
    var modelController: ModelController!
    var number: Int?
 
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        let quote = modelController.quote
       
        titleView.text = quote.filmsArray[number!].title
        genreView.text = "Genre: \(quote.filmsArray[number!].genre!)"
        yearView.text = "Year: \(quote.filmsArray[number!].year)"
        if(quote.filmsArray[number!].poster != nil)
        {
            posteImageView.image = UIImage(data: quote.filmsArray[number!].poster! as Data)
        }
        if(quote.filmsArray[number!].info != nil)
        {
            infoView.text = quote.filmsArray[number!].info
        }
    }
    @IBOutlet weak var buttonBack: UIButton!
    @IBAction func buttonBackAction(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if let newViewController = segue.destination as? EditViewController
        {
            newViewController.number = number!
            newViewController.modelController = modelController
        }
    }
    

    

}
