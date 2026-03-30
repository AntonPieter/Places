import SwiftUI

struct LocationRowView: View {
    let location: Location

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "mappin.circle.fill")
                .font(.title2)
                .foregroundStyle(.tint)

            VStack(alignment: .leading, spacing: 2) {
                Text(location.displayName)
                    .font(.body.weight(.medium))

                Text(String(format: "%.4f, %.4f", location.lat, location.long))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(location.displayName)
        .accessibilityHint(String(localized: "opens_in_wikipedia_hint"))
    }
}

#Preview {
    List {
        LocationRowView(location: Location(name: "Amsterdam", lat: 52.3547498, long: 4.8339215))
        LocationRowView(location: Location(name: nil, lat: 40.4380638, long: -3.7495758))
    }
}
