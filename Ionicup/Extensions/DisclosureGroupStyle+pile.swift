import SwiftUI
import VariadicViews

extension DisclosureGroupStyle where Self == PileDisclosureGroupStyle {

    static var pile: PileDisclosureGroupStyle {
        PileDisclosureGroupStyle(alwaysExpanded: false)
    }

    static func pile(alwaysExpanded: Bool) -> PileDisclosureGroupStyle {
        PileDisclosureGroupStyle(alwaysExpanded: alwaysExpanded)
    }
}

struct PileDisclosureGroupStyle: DisclosureGroupStyle {

  @Environment(\.self) private var environment

    let alwaysExpanded: Bool

    func makeBody(configuration: Configuration) -> some View {
        MultiVariadicView(configuration.content) { views in

            let isExpanded = alwaysExpanded || views.count < 2 || configuration.isExpanded

            VStack(spacing: 2) {
                HStack(alignment: .lastTextBaseline) {
                    configuration.label
                        .font(.caption.weight(.bold))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    if !alwaysExpanded, configuration.isExpanded {
                        Toggle(isOn: configuration.$isExpanded.animation()) {
                            Label("Show less", systemImage: "chevron.up")
                        }
                        .font(.caption.weight(.semibold))
                        .toggleStyle(.button)
                        .buttonStyle(.plain)
                    }
                }.foregroundStyle(.secondary)

                VStack {
                    let firstViewID = views.first?.id
                  let layout = isExpanded ? AnyLayout(VStackLayout()) : AnyLayout(ZStackLayout(alignment: .top))
                    let hiddenBottomPadding: CGFloat = switch views.count {
                    case 0: 0
                    case 1: 0
                    case 2: 10
                    default: 20
                    }
                  
                  layout {
                    ForEach(views) { view in
                      let isHidden = view.id != firstViewID && !isExpanded
                      let index = views.firstIndex { $0.id == view.id } ?? 0
                      let zIndex = views.count - index
                      let hiddenOpacity: Double = (3.0 - Double(index)) / 3
                      let hiddenScale: Double = max(0, 1 - 0.05 * Double(index))
                      let hiddenOffsetY: Double = 10 * Double(index)


                      view
                        .opacity(isHidden ? hiddenOpacity : 1)
                        .background {
                          Rectangle()
                            .overlay(.background)
                            .mask {
                              view
                            }
                        }
                        .background(alignment: .leading) {
                            view[PileItemTitleKey.self]
                              .font(.caption.weight(.semibold))
                              .foregroundStyle(.secondary)
                              .fixedSize()
                              .frame(width: 0)
                              .rotationEffect(.degrees(-90))
                              .offset(x: isHidden ? 8  : -8)
                              .opacity(isHidden ? hiddenOpacity : 1)
                        }
                        .zIndex(Double(zIndex))
                        .scaleEffect(isHidden ? hiddenScale : 1)
                        .offset(y: isHidden ? hiddenOffsetY : 0)
                    }
                  }
                    .padding(.bottom, isExpanded ? 0 : hiddenBottomPadding)
                }
                .highPriorityGesture(
                    TapGesture().exclusively(before: LongPressGesture(minimumDuration: .infinity))
                    .onEnded { _ in
                      withAnimation {
                        configuration.isExpanded = true
                      }
                    },
                  including: isExpanded ? .subviews : .all
                )
            }
        }
    }
}

struct PileItemTitleKey: ViewTraitKey {
  static var defaultValue: Text?
}

extension View {
  func pileItemTitle(_ title: Text) -> some View {
    trait(key: PileItemTitleKey.self, value: title)
  }
}
