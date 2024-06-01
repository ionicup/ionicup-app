import Foundation
import SwiftData

@Model
class League {

  var name: String

  var compactName: String

  private var _unsortedSeasons: [Season]
  var seasons: [Season] {
    get {
      _unsortedSeasons.sorted(using: SortDescriptor(\.leagueSortOrder))
    } set {
      for (offset, season) in newValue.enumerated() {
        season.leagueSortOrder = offset
      }
      _unsortedSeasons = newValue
    }
  }

  init(name: String, compactName: String, seasons: [Season]) {
    self.name = name
    self.compactName = compactName
    self._unsortedSeasons = seasons

    self.seasons = seasons
  }
}
