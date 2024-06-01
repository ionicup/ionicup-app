import SwiftUI
import OSLog

private let logger = Logger(subsystem: "Ionicup", category: "Court Editor")

struct CourtEditor: View {
    
    @Bindable var court: Court
    
    var body: some View {
        Form {
            Section("Display Name") {
                TextField("Display Name", text: $court.displayName)
                    .autocorrectionDisabled()
            }
        }
#if os(macOS)
        .padding()
#endif
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Edit court")
                    .fontWeight(.semibold)
            }
        }
#if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
    }
}

#Preview {
    NavigationStack {
        CourtEditor(court: Court(displayName: "Court A"))
    }
    .modelContainer(.preview)
}
