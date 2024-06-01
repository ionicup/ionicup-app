import SwiftUI
import OSLog

private let logger = Logger(subsystem: "Ionicup", category: "Event Editor")

struct EventEditor: View {
    
    @Bindable var event: Event
    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        Form {
            Section("Display Name") {
                TextField("Display Name", text: $event.displayName.default(""))
                    .autocorrectionDisabled()
            }
            
            Section("Display Description") {
                TextEditor(text: $event.displayDescription.default(""))
            }
            
            Section("Date") {
                DatePicker("Date", selection: $event.date.default(event.season?.dates.first?.date ?? .now))
            }
            
            Section("Court") {
                Picker("Court", selection: $event.court) {
                    Section {
                        Text("None")
                            .tag(Court?.none)
                    }
                    
                    Section {
                        ForEach(event.season?.courts ?? []) { court in
                            Text(court.displayName)
                                .tag(court as Optional)
                        }
                    }
                }
            }
            
            Section("Match") {
                Picker(selection: $event.match) {
                    Section {
                        Text("None")
                            .tag(Match?.none)
                    }
                    
                    Section {
                        ForEach(event.season?.matches ?? []) { match in
                            MatchRow(match: match)
                                .padding(.vertical)
                                .tag(match as Optional)
                        }
                    }
                } label: {
                    Text("Match")
                        .frame(maxWidth: event.match == nil ? nil : .zero)
                }
                .pickerStyle(.navigationLink)
            }
        }
#if os(macOS)
        .padding()
#endif
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Edit event")
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
        EventEditor(event: Event(displayName: "Grande evento"))
    }
    .modelContainer(.preview)
}
