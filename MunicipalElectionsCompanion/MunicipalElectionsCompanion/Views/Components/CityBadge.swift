import SwiftUI

struct CityBadge: View {
    @Environment(CityViewModel.self) private var city

    var body: some View {
        Label("City: \(city.selected?.name ?? "-")", systemImage: "mappin.and.ellipse")
            .font(.subheadline.weight(.semibold))
            .lineLimit(1)
            .accessibilityLabel("Selected municipality: \(city.selected?.name ?? "none")")
    }
}

#Preview {
    CityBadge()
        .previewEnvironment()
}
