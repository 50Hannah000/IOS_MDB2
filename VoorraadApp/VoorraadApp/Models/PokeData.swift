import Foundation

struct PokeData : Decodable {
    var id : Int
    var height : Int
    var name : String
    var sprites : Sprites
}

struct Sprites: Decodable {
    let front_default: String
}
