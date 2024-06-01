import SwiftUI

extension View {
    
    func onFirstAppear(perform action: (() -> Void)? = nil) -> some View {
        modifier(FirstAppearanceActionModifier(appear: action))
    }
}

private struct FirstAppearanceActionModifier: ViewModifier {
    
    var appear: (() -> Void)?
    
    @State private var appeared = false
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if !appeared {
                    appeared = true
                    appear?()
                }
            }
    }
}
