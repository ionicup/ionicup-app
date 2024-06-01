import SwiftData

@Model
class Court {
    
    var displayName: String
    
    var season: Season?
    var seasonSortOrder: Int?
    
    init(displayName: String = "", season: Season? = nil, seasonSortOrder: Int? = nil) {
        self.displayName = displayName
        self.season = season
        self.seasonSortOrder = seasonSortOrder
    }
}
