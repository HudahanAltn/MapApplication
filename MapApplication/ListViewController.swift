//
//  ListViewController.swift
//  MapApplication
//
//  Created by Hüdahan Altun on 17.12.2022.
//

import UIKit
import CoreData

class ListViewController: UIViewController {

    @IBOutlet weak var tableViewList: UITableView!
    
    var nameArray = [String] ()
    var idArray = [UUID] ()
    
    //created to get name and ıd from place table in coredata
    var choosenName:String?
    var choosenID:UUID?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //connected protocol
        tableViewList.delegate = self
        tableViewList.dataSource = self
        
        //add button on nav bar
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
              
        
        
        
        fetchData()// fetched data
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toMap"{
            
            let destinationVC = segue.destination as! MapsViewController
            
            destinationVC.choosenPlaceName = choosenName
            destinationVC.choosenPlaceID = choosenID
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: NSNotification.Name("newPlaceCreated"), object: nil) // we added observer because when user add new place it will show on table view
        
        tableViewList.reloadData()
        
        
    }
    

    @objc func addButtonPressed(){
        
        choosenName = "" // if  any cliked on table  view cell
        performSegue(withIdentifier: "toMap", sender: nil)
    }
                  
    
    @objc func fetchData(){
        
        let AppDelegatee = UIApplication.shared.delegate as! AppDelegate //core data
        let contextt = AppDelegatee.persistentContainer.viewContext // coredata access
        
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Place")//create request from place table
        
        request.returnsDistinctResults = false
        
        do{
            
            let results = try contextt.fetch(request) //transfer fetch resul to resul variable
            
            if results.count > 0 {
                
                //clear array
                nameArray.removeAll(keepingCapacity: false)
                idArray.removeAll(keepingCapacity: false)
                
                
                
                for i in results as! [NSManagedObject]{
                    
                    
                    if let name = i.value(forKey: "name") as? String{
                        
                        nameArray.append(name)
                        
                    }
                    if let id = i.value(forKey: "id") as? UUID{
                        
                        idArray.append(id)
                    }
                    
                }
                
                tableViewList.reloadData()
            }
        }
        catch{
            
            print("Error!. could not fetched any data")
        }
        
    }
                                                                                    
}

extension ListViewController:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as! TableViewCellList
        
        cell.listLabel.text = "\(nameArray[indexPath.row])"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        choosenName = nameArray[indexPath.row]
        choosenID = idArray[indexPath.row]
        performSegue(withIdentifier: "toMap", sender: nil)
    }
}
