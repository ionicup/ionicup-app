import SwiftData
import OSLog

private let logger = Logger(subsystem: "Ionicup", category: "Season")

@Model
class Season {
    
    var displayName: String
    
    var dates: Set<DateComponents>

  var league: League?
  var leagueSortOrder: Int?

    private var _unsortedEvents: [Event]
    var events: [Event] {
        get {
            _unsortedEvents.sorted(using: SortDescriptor(\.seasonSortOrder))
        } set {
            for (offset, event) in newValue.enumerated() {
                event.seasonSortOrder = offset
            }
            _unsortedEvents = newValue
        }
    }
    
    private var _unsortedCourts: [Court]
    var courts: [Court] {
        get {
            _unsortedCourts.sorted(using: SortDescriptor(\.seasonSortOrder))
        } set {
            for (offset, court) in newValue.enumerated() {
                court.seasonSortOrder = offset
            }
            _unsortedCourts = newValue
        }
    }
    
    private var _unsortedTeams: [Team] = []
    var teams: [Team] {
        get {
            _unsortedTeams.sorted(using: SortDescriptor(\.seasonSortOrder))
        } set {
            for (offset, team) in newValue.enumerated() {
                team.seasonSortOrder = offset
            }
            _unsortedTeams = newValue
        }
    }
    
    @Relationship(deleteRule: .cascade, inverse: \Tournament._season)
    var _unsortedTournaments: [Tournament]
    var tournaments: [Tournament] {
        get {
            _unsortedTournaments.sorted(using: SortDescriptor(\.parentSortOrder))
        } set {
            for (offset, tournament) in newValue.enumerated() {
                tournament.parentSortOrder = offset
            }
            _unsortedTournaments = newValue
        }
    }
    
    init(
        displayName: String,
        dates: Set<DateComponents> = [],
        events: [Event] = [],
        courts: [Court] = [],
        teams: [Team] = [],
        tournaments: [Tournament] = []
    ) {
        self.displayName = displayName
        self.dates = dates
        self._unsortedEvents = events
        self._unsortedCourts = courts
        self._unsortedTeams = teams
        self._unsortedTournaments = tournaments
        
        self.events = events
        self.courts = courts
        self.teams = teams
        self.tournaments = tournaments
        
        logger.notice("Season \(displayName) has been created.")
    }
}

extension Season {
    var matches: [Match] {
        func recursiveMatches(_ tournament: Tournament) -> [Match] {
            tournament.matches + tournament.children.flatMap(recursiveMatches)
        }
        
        return tournaments.flatMap(recursiveMatches)
    }
}
