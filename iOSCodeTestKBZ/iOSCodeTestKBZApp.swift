@_exported import Inject
import SwiftUI
import SwiftData

@main
struct iOSCodeTestKBZApp: App {
    @State private var appState: AppState

    private let sharedModelContainer: ModelContainer

    init() {
        try? FileManager.default.createDirectory(
            at: URL.applicationSupportDirectory,
            withIntermediateDirectories: true
        )

        do {
            let schema = Schema([TopUpTransaction.self])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            sharedModelContainer = container
            _appState = State(initialValue: AppState(modelContainer: container))
            Task { [container] in
                let warmUpContext = ModelContext(container)
                _ = try? warmUpContext.fetchCount(FetchDescriptor<TopUpTransaction>())
            }
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
        }
        .modelContainer(sharedModelContainer)
    }
}
