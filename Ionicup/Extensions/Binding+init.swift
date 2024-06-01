import SwiftUI

extension Binding {
    
    init(_ base: Binding<Value?>, default value: Value) {
        self.init {
            base.wrappedValue ?? value
        } set: { newValue in
            base.wrappedValue = newValue
        }
    }
    
    func `default`<V>(_ value: V) -> Binding<V> where Value == V? {
        Binding<V>(self, default: value)
    }
}
