import SwiftData

extension Team {
    
    static let noHops = Team(
        name: "No Hops",
        compactName: "HOPS"
    )
    
    static let ballHogz = Team(
        name: "Ball Hogz",
        compactName: "HOGZ"
    )
    
    static func insertSampleData(modelContext: ModelContext) {
        modelContext.insertSampleData(noHops, ballHogz)
    }
}
