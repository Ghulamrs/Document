//
//  ListViewController.swift
//  Document
//
//  Created by Home on 5/11/19.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

extension FileManager {
    func urls(for directory: FileManager.SearchPathDirectory, skipsHiddenFiles: Bool = true ) -> [URL]? {
        let documentsURL = urls(for: directory, in: .userDomainMask)[0]
        let fileURLs = try? contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: skipsHiddenFiles ? .skipsHiddenFiles : [] )
        return fileURLs
    }
}

class ListViewController: UITableViewController {
    var itemsList: NSMutableArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.isEditing = true
        // Do any additional setup after loading the view.
        //navigationController?.navigationBar.prefersLargeTitles = true
        //let searchController = UISearchController(searchResultsController: nil)
        //navigationItem.searchController = searchController
        //navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        itemsList.removeAllObjects()
        let list:[URL] = FileManager.default.urls(for: .documentDirectory)!
        for index in list.indices {
            let name = list[index].lastPathComponent
            if(!itemsList.contains(name)) {
                itemsList.add(name)
            }
        }
        self.tableView.reloadData()
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showVC2") {
            let selectIndex: NSIndexPath = self.tableView.indexPathForSelectedRow! as NSIndexPath
            let vc2: ViewController2 = segue.destination as! ViewController2
            vc2.title = itemsList.object(at: selectIndex.row) as? String
        }
    }
 
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("Rows: \(itemsList.count)")
        return itemsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        
        let item: String = itemsList.object(at: indexPath.row) as! String
        cell.textLabel?.text = item

        return cell
    }
/*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if  cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        }
     
        let item: String = itemsList.object(at: indexPath.row) as! String
        cell!.textLabel?.text = item     
        return cell!
    }
*/
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {return}
        
        itemsList.removeObject(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
