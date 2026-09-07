import SwiftUI

struct ContentView: View {

    @State private var viewModel: ShoppingListViewModel
    @State private var itemName = ""
    @State private var quantity = ""

    init() {
        // Injecting the shopping list service into the ViewModel
        let service = ShoppingListServiceImpl()
        _viewModel = State(initialValue: ShoppingListViewModel(service: service))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {

                // Input fields
                HStack {
                    TextField("Enter item name", text: $itemName)
                        .textFieldStyle(.roundedBorder)
                    TextField("Qty", text: $quantity)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 70)
                        .keyboardType(.numberPad)
                }

                // Add Item button
                Button("Add Item") {
                    addItem()
                }
                .buttonStyle(.borderedProminent)

                // Display the empty state or shopping list
                if viewModel.shoppingItems.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "cart")
                            .font(.system(size: 50))
                            .foregroundStyle(.secondary)
                        Text("Your shopping list is empty")
                            .font(.headline)
                        Text("Add items to get started")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.shoppingItems) { item in
                            HStack {
                                // Toggle the purchased state of an item.
                                Button {
                                    viewModel.togglePurchased(for: item)
                                } label: {
                                    Image(systemName: item.isPurchased ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(item.isPurchased ? .green : .gray)
                                }
                                .buttonStyle(.plain)

                                // Item details
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .strikethrough(item.isPurchased)
                                    Text("Quantity: \(item.quantity)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                            }
                        }
                        // Delete items using the list's swipe-to-delete action.
                        .onDelete { indexSet in
                            viewModel.deleteItem(at: indexSet)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .padding()
            .navigationTitle("Shopping List")
        }
    }

    private func addItem() {
        // Validate the quantity before adding the item.
        guard let itemQuantity = Int(quantity), itemQuantity > 0 else {
            return
        }
        viewModel.addItem(name: itemName, quantity: itemQuantity)
        itemName = ""
        quantity = ""
    }
}

#Preview {
    ContentView()
}
