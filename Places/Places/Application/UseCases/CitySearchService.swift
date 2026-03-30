import Foundation
import MapKit

struct CitySuggestion: Identifiable, Sendable {
    let id: String
    let title: String
    let subtitle: String
}

protocol CitySearchServiceProtocol: AnyObject {
    var onSuggestionsUpdated: (([CitySuggestion]) -> Void)? { get set }
    func updateQuery(_ query: String)
    func resolveLocation(for suggestion: CitySuggestion) async throws -> Location
}

@MainActor
final class CitySearchService: NSObject, CitySearchServiceProtocol {
    var onSuggestionsUpdated: (([CitySuggestion]) -> Void)?

    private let completer = MKLocalSearchCompleter()
    private var completionResults: [MKLocalSearchCompletion] = []

    override init() {
        super.init()
        completer.resultTypes = .address
        completer.addressFilter = MKAddressFilter(including: .locality)
        completer.delegate = self
    }

    func updateQuery(_ query: String) {
        if query.count < 2 {
            completionResults = []
            onSuggestionsUpdated?([])
            return
        }
        completer.queryFragment = query
    }

    func resolveLocation(for suggestion: CitySuggestion) async throws -> Location {
        guard let completion = completionResults.first(where: { "\($0.title)|\($0.subtitle)" == suggestion.id }) else {
            throw GeocodingError.cityNotFound
        }

        let request = MKLocalSearch.Request(completion: completion)
        request.resultTypes = .address
        let search = MKLocalSearch(request: request)
        let response = try await search.start()

        guard let mapItem = response.mapItems.first else {
            throw GeocodingError.cityNotFound
        }

        let name = mapItem.addressRepresentations?.cityName ?? suggestion.title
        let coordinate = mapItem.location.coordinate

        return Location(name: name, lat: coordinate.latitude, long: coordinate.longitude)
    }
}

extension CitySearchService: MKLocalSearchCompleterDelegate {
    nonisolated func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let results = completer.results
        MainActor.assumeIsolated {
            completionResults = results
            let suggestions = results.map { completion in
                CitySuggestion(
                    id: "\(completion.title)|\(completion.subtitle)",
                    title: completion.title,
                    subtitle: completion.subtitle
                )
            }
            onSuggestionsUpdated?(suggestions)
        }
    }

    nonisolated func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: any Error) {
        MainActor.assumeIsolated {
            completionResults = []
            onSuggestionsUpdated?([])
        }
    }
}
