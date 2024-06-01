import SwiftUI

extension PrimitiveButtonStyle where Self == MatchRowButtonStyle {

    static var matchRow: MatchRowButtonStyle {
        MatchRowButtonStyle()
    }
}

struct MatchRowButtonStyle: PrimitiveButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        GroupBox {
            Button(configuration)
                .tint(.primary)
        }
    }
}
