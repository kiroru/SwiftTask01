//
//  ViewController.swift
//  SwiftTask01
//
//  Created by ueda on 2018/08/29.
//  Copyright © 2018年 kohei.ueda. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

struct Item : Codable {
    let imageUrl : String
    let jname : String
    let ename : String
}


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var items: [Item] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Alamofire
        Alamofire.request("https://kiroru-inc.jp/share/scc2018/countries.json")
            .responseJSON { res in
                guard let json = res.data else {
                    return
                }
                
                do {
                    self.items = try JSONDecoder().decode(Array<Item>.self, from: json)
                } catch let error {
                    print(error.localizedDescription)
                    return
                }

                // Debug
                print("--- Item JSON ---")
                print(JSON(json))
                print("--- Item Info ---")
                for item in self.items {
                    print("imageUrl:" + item.imageUrl)
                    print("jname:" + item.jname)
                    print("ename:" + item.ename)
                }
                
                self.tableView.reloadData()
        }
    }
    
    
    // MARK: - UITableViewDatasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        let item = items[indexPath.row]
        
        let nationalFlagView = cell.viewWithTag(1) as? UIImageView
        nationalFlagView?.sd_setImage(with: URL(string: item.imageUrl)!)
        
        let jnameView = cell.viewWithTag(2) as? UILabel
        jnameView?.text = item.jname

        let enameView = cell.viewWithTag(3) as? UILabel
        enameView?.text = item.ename

        return cell
    }
    

    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
        let sheet = UIAlertController(title: nil, message: "\(item.jname)が押されました。", preferredStyle: UIAlertControllerStyle.actionSheet)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) -> Void in
            print("\(item.ename) displayed!")
        })
        sheet.addAction(action)
        present(sheet, animated: true, completion: nil)
    }
}
