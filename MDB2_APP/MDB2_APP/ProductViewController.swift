import Foundation
import UIKit
import CoreData

class ProductViewController : UIViewController {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var image: UIImageView!
    var managedObjectContext: NSManagedObjectContext? = nil
    
    var product = Product(id: 0, name: "", weight: 0, sprites: Sprites(front_default: ""))
    
    override func viewDidLoad() {
        fetchProducts()
    }
    
    @IBAction func catchPokemon(_ sender: UIButton) {
        let newPokemon = NSEntityDescription.insertNewObject(forEntityName: "Pokemon", into: managedObjectContext!) as! Pokemon
        
        // If appropriate, configure the new managed object.
        newPokemon.name = pokemon.name
        newPokemon.id = pokemon.id
        newPokemon.weight = pokemon.weight
        
        // Save the context.
        
        do {
            try managedObjectContext!.save()
            print("saved")
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
    }
    
    func displayPokemon() {
        DispatchQueue.main.async {
            self.name.text = self.pokemon.name
        }
        if let url = URL(string: self.pokemon.sprites.front_default) {
            downloadImage(url: url)
        }
    }
    
    func fetchProducts() {
        makeHTTPGetRequest(path: "urlvanproducts")
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() {
                self.image.contentMode = .scaleAspectFit
                self.image.image = UIImage(data: data)
            }
        }
    }
    
    func makeHTTPGetRequest(path: String) {
        let session = URLSession.shared
        let url = URL(string: path)
        let task = session.dataTask(with: url!) { (data, _, _) in
            if let data = data {
                guard let pokemon = try? JSONDecoder().decode(PokemonResult.self, from: data) else {
                    print("Error: Couldn't decode data into pokemon")
                    return
                }
                self.pokemon  = pokemon
                self.displayPokemon()
                return
            }
        }
        task.resume()
    }
}
