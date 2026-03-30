import Foundation

protocol CustomLocationStoreProtocol {
    func load() -> [Location]
    func save(_ locations: [Location])
}

final class CustomLocationStore: CustomLocationStoreProtocol {
    private let userDefaults: UserDefaults
    private let key = "custom_locations"

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func load() -> [Location] {
        guard let data = userDefaults.data(forKey: key) else { return [] }
        return (try? JSONDecoder().decode([Location].self, from: data)) ?? []
    }

    func save(_ locations: [Location]) {
        let data = try? JSONEncoder().encode(locations)
        userDefaults.set(data, forKey: key)
    }
}
