import Testing
import Foundation
@testable import ShoppingList

extension Tag {
    @Tag static var itemCreation: Self
    @Tag static var itemValidation: Self
    @Tag static var itemDeletion: Self
    @Tag static var itemPurchase: Self
}

// Groups all shopping list ViewModel tests together
@Suite("Shopping List ViewModel Tests")
struct ShoppingListTests {

    let service: FakeShoppingListService
    let viewModel: ShoppingListViewModel

    init() {
        // Create new test dependencies for each test.
        service = FakeShoppingListService()
        viewModel = ShoppingListViewModel(service: service)
    }

    // Verify that the shopping list starts empty
    @Test
    func initialStateIsEmpty() {
        #expect(viewModel.shoppingItems.isEmpty)
    }

    // Verify that an item is added with the correct details
    @Test(.tags(.itemCreation))
    func addItem() throws {
        viewModel.addItem(name: "Milk", quantity: 2)
        #expect(viewModel.shoppingItems.count == 1)
        let item = try #require(viewModel.shoppingItems.first) // Ensure an item exists before checking its details.
        #expect(item.name == "Milk")
        #expect(item.quantity == 2)
    }

    // Verify that an item's purchased status can be toggled
    @Test(.tags(.itemPurchase))
    func markItemAsPurchased() throws {
        viewModel.addItem(name: "Kiwi", quantity: 2)
        let item = try #require(viewModel.shoppingItems.first)
        viewModel.togglePurchased(for: item)
        let updated = try #require(viewModel.shoppingItems.first)
        #expect(updated.isPurchased == true)
    }

    // Verify that an item can be deleted from the shopping list
    @Test(.tags(.itemDeletion))
    func deleteItem() {
        viewModel.addItem(name: "Kiwi", quantity: 2)
        #expect(viewModel.shoppingItems.count == 1)
        viewModel.deleteItem(at: IndexSet(integer: 0))
        #expect(viewModel.shoppingItems.isEmpty)
    }

    // Verify item creation with different names and quantities
    @Test(arguments: [("Kiwi", 2), ("Peach", 1),("Apples", 5)])
    func addDifferentItems(name: String, quantity: Int) throws {
        viewModel.addItem(name: name, quantity: quantity)
        let item = try #require(viewModel.shoppingItems.first)
        #expect(item.name == name)
        #expect(item.quantity == quantity)
    }

    // Verify that an item with an empty name is not added
    @Test(.tags(.itemValidation))
    func emptyNameIsNotAdded() {
        viewModel.addItem(name: "", quantity: 2)
        #expect(viewModel.shoppingItems.isEmpty)
    }
}
