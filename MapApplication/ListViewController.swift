//
//  ListViewController.swift
//  MapApplication
//
//  Created by Hüdahan Altun on 17.12.2022.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var tableViewList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableViewList.delegate = self
        tableViewList.dataSource = self
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
                                                                                          
    }
    

    @objc func addButtonPressed(){
        
        performSegue(withIdentifier: "toMap", sender: nil)
    }
                                                                                          
                                                                                    
}

extension ListViewController:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as! TableViewCellList
        
        cell.listLabel.text = "test"
        
        return cell
    }
}
