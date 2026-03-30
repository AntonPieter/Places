import SwiftUI

struct LocationListView: View {
    @State private var viewModel = LocationListViewModel()
    @State private var showCustomLocation = false

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView(String(localized: "loading_locations"))
                } else if let errorMessage = viewModel.errorMessage {
                    errorView(message: errorMessage)
                } else {
                    locationList
                }
            }
            .navigationTitle(String(localized: "places_title"))
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showCustomLocation = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel(String(localized: "add_custom_location"))
                }
            }
            .sheet(isPresented: $showCustomLocation) {
                CustomLocationView { location in
                    viewModel.addLocation(location)
                }
            }
            .task {
                await viewModel.loadLocations()
            }
        }
    }

    private var locationList: some View {
        List(viewModel.locations) { location in
            Button {
                viewModel.openInWikipedia(location: location)
            } label: {
                LocationRowView(location: location)
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }

    private func errorView(message: String) -> some View {
        ContentUnavailableView {
            Label(String(localized: "failed_to_load"), systemImage: "exclamationmark.triangle")
        } description: {
            Text(message)
        } actions: {
            Button(String(localized: "try_again_button")) {
                Task {
                    await viewModel.loadLocations()
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    LocationListView()
}
