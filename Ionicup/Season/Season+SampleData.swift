import SwiftData

extension Season {

    static let ionicup2024 = Season(displayName: "Ionicup '24", tournaments: [])

    static func insertSampleData(modelContext: ModelContext) {
        modelContext.insertSampleData(ionicup2024)
    }
}
