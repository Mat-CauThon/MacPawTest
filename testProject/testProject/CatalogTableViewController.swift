//
//  AppDelegate.swift
//  testProject
//
//  Created by Roman Mishchenko on 11.04.2018.
//  Copyright © 2018 Roman Mishchenko. All rights reserved.
//

import UIKit
import CoreData

class FilmsTableViewCell: UITableViewCell
{
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var filmImageView: UIImageView!
}

class CatalogTableViewController: UITableViewController
{

    var filmsArray = [Film]()
    var modelController: ModelController!
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        tableView.estimatedRowHeight = 150
       
            let fetchRequest: NSFetchRequest<Film> = Film.fetchRequest()
           var index = 0
            do
            {
               
                let films = try PersistentService.context.fetch(fetchRequest)
                self.filmsArray = films
                modelController.quote.index.append(index)
                index += 1
                self.tableView.reloadData()
           
            } catch{}
            modelController.quote.filmsArray = filmsArray
        
        tableView.reloadData()
        
    }
    
    
    @IBAction func addNewFilmButtonAction(_ sender: Any)
    {
        let alert = UIAlertController(title: "AddFild", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Title"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Genre"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Year"
            textField.keyboardType = .numberPad
        }
        
        let action  = UIAlertAction(title: "Add", style: .default)
        { (_) in
                    var title = alert.textFields!.first!.text!
                    var year = alert.textFields!.last!.text!
                    var genre = alert.textFields!.first(where: { (textField) -> Bool in
                                textField.placeholder == "Genre"
                            })!.text!
            
            let nsTitle = title as NSString
            if nsTitle.length >= 20
            {
                title = nsTitle.substring(with: NSRange(location: 0, length: nsTitle.length > 20 ? 20 : nsTitle.length))
            }
            let nsGenre = genre as NSString
            if nsGenre.length > 40
            {
                genre = nsGenre.substring(with: NSRange(location: 0, length: nsGenre.length > 40 ? 40 : nsGenre.length))
            }
            let nsYear = year as NSString
            if nsYear.length > 4
            {
                year = nsYear.substring(with: NSRange(location: 0, length: nsYear.length > 4 ? 4 : nsYear.length))
            }
            genre = genre.replacingOccurrences(of: ", ", with: ",\n")
            if(title != "" && genre != "" && year != "")
            {
                    let film = Film(context: PersistentService.context)
                    film.genre = genre + " "
                    film.year = Int16(year)!
                    film.title = title + " "
                    film.poster = UIImagePNGRepresentation(UIImage(named: "InL.png")!) as NSData?
                    PersistentService.saveContext()
                    self.filmsArray.append(film)
                    self.modelController.quote.filmsArray = self.filmsArray
            }
                    self.tableView.reloadData()
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .default)
        { (_) in
                 print("Canceled1")
        }
      
        alert.addAction(action)
        alert.addAction(actionCancel)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return filmsArray.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let moc = PersistentService.context
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Film")
            let result = try? moc.fetch(fetchRequest)
            let resultData = result as! [Film]
            var i = 0
            for object in resultData
            {
                if i == indexPath.row
                {
                    moc.delete(object)
                }
                i += 1
            }
            do {
                try moc.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {}
            
            filmsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            modelController.quote.filmsArray = filmsArray
            
        }
        else if editingStyle == .insert
        {

        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! FilmsTableViewCell
       
            let film = filmsArray[indexPath.row]
            cell.label?.text = "\n\(film.title!)\nYear: \(film.year)\nGenre: \(film.genre!)"
           
            if(filmsArray[indexPath.row].poster != nil)
            {
                cell.filmImageView?.image = UIImage(data: filmsArray[indexPath.row].poster! as Data)
            }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if let newViewController = segue.destination as? InfoViewController
        {
            newViewController.number = tableView.indexPathForSelectedRow?.row
            newViewController.modelController = modelController
        }
        else if let newViewController = segue.destination as? SearchTableViewController
        {
            newViewController.modelController = modelController
        }
    }

}
