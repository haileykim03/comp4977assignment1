import SwiftUI
import FirebaseCore

@main
struct MunicipalElectionsCompanionApp: App {
    @State private var auth = AuthViewModel()
    @State private var city = CityViewModel()
    @State private var home = HomeViewModel()
    @State private var candidates = CandidatesViewModel()
    @State private var selections = SelectionsViewModel()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(auth)
                .environment(city)
                .environment(home)
                .environment(candidates)
                .environment(selections)
        }
    }
}
