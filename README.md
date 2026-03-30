# Places

An iOS app that displays locations and allows users to open them in the Wikipedia app. Users can browse a list of remote locations or add their own custom locations via city search with autocomplete.

## Architecture

The project follows **Clean Architecture** with **MVVM** in the presentation layer:

```
Domain          Models, repository protocols
Data            API client, repository implementations, persistence
Application     Use cases (FetchLocations, OpenWikipedia, CitySearchService, GeocodingService)
Presentation    SwiftUI views + @Observable ViewModels
```

All dependencies are injected via protocols, making every layer independently testable.

## Key Features

### Location List
- Fetches locations from a remote JSON API
- Locations without a name are resolved via reverse geocoding (`MKReverseGeocodingRequest`)
- Tapping a location opens the Wikipedia app at those coordinates via deep link (`wikipedia://places`)

### Custom Locations
- **City autocomplete**: Type a city name and get live suggestions from `MKLocalSearchCompleter`, filtered to localities only
- **One-tap add**: Tap a suggestion to resolve its coordinates and add it to the list
- **Persistence**: Custom locations are stored in UserDefaults and survive app restarts
- The storage layer uses a protocol (`CustomLocationStoreProtocol`), allowing easy migration to Core Data, SwiftData, or a remote backend

### Localization
- Fully localized in **English** and **Dutch** using a String Catalog (`.xcstrings`)
- All user-facing strings and error messages are localized

### Accessibility
- VoiceOver labels on all interactive elements
- Dynamic Type support throughout (SwiftUI default behavior)

## Tech Stack

- **SwiftUI** with `@Observable` (Observation framework)
- **Swift Concurrency** (async/await, `@MainActor`, `Sendable`)
- **MapKit** (`MKLocalSearchCompleter`, `MKLocalSearch`, `MKReverseGeocodingRequest`)
- **Swift Testing** framework for unit tests

## Testing

Unit tests cover:
- **Models**: JSON decoding, computed properties
- **Repository**: API success and error scenarios
- **Use Cases**: Wikipedia URL construction and URL opening
- **ViewModels**: Location loading, autocomplete suggestions, city selection, persistence, reverse geocoding, error handling

All ViewModels are tested via protocol-based dependency injection with mock implementations.

Run tests with `Cmd+U` in Xcode.

## Project Structure

```
Places/
├── Application/
│   ├── AppConfiguration.swift
│   └── UseCases/             CitySearchService, GeocodingService, FetchLocationsUseCase, OpenWikipediaUseCase
├── Data/
│   ├── Network/              APIClient
│   └── Repositories/         LocationRepository, CustomLocationStore
├── Domain/
│   ├── Models/               Location, LocationsResponse
│   └── Repositories/         LocationRepositoryProtocol
├── Presentation/
│   ├── CustomLocation/       CustomLocationView + ViewModel
│   └── LocationList/         LocationListView + ViewModel, LocationRowView
├── Assets.xcassets
├── Localizable.xcstrings     EN + NL translations
└── Info.plist
```
