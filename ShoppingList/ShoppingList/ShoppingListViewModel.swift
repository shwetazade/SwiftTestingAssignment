import Foundation
import Observation

@Observable
class ShoppingListViewModel {

    private let service: ShoppingListService

    var shoppingItems: [ShoppingItem] = []

    init(service: ShoppingListService) {
        // Inject the service so the ViewModel can manage shopping list data
        self.service = service
        self.shoppingItems = service.items
    }

    func addItem(name: String, quantity: Int) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty, quantity > 0 else {
            return
        }
        let newItem = ShoppingItem(name: trimmedName,quantity: quantity,isPurchased: false)
        service.addItem(newItem)
        shoppingItems = service.items
    }

    func togglePurchased(for item: ShoppingItem) {
        var updatedItem = item
        updatedItem.isPurchased.toggle()
        service.updateItem(updatedItem)
        shoppingItems = service.items
    }

    func deleteItem(at offsets: IndexSet) {
        for index in offsets {
            service.deleteItem(shoppingItems[index])
        }

        shoppingItems = service.items
    }
}
