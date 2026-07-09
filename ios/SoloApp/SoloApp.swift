// M0 walking skeleton — navigation shell for the 12 SPEC §4 screens.
// Placeholder content only; each screen becomes real in its milestone.

import SwiftUI

@main
struct SoloApp: App {
    var body: some Scene {
        WindowGroup {
            HomeScreen()
        }
    }
}

// SPEC §4 screen map — placeholders. DESIGN.md rules apply from M1 onward;
// M0 ships bare navigation only.
enum Screen: String, CaseIterable, Identifiable {
    case onboarding = "Onboarding"
    case home = "Home / Quest Board"
    case exercisePicker = "Exercise Picker"
    case setupGate = "Setup Gate"
    case liveSet = "Live Set"
    case setSummary = "Set Summary"
    case run = "Run"
    case runSummary = "Run Summary"
    case profile = "Profile"
    case history = "Progression / History"
    case settings = "Settings / Privacy"
    case paywall = "Paywall"

    var id: String { rawValue }
}

struct HomeScreen: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Screens (M0 shell)") {
                    ForEach(Screen.allCases) { screen in
                        NavigationLink(screen.rawValue) {
                            PlaceholderScreen(title: screen.rawValue)
                        }
                    }
                }
                Section {
                    NavigationLink("Debug") { DebugScreen() }
                }
            }
            .navigationTitle("SoloLeveling")
        }
    }
}

struct PlaceholderScreen: View {
    let title: String
    var body: some View {
        Text(title).font(.title2).navigationTitle(title)
    }
}
