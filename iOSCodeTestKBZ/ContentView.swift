import SwiftUI

struct ContentView: View {
    @Environment(AppState.self) private var appState
    @ObserveInjection private var injectionObserver

    var body: some View {
        TabView(selection: Binding(
            get: { appState.selectedTab },
            set: { appState.selectedTab = $0 }
        )) {
            TopUpScreen(service: appState.topUpService)
                .tabItem { Label("Top Up", systemImage: "iphone.gen3") }
                .tag(AppState.Tab.topUp)

            HistoryScreen(service: appState.topUpService)
                .tabItem { Label("History", systemImage: "clock.arrow.circlepath") }
                .tag(AppState.Tab.history)
        }
        .enableInjection()
    }
}
