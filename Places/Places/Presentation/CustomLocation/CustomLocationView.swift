import SwiftUI

struct CustomLocationView: View {
    @State private var viewModel = CustomLocationViewModel()
    @Environment(\.dismiss) private var dismiss

    var onAdd: (Location) -> Void

    var body: some View {
        NavigationStack {
            List {
                searchSection
                suggestionsSection
                errorSection
            }
            .listStyle(.plain)
            .navigationTitle(String(localized: "custom_location_title"))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "cancel_button")) {
                        dismiss()
                    }
                }
            }
            .overlay {
                if viewModel.isResolving {
                    ProgressView()
                        .controlSize(.large)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.ultraThinMaterial)
                }
            }
        }
    }

    // MARK: - Search

    private var searchSection: some View {
        Section {
            TextField("search_field_placeholder", text: $viewModel.searchText)
                .textContentType(.addressCity)
                .autocorrectionDisabled()
        }
    }

    // MARK: - Suggestions

    @ViewBuilder
    private var suggestionsSection: some View {
        if !viewModel.suggestions.isEmpty {
            Section {
                ForEach(viewModel.suggestions) { suggestion in
                    Button {
                        Task { await selectSuggestion(suggestion) }
                    } label: {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(suggestion.title)
                                .font(.body)
                                .foregroundStyle(.primary)
                            if !suggestion.subtitle.isEmpty {
                                Text(suggestion.subtitle)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Error

    @ViewBuilder
    private var errorSection: some View {
        if let errorMessage = viewModel.errorMessage {
            Section {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }
        }
    }

    // MARK: - Actions

    private func selectSuggestion(_ suggestion: CitySuggestion) async {
        if let location = await viewModel.selectSuggestion(suggestion) {
            onAdd(location)
            dismiss()
        }
    }
}

#Preview {
    CustomLocationView(onAdd: { _ in })
}
