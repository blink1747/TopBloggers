//
//  TableTableViewController.swift
//  TopBloggers
//
//  Created by IMCS on 8/15/19.
//  Copyright © 2019 IMCS. All rights reserved.
//

import UIKit
import CoreData

import Foundation
import SystemConfiguration

struct  BlogStruct {
    var title : String
    var content : String
    var url : String
    init() {
        title = ""
        content = ""
        url = ""
    }
}

class TableTableViewController: UITableViewController {
    
    
    var BlogArray = [BlogStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateTableCells()
        
    }
    func populateTableCells() {
        let str = "https://www.googleapis.com/blogger/v3/blogs/2399953/posts?key=AIzaSyCrrMwzVeV2Br8VpLiS0cZwrXaK4ImpYlI".replacingOccurrences(of: " ", with: "+")
        
        
        let url = URL(string: str )
        if isInternetAvailable()
        {
            
            let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if error == nil {
                    if let unWrappedData = data {
                        do {
                            let jsonResult = try JSONSerialization.jsonObject(with: unWrappedData, options : JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                            
                            
                            let items = jsonResult?["items"] as! NSArray
                            
                            //let titleArray : [String] = []
                            
                            for i in 0...items.count-1 {
                                let item = items[i] as! NSDictionary
                                var Blog = BlogStruct()
                                Blog.title = item["title"] as! String
                                Blog.url = item["url"] as! String
                                Blog.content = item["content"] as! String
                                self.BlogArray.append(Blog)
                                
                                
                                let flag = UserDefaults.standard.value(forKey: "AlreadyOpened?") as? Bool
                                
                                if flag == nil {
                                    self.saveArray(Blog)
                                }
                                
                                
                                
                            }
                            
                            UserDefaults.standard.set(true, forKey: "AlreadyOpened?")
                            
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                            
                            // print(titleArray)
                            //  self.saveArray(titleArray)
                            
                            /*
                             if jsonResult!["weather"] != nil {
                             
                             let weather = jsonResult?["weather"] as? NSArray
                             let weatherItem = weather?[0] as? NSDictionary
                             var description = weatherItem!["description"] as! String
                             DispatchQueue.main.async {
                             print(description)
                             }
                             } else jsonResult!["message"] != nil {
                             
                             DispatchQueue.main.async {
                             let message = jsonResult?["message"] as! String
                             print(message)
                             }
                             }
                             */
                        } catch {
                            print("Error fetching API Data")
                            
                        }
                        
                    }
                }
                
            }
            task.resume()
        }
        else {
            fetch()
        }
    }
    
    func fetch () {
        
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Blog")
        
        //3
        do {
            if  let blogsFetched : [NSManagedObject] = try managedContext.fetch(fetchRequest)
            {
                //  print(blogsFetched[0].value(forKeyPath: "content")!)
                
                
                for blog in blogsFetched {
                    var Blog = BlogStruct()
                    Blog.title = blog.value(forKeyPath: "title") as! String
                    Blog.url = blog.value(forKeyPath: "url") as! String
                    Blog.content = blog.value(forKeyPath: "url") as! String
                    BlogArray.append(Blog)
                  
                    
                    
                }
            }
            
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    // MARK: - Table view data source
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return BlogArray.count
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return BlogArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellsforTitle", for: indexPath)
        //Configure the cell...
        cell.textLabel?.text = BlogArray[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Segue to the second view controller
        self.performSegue(withIdentifier: "segueToWebview", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // get a reference to the second view controller
        let viewController = segue.destination as! ViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            let selectedRow = indexPath.row
            viewController.receiveBlog = BlogArray[selectedRow]
            
        }
        
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func saveArray(_ Blog: BlogStruct ) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Blog",
                                       in: managedContext)!
        
        let blog = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
        
        // 3
        blog.setValue(Blog.title, forKeyPath: "title")
        blog.setValue(Blog.url, forKeyPath: "url")
        // blog.setValue(Blog.url, forKeyPath: "content")
        
        // 4
        do {
            try managedContext.save()
         
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        //   print(isReachable && !needsConnection)
        return (isReachable && !needsConnection)
    }
}
