//
//  MatchView.swift
//  ionicup
//
//  Created by Lorenzo Fiamingo on 25/02/24.
//

import SwiftUI
import SwiftData

struct MatchView: View {

    let match: Match

    var body: some View {
        ScrollView {
            VStack {
                VStack(spacing: 0) {
                    score

                    teams
                }
                .padding(.horizontal)

                scoreGrid
                    .padding()
            }
            .padding(.horizontal)

            Picker("Section", selection: .constant(0)) {
                Text("Summary")
                    .tag(1)

                Text("Play-By-Play")
                    .tag(0)
            }
            .pickerStyle(.segmented)
            .padding()

            VStack {
                GroupBox {
                    Text("Ball Hogz segnano 2 punti")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .overlay(alignment: .leading) {
                    Capsule()
                        .inset(by: 6)
                        .fill(.purple)
                        .frame(maxWidth: 16)
                }

                Spacer().frame(height: 1000)
            }
            .padding(.horizontal)
        }
    }

    var score: some View {
            HStack {
                Text(match.homeTeamScore, format: .number)
                    .font(.system(size: 88).width(.compressed))
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity)

                Text("Final")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .frame(maxWidth: .infinity)

                Text(match.awayTeamScore, format: .number)
                    .font(.system(size: 88).width(.compressed))
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity)
            }
    }

    var teams: some View {
        HStack {
            VStack {
                Image(.clippers)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .frame(maxWidth: .infinity)

//                Text(match.homeTeam.name)
//                    .font(.headline.weight(.medium))
            }

            Spacer()
                .frame(height: 0)
                .frame(maxWidth: .infinity)
                .hidden()

            VStack {
                Image(.kings)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .frame(maxWidth: .infinity)

//                Text(match.awayTeam.name)
//                    .font(.headline.weight(.medium))
            }
        }
    }

    var scoreGrid: some View {
        Grid {
            GridRow {
                Text("")
                    .gridColumnAlignment(.leading)
                Spacer()
                Text("1")
                Spacer()
                Text("2")
                Spacer()
                Text("3")
                Spacer()
                Text("4")
                Spacer()
                Text("T")
            }
            .foregroundStyle(.secondary)

            Divider()
                .gridCellUnsizedAxes(.horizontal)
                .hidden()

            GridRow {
                Text("OKC")
                Spacer()
                Text("25")
                Spacer()
                Text("15")
                Spacer()
                Text("22")
                Spacer()
                Text("32")
                Spacer()
                Text("32")
            }
            Divider()
                .gridCellUnsizedAxes(.horizontal)
            GridRow {
                Text("LAL")
                Spacer()
                Text("23")
                Spacer()
                Text("24")
                Spacer()
                Text("11")
                Spacer()
                Text("18")
                Spacer()
                Text("122")
            }
        }
        .font(.headline.weight(.medium))
    }
}

#Preview {
    EscapingView {
        MatchView(match: .liveMatch)
    }
    .modelContainer(.preview)
}
