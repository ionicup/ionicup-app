import SwiftUI

struct MatchRulesEditorSection: View {

    @Binding var rules: MatchRules

    var body: some View {
        Section("Match Settings") {
            Stepper(value: $rules.regularPeriodCount, in: 1...99) {
                LabeledContent("Regular periods", value: rules.regularPeriodCount, format: .number)
            }

            Stepper(value: $rules.overtimePeriodMaximumCount, in: 0...99) {
                LabeledContent("Overtime periods", value: rules.overtimePeriodMaximumCount, format: .number)
            }

            Stepper(value: $rules.regularPeriodTimeInterval, in: 0...30*60, step: 30) {
                let now: Date = .now
                let future = now.addingTimeInterval(rules.regularPeriodTimeInterval)
                let dateRange = now..<future

                LabeledContent("Regular time", value: dateRange, format: .timeDuration)
            }

            Stepper(value: $rules.overtimePeriodTimeInterval, in: 0...30*60, step: 30) {
                let now: Date = .now
                let future = now.addingTimeInterval(rules.overtimePeriodTimeInterval)
                let dateRange = now..<future

                LabeledContent("Overtime time", value: dateRange, format: .timeDuration)
            }

            Picker("Result rule", selection: $rules.resultEstablisher) {
                Text("Scored")
                    .tag(MatchResultEstabisher(rule: .scored))

                Text("Effective")
                    .tag(MatchResultEstabisher(rule: .effective))

                Text("Effective than scored")
                    .tag(MatchResultEstabisher(rule: .effectiveThanScored))
            }

            Picker("Effective score rule", selection: $rules.effectiveScoreEvaluator) {
                Text("Scored")
                    .tag(MatchEffectiveScoreEvaluator(rule: .scored))

                Text("W3 T2 L1")
                    .tag(MatchEffectiveScoreEvaluator(rule: .win3Tie2Lose1))
            }

            Picker("Scorable points", selection: $rules.allowedScoredPoints) {
                Text("Basket (1-2-3-2)")
                    .tag(MatchScoredPoint.basket)

                Text("Streetball (1-1-2-1)")
                    .tag(MatchScoredPoint.streetball)

                Text("Minibasket (1-1-2-1)")
                    .tag(MatchScoredPoint.minibasket)
            }

            Toggle("Allows Tie", isOn: $rules.isTieAllowed)
        }
    }
}
//struct MatchSettings: Codable, Hashable {
//    let regularPeriodCount: Int
//    let overtimePeriodMaximumCount: Int
//    let regularPeriodTimeInterval: TimeInterval
//    let overtimePeriodTimeInterval: TimeInterval

//    let resultEstablisher: MatchResultEstabisher
//    let effectiveScoreEvaluator: MatchEffectiveScoreEvaluator
//    let allowedScoredPoints: [MatchScoredPoint]
//    let isTieAllowed: Bool
//}

#Preview {
    Preview(rules: .ionicupFinal)
}

private struct Preview: View {
    
    @State var rules: MatchRules

    var body: some View {
        Form {
            MatchRulesEditorSection(rules: $rules)
        }
    }
}
