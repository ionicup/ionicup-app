import Foundation
import SwiftData

@Model
class Team {
    
    var name: String
    
    var compactName: String
    
    var season: Season?
    var seasonSortOrder: Int?
    
    var ranks: [Rank]
    
    init(name: String, compactName: String, season: Season? = nil, seasonSortOrder: Int? = nil, ranks: [Rank] = []) {
        self.name = name
        self.compactName = compactName
        self.season = season
        self.seasonSortOrder = seasonSortOrder
        self.ranks = ranks
    }
}
