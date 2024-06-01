import SwiftUI
import SwiftData

extension ModelContainer {
    @MainActor
    static let preview: ModelContainer = {
        let schema = Schema([Tournament.self, Season.self, Match.self, Team.self, Rank.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container: ModelContainer
        
        do {
            container = try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Failed to create the model container: \(error.localizedDescription)")
        }
        
//        let match1: Match = .pastMatch
//        container.mainContext.insert(match1)
//        let match2: Match = .liveMatch
//        container.mainContext.insert(match2)
//        let match3: Match = .upcomingMatch
//        container.mainContext.insert(match3)
//        let tournament1: Tournament = .ionicup2024
//        container.mainContext.insert(tournament1)
//        let tournament2: Tournament = .ionicup2024Roundrobin
//        container.mainContext.insert(tournament2)
//        let tournament3: Tournament = .ionicup2024Multilevel
//        container.mainContext.insert(tournament3)
//        let season: Season = .ionicup2024
//        container.mainContext.insert(season)
        
        
//        Team.insertSampleData(modelContext: container.mainContext)
//        Match.insertSampleData(modelContext: container.mainContext)
//        Tournament.insertSampleData(modelContext: container.mainContext)
//        Season.insertSampleData(modelContext: container.mainContext)
        
        return container
    }()
}

extension ModelContext {
    
    func insertSampleData(_ models: any PersistentModel...) {
        for model in models {
            if !insertedModelsArray.contains(where: { $0.id == model.id }) {
                insert(model)
            }
        }
    }
}

struct EscapingView<Content: View>: View {
    
    private let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        content()
    }
}
