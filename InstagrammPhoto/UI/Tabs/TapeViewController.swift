//
//  TapeViewController.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 11/17/20.
//  Copyright © 2020 Maksim Velich. All rights reserved.
//

import UIKit
import Alamofire

class TapeViewController: UIViewController {
    @IBOutlet weak var tapeTableView: UITableView!
    
    let identifier = "myCell"
    let dataArray = ["1", "2", "3", "4", "5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapeTableView.dataSource = self
        tapeTableView.delegate = self
    }
    
}

extension TapeViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let number = dataArray[indexPath.row]
        cell.textLabel?.text = number
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 700
    }
    
    // MARK: UITableViewDelegate
}
