//
//  PasswordTableViewController.swift
//  PassVault
//
//  Created by Kly Yee on 10/4/21.
//

import UIKit

class PasswordTableViewController: UITableViewController, UISearchBarDelegate {
    
    static var passwords: [[String]] = [
    ]
    
    static var website = ""
    static var login = ""
    
    var filteredData: [[String]] = [
    ]
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parse_file()
        searchBar.delegate = self
        searchBar.placeholder = "Tap here to search"
        
    }

    // MARK: - Table view data source

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier")

            if cell == nil {
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellIdentifier")
            }

        cell!.textLabel?.text = filteredData[indexPath.row][0]
        cell!.detailTextLabel?.text = filteredData[indexPath.row][1]

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let storyboard = UIStoryboard(name: "Index", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PasswordPopUp") as UIViewController
        vc.view.isOpaque = false
        vc.view.backgroundColor = nil
        PasswordTableViewController.website = filteredData[indexPath.row][0]
        PasswordTableViewController.login = filteredData[indexPath.row][1]
        vc.viewDidLoad()
        present(vc, animated: false, completion: nil)

    }
    
    
    func parse_file() {
        let file = "passwordList.txt" //this is the file. we will write to and read from it

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = dir.appendingPathComponent(file)

            //reading
            
            PasswordTableViewController.passwords.removeAll()
            do {
                let entry = try String(contentsOf: fileURL, encoding: .utf8)
                var entryArray = entry.split(separator: "\n")
                entryArray.sort()
                
                for line in entryArray{
                    let singleEntry = line.split(separator: " ")
                    PasswordTableViewController.passwords.append([String(singleEntry[0]), String(singleEntry[1])])
                }
                filteredData = PasswordTableViewController.passwords
                
            }
            catch {
                // do nothing
            }
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            // When there is no text, filteredData is the same as the original data
            // When user has entered text into the search box
            // Use the filter method to iterate over all items in the data array
            // For each item, return true if the item should be included and false if the
            // item should NOT be included
        filteredData.removeAll()
        for entry in PasswordTableViewController.passwords {
            if (searchText.lowercased() == entry[0].lowercased()) {
                filteredData.append(entry)
            } else if (searchText.isEmpty) {
                filteredData.append(entry)
            }
        }
            
            tableView.reloadData()
        }
    
}


