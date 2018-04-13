//
//  SearchTableViewController.swift
//  testProject
//
//  Created by Roman Mishchenko on 12.04.2018.
//  Copyright © 2018 Roman Mishchenko. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    var modelController: ModelController!
    var filmsController: ModelController!
    var quote: Quote!
    var films: [Film] = []
    var globalNumber: Int = 0
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        tableView.estimatedRowHeight = 150
        
        
        self.filmsController = modelController
      
        quote = modelController.quote
        globalNumber = quote.filmsArray.count - 1
        films = quote.filmsArray
        tableView.reloadData()
    }
    
    @IBOutlet weak var whereSearch: UITextField!
    @IBOutlet weak var whatSearch: UITextField!
    
    @IBAction func searchButtonAction(_ sender: Any)
    {
        print(self.quote.filmsArray)
        var filmsArrayOld = self.quote.filmsArray
        print(filmsArrayOld.count)
        self.films = []
        var number = globalNumber
        if((self.whereSearch?.text?.lowercased().range(of: "genre")) != nil)
        {
            for i in 0...number
            {
                if(filmsArrayOld[i].genre?.lowercased().range(of: self.whatSearch.text!) == nil)
                {
                    filmsArrayOld[i].searchBool = false
                }
            }
        }
        else if ((whereSearch?.text?.lowercased().range(of: "title")) != nil)
        {
            for i in 0...number
            {
                if(filmsArrayOld[i].title?.lowercased().range(of: self.whatSearch.text!) == nil)
                {
                    filmsArrayOld[i].searchBool = false
                }
            }
        }
        else if ((self.whereSearch?.text?.lowercased().range(of: "year")) != nil)
        {
            for i in 0...number
            {
                if(filmsArrayOld[i].year != Int16(self.whatSearch.text!))
                {
                    filmsArrayOld[i].searchBool = false
                }
            }
        }
        else if ((self.whereSearch?.text?.lowercased().range(of: "info")) != nil)
        {
            for i in 0...number
            {
                if(filmsArrayOld[i].info?.lowercased().range(of: self.whatSearch.text!) == nil)
                {
                    filmsArrayOld[i].searchBool = false
                }
            }
        }
            
        else if (self.whereSearch?.text! == "")
        {
            for i in 0...number
            {
                if( filmsArrayOld[i].info?.lowercased().range(of: self.whatSearch.text!) == nil && filmsArrayOld[i].year != Int16(self.whatSearch.text!) && filmsArrayOld[i].title?.lowercased().range(of: self.whatSearch.text!) == nil && filmsArrayOld[i].genre?.lowercased().range(of: self.whatSearch.text!) == nil)
                {
                    filmsArrayOld[i].searchBool = false
                }
            }
        }
        
        var filmsArray: [Film]
        if(self.whatSearch?.text! == "")
        {
            filmsArray = self.quote.filmsArray
        }
        else
        {
            filmsArray = []
        }
        for i in 0...number
        {
            if(filmsArrayOld[i].searchBool)
            {
                filmsArray.append(filmsArrayOld[i])
            }
            else
            {
                filmsArrayOld[i].searchBool = true
            }
        }
        number = globalNumber
        filmsArrayOld = filmsArray
        self.films = filmsArrayOld
        self.filmsController.quote.filmsArray = filmsArrayOld
        tableView.reloadData()
        
    }
    
    @IBAction func undoButtonAction(_ sender: Any)
    {
        modelController = nil
        dismiss(animated: true, completion: nil)
    }
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return films.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! FilmsTableViewCell
        
            let film = films[indexPath.row]
            cell.label?.text = "\n\(film.title!)\nYear: \(film.year)\nGenre: \(film.genre!)"
        
            if(films[indexPath.row].poster != nil)
            {
                cell.filmImageView?.image = UIImage(data: films[indexPath.row].poster! as Data)
            }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if let newViewController = segue.destination as? InfoViewController
        {
            newViewController.number = tableView.indexPathForSelectedRow?.row
            newViewController.modelController = filmsController
        }
        
    }
    
    
    
}
