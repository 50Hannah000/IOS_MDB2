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
        guard let product = Product(id: 12144, name: "boemboem Salad", bla: "ololol") else {
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
        
        guard let product1 = Product(id: 1212, name: "Caprese Salad", bla: "jajaja") else {
            fatalError("Unable to instantiate product1")
        }
        
        guard let product2 = Product(id: 233, name: "BOEEH Salad", bla: "nenene") else {
            fatalError("Unable to instantiate product3")
        }
        
        guard let product3 = Product(id: 344, name: "nomnom Salad", bla: "oehjaja") else {
            fatalError("Unable to instantiate product3")
        }
        
        products += [product1, product2, product3]
    }
    
    func makeHTTPGetRequest() {
        let url = URL(string: "http://localhost:3000/products");
        var request = URLRequest(url:url!);
        request.addValue("Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJfaWQiOjM1LCJfX3YiOjAsImxvY2FsIjp7InBhc3N3b3JkIjoiJDJhJDA4JENrcU54NFVhcFVkTXlqV1BIbklaSWVNenRSa3ZEOFhXZC5iR0VQUlFjVlpnLnhsQTViU1RTIiwiZW1haWwiOiJoYW5uYWhtYXVyaXR6QGdtYWlsLmNvbSIsIm5hbWUiOiIifSwiaXNBZG1pbiI6dHJ1ZX0.-Caei3JSstNLIxfEQY_UfhgwqLaRITVU8PV7i2S61xQ", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
           
            if let receivedData = data {
                Swift.print("\(receivedData)")

//                do {
                    var names = [String]()
                    
                    do {
//                        if let  = data,
                        let json = try JSONSerialization.jsonObject(with: receivedData, options: []) as! [ProductData: AnyObject]
//                        var blogs : json?["products"] as? [[ProductData: Any]] {
//                            for blog in blogs {
//                                if let name = blog["name"] as? String {
//                                    names.append(name)
//                                }
//                            }
//                        }
                        Swift.print("json \(json)")
                    } catch {
                        print("Error deserializing JSON: \(error)")
                    }
                    
                    print(names)
//                    for products in productsArray {
//                        if(products.key == "products") {
//                        Swift.print("producten \(products) index \(product.key)")
//                            for product in products {
//                                Swift.print("\(product.name)")
//                            }
//                        }
//                    }
//                }

//                    let length = productsArray.count
//                    DispatchQueue.main.async {
//                        Swift.print("nounou\(length)")
//                    }
//                }
//            catch {
//                    Swift.print("someting went wrong")
//                }
            }
        }
        task.resume()
    }
    
//    var pokemon = PokeData(id: 0, height: 0, name: "", sprites: Sprites(front_default: ""))
//    func makeHTTPGetRequest(id: Int) {
//        let session = URLSession.shared
//        let url = URL(string: "https://pokeapi.co/api/v1/pokemon/\(id)")
//        let task = session.dataTask(with: url!) { (data, _, _) in
//            if let data = data {
//                guard let pokemon = try? JSONDecoder().decode(PokeData.self, from: data) else {
//                    print("Error: Couldn't decode data into pokemon \(data)")
//                    return
//                }
//                self.pokemon  = pokemon
////                self.displayPokemon()
//                print("oioioio")
//                print("\(pokemon)")
//                return
//            }
//        }
//        task.resume()
//    }
////
//    func getPokemons() {
//         if let receivedData = data {
//            Swift.print("\(receivedData)")
//            do {
//                for count in 1...20 {
//                    self.getPokemon(id: count)
//                }
//                let decoder = JSONDecoder()
//                let pokedata = try! decoder.decode(PokeData.self, from: receivedData)
//                DispatchQueue.main.async {
//                    //ui
//                    Swift.print("\(pokedata)")
//                }
//            } catch { }
//            }
//        }
//        task.resume()
//    }
//
//
//    func getPokemon(id: Int){
//        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//
//            dispatch_async(dispatch_get_main_queue(), {
//
//
//            self.data.getResults("http://pokeapi.co/api/v1/pokemon/\(id)",
//                result: { (result: Pokemon) -> Void in
//
//                    self.pokemon = result
//
//                    let updatedDes = NSUserDefaults.standardUserDefaults().objectForKey("des\(id)")
//                    if (updatedDes == nil){
//                        self.loadDescription(result.description_url)
//                    }
//
//                    self.updateFields()
//            })
//
//
//
//            // Set image
////            self.setImage(id)
//
//        })
//    }
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
        cell.textLabel!.text = product.bla
        
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

