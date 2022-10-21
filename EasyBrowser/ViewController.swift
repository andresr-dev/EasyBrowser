//
//  ViewController.swift
//  EasyBrowser
//
//  Created by Andres camilo Raigoza misas on 20/10/22.
//

import UIKit

class ViewController: UITableViewController {
    let websites = ["apple.com", "hackingwithswift.com", "google.com"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Easy Browser"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        websites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Website", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = websites[indexPath.row]
        content.textProperties.font = .preferredFont(forTextStyle: .headline)
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = navigationController?.storyboard?.instantiateViewController(withIdentifier: "WebView") as? DetailViewController {
            vc.website = websites[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

