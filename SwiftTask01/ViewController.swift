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
    
    @IBOutlet var tableView:UITableView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
        //Alamofire
        Alamofire.request("https://kiroru-inc.jp/share/scc2018/countries.json")
            .responseJSON{res in
                guard let json = res.data else {
                    return
                }
                
                self.items = try! JSONDecoder().decode(Array<Item>.self, from: json)
                
                //Debug
                print("--- Item JSON ---")
                print(JSON(json))
                print("--- Item Info ---")
                for item in self.items {
                    print("imageUrl:" + item.imageUrl)
                    print("jname:" + item.jname)
                    print("ename:" + item.ename)
                }
                
                self.tableView?.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell")
        let item = self.items[indexPath.row]
        
        let iv = cell?.viewWithTag(1) as! UIImageView
        iv.sd_setImage(with: URL(string: item.imageUrl)!)
        
        let tv1 = cell?.viewWithTag(2) as? UILabel
        tv1?.text = item.jname

        let tv2 = cell?.viewWithTag(3) as? UILabel
        tv2?.text = item.ename

        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
        let actionSheet : UIAlertController = UIAlertController(title: nil, message: "\(item.jname)が押されました。", preferredStyle: UIAlertControllerStyle.actionSheet)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) -> Void in
            print("\(item.ename)displayed!")
            })
        actionSheet.addAction(defaultAction)
        present(actionSheet, animated: true, completion: nil)
    }
}
