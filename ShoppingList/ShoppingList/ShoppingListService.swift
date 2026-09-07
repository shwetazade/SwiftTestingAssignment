import Foundation

// Defines the operations required to manage shopping list items.
protocol ShoppingListService {
    var items: [ShoppingItem] { get }

    func addItem(_ item: ShoppingItem)
    func deleteItem(_ item: ShoppingItem)
    func updateItem(_ item: ShoppingItem)
}

// Provides the actual in memory implementation of the shopping list service
class ShoppingListServiceImpl: ShoppingListService {

    private(set) var items: [ShoppingItem] = []

    func addItem(_ item: ShoppingItem) {
        items.append(item)
    }

    func deleteItem(_ item: ShoppingItem) {
        items.removeAll { $0.id == item.id }
    }

    func updateItem(_ item: ShoppingItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else {
            return
        }

        items[index] = item
    }
}
