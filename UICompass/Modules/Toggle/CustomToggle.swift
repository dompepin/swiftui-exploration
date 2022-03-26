import SwiftUI
import Combine

// TODO: Animate transition of knob. Figure out why I can only animate the background or the toggle, but not both? If I animate both, the binding value stops working :(
// TODO: Pass a <Content: View> instead of using AnyView

/// A horizontal slider control that toggles between on and off states.
///
/// You can create your own toggle, by creating a `CustomToggle.Configuration`
/// that defines 4 views: on/off knob and background views.
public struct CustomToggle: View {
    
    
    /// Configuration of the toggle
    public struct Configuration {
        var onKnob: AnyView
        var offKnob: AnyView?
        var onBackground: AnyView
        var offBackground: AnyView?
        var borderWidth: CGFloat
        var knobWidth: CGFloat?
        
        
        /// Configuration of the toggle
        /// - Parameters:
        ///   - onKnob: Knob view when the toggle is on
        ///   - offKnob: Knob view when the toggle is off. If not defined, the onKnob view will be used.
        ///   - onBackground: Background view when the toggle is on.
        ///   - offBackground: Background view when the toggle is off. If not defined, the offBackground view will be used.
        ///   - borderWidth: Width of the border surrounding the toggle
        ///   - knobWidth: Width of the knob. The height of the knob will be defined by the toggle height less the border width.
        public init(@ViewBuilder onKnob: () -> AnyView,
                    offKnob: (() -> AnyView)?,
                    @ViewBuilder onBackground: () -> AnyView,
                    offBackground: (() -> AnyView)?,
                    borderWidth: CGFloat,
                    knobWidth: CGFloat? = nil) {
            self.onKnob = onKnob()
            self.offKnob = offKnob?()
            self.onBackground = onBackground()
            self.offBackground = offBackground?()
            self.borderWidth = borderWidth
            self.knobWidth = knobWidth
        }
    }
    
    // MARK: Properties
    
    private let config: Configuration
    @Binding private var isOn: Bool
    @State private var size: CGSize = .zero
    @State private var xOffset: CGFloat = 0
    @State private var isDragging: Bool = false
    
    // MARK: Body
    
    public var body: some View {
        ZStack(alignment: .center) {
            let _ = calculateKnobPosition()
            GeometryReader { geometry in
                toggleBackground()
                    .getSize($size)
                toggleKnob()
                    .padding(.all, config.borderWidth)
                    .frame(width: knobWidth(), height: knobHeight())
                    .offset(x: min(max(xOffset, knobMinPosition()), knobMaxPosition())) // TODO: Convert to clamped method
                    .animation(.interactiveSpring(), value: xOffset)
            }
        }
        .onTapGesture {
            isOn.toggle()
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    isDragging = true
                    if isOn {
                        xOffset = size.width - knobWidth() + value.translation.width
                    } else {
                        xOffset = value.translation.width + config.borderWidth
                    }
                }
                .onEnded { value in
                    isOn = isDraggingInOnPosition(xTranslation: xOffset)
                    isDragging = false
                })
    }
    
    // MARK: Lifecycle
    
    public init(isOn: Binding<Bool>, config: Configuration) {
        self._isOn = isOn
        self.config = config
    }
    
    
    // MARK: Views
    
    func toggleBackground() -> some View {
        let isOn = isDraggingInOnPosition(xTranslation: xOffset)
        return ZStack (alignment: .center) {
            config.offBackground ?? config.onBackground
            config.onBackground.opacity(isOn ? 1 : 0)
                .animation(.linear(duration: 0.3), value: isOn)
            
        }
    }
    
    
    func toggleKnob() -> some View {
        // TODO: Figure out why this is breaking the biding property
        //        let isOn = isDraggingInOnPosition(xTranslation: xOffset)
        return isOn ? config.onKnob : config.offKnob ?? config.onKnob
    }
    
    // MARK: Private
    
    private func calculateKnobPosition() -> Bool {
        if isDragging { return false}
        DispatchQueue.main.async {
            xOffset = isOn ? knobMaxPosition() : knobMinPosition()
        }
        return true
    }
    
    func isDraggingInOnPosition(xTranslation: CGFloat) -> Bool {
        xTranslation > maxTranslation() / 2
    }
    
    func knobHeight() -> CGFloat {
        max(0, size.height)
    }
    
    func knobMinPosition() -> CGFloat {
        0
    }
    
    func knobMaxPosition() -> CGFloat {
        size.width - knobWidth()
    }
    
    func knobWidth() -> CGFloat {
        if let width = config.knobWidth {
            return width
        } else {
            return knobHeight()
        }
    }
    
    func maxTranslation() -> CGFloat {
        return size.width - knobWidth()
    }
}

// MARK: default CustomToggle.Configuration
public extension CustomToggle.Configuration {
    static let systemRoundedRectangle = CustomToggle.Configuration(
        onKnob: {
            AnyView(RoundedRectangle(cornerRadius: 6).fill(Color.white))
        },
        offKnob: nil,
        onBackground: {
            AnyView(RoundedRectangle(cornerRadius: 8).fill(Color(UIColor.systemGreen)))
        },
        offBackground: {
            AnyView(RoundedRectangle(cornerRadius: 8).fill(Color(UIColor.systemGray5)))
        },
        borderWidth: 2)
    
}

// MARK: Previews

struct CustomToggle_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CustomToggle(isOn: .constant(true), config: .example1)
                .frame(height: 44)
            CustomToggle(isOn: .constant(false), config: .example1)
                .frame(height: 44)
            
            CustomToggle(isOn: .constant(true), config: .systemRoundedRectangle)
                .frame(height: 44)
            CustomToggle(isOn: .constant(false), config: .systemRoundedRectangle)
                .frame(height: 44)
        }
        .padding()
    }
}

fileprivate extension CustomToggle.Configuration {
    static let example1: CustomToggle.Configuration = .init(onKnob: { AnyView(Circle().fill(Color.orange)) },
                                                            offKnob: { AnyView(Circle().fill(Color.purple)) },
                                                            onBackground: { AnyView(Capsule().fill(Color.gray)) },
                                                            offBackground: { AnyView(Capsule().fill(Color.black)) },
                                                            borderWidth: 4)
}

