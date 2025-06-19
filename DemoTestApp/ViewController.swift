//
//  ViewController.swift
//  DemoTestApp
//
//  Created by Dimpy Patel on 19/06/25.
//

//https://fakestoreapi.com/products

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var storeTableView: UITableView!
    
    // MARK: - Variables
    var storeDataArray = [StoreData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialDetails()
    }

    // MARK: - Initial Details
    func initialDetails() {
        self.setUpTableView()
        self.fetchStoreData()
    }
    
    // MARK: - Set Up TableView
    func setUpTableView() {
        self.storeTableView.delegate = self
        self.storeTableView.dataSource = self
        self.storeTableView.register(UINib(nibName: "StoreTableViewCell", bundle: nil), forCellReuseIdentifier: "StoreTableViewCell")
    }

    // MARK: - API Call
    func fetchStoreData() {
        let url = "https://fakestoreapi.com/products"
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil)
          .response{ resp in
              switch resp.result{
                case .success(let data):
                  do{
                    let jsonData = try JSONDecoder().decode([StoreData].self, from: data!)
                    print(jsonData)
                      self.storeDataArray = jsonData
                      DispatchQueue.main.async {
                          self.storeTableView.reloadData()
                      }
                 } catch {
                    print(error.localizedDescription)
                 }
               case .failure(let error):
                 print(error.localizedDescription)
               }
          }
    }
    
}

// MARK: - UITableView Delegate and DataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.storeDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "StoreTableViewCell", for: indexPath) as? StoreTableViewCell {
            cell.titleLabel.text = self.storeDataArray[indexPath.row].title
            return cell
        }
        
        return UITableViewCell()
    }
}
