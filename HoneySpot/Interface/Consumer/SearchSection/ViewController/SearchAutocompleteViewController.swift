//
//  SearchAutocompleteViewController.swift
//  HoneySpot
//
//  Created by Max on 2/22/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit

class SearchAutocompleteViewController: UIViewController {
    
    var onItemSelection: ((Int) -> Void)?
    var dataSource:[Any] = [] // SearchIndex
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    
    func updateData(_ entries: [Any], searchTerm: String) {
        titleLabel.text = searchTerm
        dataSource.removeAll()
        dataSource += entries
        tableView.reloadData()
    }

    func optimumSize() -> CGSize {
        return CGSize(width: 300, height: 45 * dataSource.count + 55)
    }
}

extension SearchAutocompleteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchAutocompleteTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "SearchAutocompleteTableViewCell", for: indexPath) as! SearchAutocompleteTableViewCell
        cell.data = self.dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let onItemSelection = self.onItemSelection {
            onItemSelection(indexPath.row)
        }
    }
    
}
