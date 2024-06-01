import SwiftData

extension Tournament {
    
    static let ionicup2024Roundrobin = Tournament(displayName: "Fase a girone", mode: .roundrobin, matches: [])
    
    static let ionicup2024Multilevel = Tournament(displayName: "Fase a eliminazione", mode: .multilevel)
    
    static var ionicup2024: Tournament {
        Tournament(displayName: "Ionicup 2024", children: [], mode: .phases)
    }
    
    static func insertSampleData(modelContext: ModelContext) {
        modelContext.insertSampleData(ionicup2024Roundrobin, ionicup2024Multilevel, ionicup2024)
    }
}
