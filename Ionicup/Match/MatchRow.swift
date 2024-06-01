//
//  MatchRow.swift
//  ionicup
//
//  Created by Lorenzo Fiamingo on 25/02/24.
//

import SwiftUI

struct MatchRow: View {

    let match: Match

    var body: some View {
        ZStack(alignment: .leading) {
            Text("")
                .hidden()
            
            HStack {
                HStack {
                    Image(.kings)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                        .padding(.horizontal, 8)
                        .overlay(alignment: .bottomLeading) {
                            Text(match.homeRank?.displayCompactResolvedName ?? "Undefined")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.secondary)
                                .fixedSize()
                                .frame(maxWidth: .infinity)
                                .visualEffect { content, geometryProxy in
                                    content
                                        .offset(y: geometryProxy.size.height + 2)
                                }
                        }
                    
                    Text(match.homeTeamScore, format: .number)
                        .font(.system(size: 44).width(.compressed))
                        .fontWeight(.semibold)
                        .lineLimit(1)
#if os(macOS)
                        .frame(maxWidth: .infinity)
#endif
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Final")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                
                HStack {
                    
                    Text(match.awayTeamScore, format: .number)
                        .font(.system(size: 44).width(.compressed))
                        .fontWeight(.semibold)
                        .foregroundStyle(.tertiary)
                        .lineLimit(1)
#if os(macOS)
                        .frame(maxWidth: .infinity)
#endif
                    
                    Image(.clippers)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                        .padding(.horizontal, 8)
                        .overlay(alignment: .bottomTrailing) {
                            Text(match.awayRank?.displayCompactResolvedName ?? "Undefined")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.secondary)
                                .fixedSize()
                                .frame(maxWidth: .infinity)
                                .visualEffect { content, geometryProxy in
                                    content
                                        .offset(y: geometryProxy.size.height + 2)
                                }
                        }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
#if os(macOS)
            .padding()
#endif
        }
    }
}

#Preview {
    EscapingView {
        MatchRow(match: .liveMatch)
            .padding()
    }
    .previewLayout(.sizeThatFits)
    .modelContainer(.preview)
}
