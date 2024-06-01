//
//  SeasonView.swift
//  ionicup
//
//  Created by Lorenzo Fiamingo on 27/02/24.
//

import SwiftUI

struct SeasonView: View {
    
    let season: Season
    
    @State private var currentDate: Date?

  var dates: [Date] {
    season.dates.compactMap(\.date).sorted()
  }

  var defaultDate: Date {
      let now: Date = .now
      let todayDate = dates.first(where: Calendar.current.isDateInToday)
      let firstNextDate = dates.filter { now < $0 }.first
      let firstDate = dates.first
      let lastDate = dates.last

      if let todayDate {
        return todayDate
      } else if let firstNextDate {
        return firstNextDate
      } else if let lastDate, let weekAfterLastDate = Calendar.current.date(byAdding: .day, value: 7, to: lastDate), weekAfterLastDate > now {
        return lastDate
      } else if let firstDate {
        return firstDate // Forse è meglio sempre last date se poi decido di fare un unica scroll view
      } else {
        return now
      }
  }

    //    var upcomingMatches: [Match] {
    //        let startOfToday = Calendar.current.startOfDay(for: .now)
    //        let startOfTomorrow = Calendar.current.date(byAdding: .day, value: 1, to: startOfToday)
    //
    //        return season.matches.filter { match in
    //            if let startOfTomorrow {
    //                match.date > startOfTomorrow
    //            } else {
    //                false
    //            }
    //        }
    //    }
    
  var body: some View {
    EventList(events: season.events)
      .navigationTitle(season.displayName)
//      .toolbar {
//        ToolbarItem(placement: .status) {
//          Picker("Sections", selection: $currentDate.default(defaultDate)) {
//            ForEach(dates, id: \.self) { date in
//              if Calendar.current.isDateInToday(date) {
//                Text("Today")
//                  .tag(date as Optional)
//              } else if Calendar.current.isDateInYesterday(date) {
//                Text("Yesterday")
//                  .tag(date as Optional)
//              } else if Calendar.current.isDateInTomorrow(date) {
//                Text("Tomorrow")
//                  .tag(date as Optional)
//              } else {
//                Text(date, format: .dateTime.weekday(.wide))
//                  .tag(date as Optional)
//              }
//            }
//          }
//          .pickerStyle(.segmented)
//          .padding(.horizontal)
//        }
//      }
  }

    enum Section: CaseIterable {
        case past
        case today
        case upcoming
    }
}

extension Season {
  var orderedDates: [Date] {
    self.dates.compactMap(\.date).sorted()
  }
}


#Preview {
    SeasonView(season: .ionicup2024)
        .modelContainer(.preview)
}
