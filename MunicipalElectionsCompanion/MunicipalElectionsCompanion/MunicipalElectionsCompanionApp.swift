import SwiftUI

// App entry point
@main
struct MunicipalElectionsCompanionApp: App {
    // One shared login state for the whole app
    @StateObject private var auth = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(auth)
        }
    }
}
