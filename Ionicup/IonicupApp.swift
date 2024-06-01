import SwiftUI
import SwiftData

@main
struct ionicupApp: App {
    
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([Tournament.self, Season.self, Match.self, Team.self])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
//        
//        do {
//            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
////            Task { @MainActor in
////                container.mainContext.undoManager = UndoManager()
////            }
//            return container
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()
    
    var body: some Scene {
      WindowGroup {
        EscapingView {
          ContentView()
        }
      }
      .modelContainer(for: [Season.self, Tournament.self, Rank.self, Match.self, Team.self], inMemory: false, isUndoEnabled: true)
    }
}
