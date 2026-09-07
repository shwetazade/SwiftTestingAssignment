import Foundation

struct ShoppingItem: Identifiable {
    let id = UUID()
    var name: String
    var quantity: Int
    var isPurchased: Bool
}
