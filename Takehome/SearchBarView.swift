import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    var prompt: String = "Search..."

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField(prompt, text: $text)
                .focused($isFocused)

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .buttonStyle(.plain)
            }
        }
		.padding(.vertical, 8)
		.padding(.horizontal, 12)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .onTapGesture {
            isFocused = true
        }
    }
}

#Preview {
	@Previewable @State var searchText = ""
	@Previewable @State var searchTextNotEmpty = "Typing..."

	VStack {
		SearchBarView(text: $searchText, prompt: "Search...")
		SearchBarView(text: $searchTextNotEmpty)
	}
	.padding(.horizontal)
}
