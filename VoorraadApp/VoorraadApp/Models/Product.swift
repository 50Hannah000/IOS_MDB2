import UIKit
import os.log

class Product: NSObject, NSCoding, Decodable {
    
    var id: Int
    var name: String
    var bla: String
   
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("products")
  
    //MARK: Types
    struct PropertyKey {
        static let id = "id"
        static let name = "name"
        static let bla = "bla"
    }
   
    init?(id: Int, name: String, bla: String) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }

        
        // Initialization should fail if there is no name or if the id is negative.
        if name.isEmpty || id < 0  {
            return nil
        }
        
        // Initialize stored properties.
        self.id = id
        self.name = name
        self.bla = bla
        
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: PropertyKey.id)
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(bla, forKey: PropertyKey.bla)
    }
    
   required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Product object.", log: OSLog.default, type: .debug)
            return nil
        }
        let id = aDecoder.decodeInteger(forKey: PropertyKey.id)
        let bla = aDecoder.decodeObject(forKey: PropertyKey.bla)
        
        // Must call designated initializer.
        self.init(id: id, name: name, bla: bla as! String)
    }
}
