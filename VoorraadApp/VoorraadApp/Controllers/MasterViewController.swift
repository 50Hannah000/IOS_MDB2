import UIKit
import os.log

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var products = [Product]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.loadProducts()
            self.makeHTTPGetRequest(id: 5)
//            self.getPokemons()
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
    
//    func makeHTTPGetRequest() {
//        let url = URL(string: "https://pokeapi.co/")!
//
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//
//            if let receivedData = data {
//                Swift.print("\(receivedData)")
//
//                do {
//                    // Optie 1: Gebruik JSONSerialization
//
//                    let json = try JSONSerialization.jsonObject(with: receivedData) as! [String:Any]
//                    Swift.print("\(json)")
//                    // MARK: Gebruik Codable protocol
//                    let decoder = JSONDecoder()
//                    let productdata = try! decoder.decode(ProductData.self, from: receivedData)
//
//                    let categoryName = productdata.category.name
//
//                    DispatchQueue.main.async {
//                        Swift.print("\(categoryName)")
//                    }
//                } catch { }
//            }
//        }
//        task.resume()
//    }
    
    var pokemon = PokeData(id: 0, height: 0, name: "", sprites: Sprites(front_default: ""))
    func makeHTTPGetRequest(id: Int) {
        let session = URLSession.shared
        let url = URL(string: "https://pokeapi.co/api/v1/pokemon/\(id)")
        let task = session.dataTask(with: url!) { (data, _, _) in
            if let data = data {
                guard let pokemon = try? JSONDecoder().decode(PokeData.self, from: data) else {
                    print("Error: Couldn't decode data into pokemon \(data)")
                    return
                }
                self.pokemon  = pokemon
//                self.displayPokemon()
                print("oioioio")
                print("\(pokemon)")
                return
            }
        }
        task.resume()
    }
//
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

