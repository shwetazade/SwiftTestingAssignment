import Foundation
@testable import ShoppingList

// Test only service used to verify ViewModel logic without the real service
final class FakeShoppingListService: ShoppingListService {

    var items: [ShoppingItem] = []

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
