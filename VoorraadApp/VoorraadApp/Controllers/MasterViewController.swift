import UIKit
import os.log

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var products = [Product]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeHTTPGetRequest()
//        self.makeHTTPGetRequest(id: 5)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    
        navigationItem.leftBarButtonItem = editButtonItem
       
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        if let savedProducts = loadProducts() {
            products += savedProducts
        }
        else {
            os_log("sample data successfully activated.", log: OSLog.default, type: .debug)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc
    func insertNewObject(_ sender: Product) {
        guard let product = Product(id: 12144, name: "boemboem Salad", price: 3) else {
            fatalError("Unable to instantiate product1")
        }
        
        let newIndexPath = IndexPath(row: products.count, section: 0)
        
        products.append(product)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        
        products.insert(product, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let product = products[indexPath.row]
                saveProducts()
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = product
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
        if segue.identifier == "createItem" {
            let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
    
    // MARK: - private methods
    private func saveProducts() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(products, toFile: Product.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadProducts() -> [Product]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Product.ArchiveURL.path) as! [Product]
    }
    
    private func loadSampleProducts() {
        
        guard let product1 = Product(id: 1212, name: "Caprese Salad", price: 2) else {
            fatalError("Unable to instantiate product1")
        }
        
        guard let product2 = Product(id: 233, name: "BOEEH Salad", price: 6) else {
            fatalError("Unable to instantiate product3")
        }
        
        guard let product3 = Product(id: 344, name: "nomnom Salad", price: 9) else {
            fatalError("Unable to instantiate product3")
        }
        
        products += [product1, product2, product3]
    }
    var values: NSDictionary = [:]
    var productvalues : NSArray = []
    func makeHTTPGetRequest() {
        let url = URL(string: "http://localhost:3000/products");
        var request = URLRequest(url:url!);
        request.addValue("Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJfaWQiOjM1LCJfX3YiOjAsImxvY2FsIjp7InBhc3N3b3JkIjoiJDJhJDA4JENrcU54NFVhcFVkTXlqV1BIbklaSWVNenRSa3ZEOFhXZC5iR0VQUlFjVlpnLnhsQTViU1RTIiwiZW1haWwiOiJoYW5uYWhtYXVyaXR6QGdtYWlsLmNvbSIsIm5hbWUiOiIifSwiaXNBZG1pbiI6dHJ1ZX0.-Caei3JSstNLIxfEQY_UfhgwqLaRITVU8PV7i2S61xQ", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
            if let receivedData = data {
                do {
                    self.values = try JSONSerialization.jsonObject(with: receivedData, options: []) as! NSDictionary
                    self.productvalues = self.values["products"] as! NSArray
                    for productObject in self.productvalues {
                        var array = [Product]()
                        array.append(productObject as! Product)
                         Swift.print("object \(productObject)")
                    }
//                    Swift.print("\(self.productvalues)")
                    
                } catch{
                    
                }
            }
            
        }
        task.resume()
    }

    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let product = products[indexPath.row]
        cell.textLabel!.text = product.name
//        cell..text = product.price
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            products.remove(at: indexPath.row)
            saveProducts()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

}

