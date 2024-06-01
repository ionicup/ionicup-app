import Foundation
import SwiftData

@Model
class Event {
    
    var displayName: String?
    
    var displayDescription: String?
    
    var date: Date?
    
    var match: Match?
    
    var court: Court?
    
    var season: Season?
    var seasonSortOrder: Int?
    
    init(
        displayName: String? = nil,
        displayDescription: String? = nil,
        date: Date? = nil,
        match: Match? = nil,
        court: Court? = nil,
        season: Season? = nil,
        seasonSortOrder: Int? = nil
    ) {
        self.displayName = displayName
        self.displayDescription = displayDescription
        self.date = date
        self.match = match
        self.court = court
        self.season = season
        self.seasonSortOrder = seasonSortOrder
    }
}

extension Event {
  var name: String {
    if let displayName, !displayName.isEmpty {
      displayName
    } else if let displayDescription, !displayDescription.isEmpty {
      displayDescription
    } else if let match {
      match.displayName
    } else {
      "Undefined"
    }
  }
}
