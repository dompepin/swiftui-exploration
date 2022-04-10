//
//  PulsingActivityIndicator.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2022-02-12.
//

import SwiftUI

/// Activity Indicator that pulses/fades objects in sequence. You can pulse any type of view: Shapes, Images, Text, etc.
public struct PulsingActivityIndicator: View {
    
    // MARK: Structs
    
    // Configuration of the pulsing activity indicator
    public struct Configuration {
        /// The space between each views
        var spacing: CGFloat
        /// Views that you want to see pulse
        var views: [AnyView]
        /// The duration that a view will take to change complete it's pulsing animation
        var singlePulseDuration: CGFloat // TODO: fix as this is 1/2 a pulse duration
        /// The delay between the start of each views animation
        var delay: CGFloat
        /// The scale change during the animation. Values between 0 and 1 will decrease the view. Values above will increas the view size.
        var scale: CGFloat
        /// Defines how much you to change the opacity during the animation.
        var fade: CGFloat
        
        init(views: [AnyView],
             spacing: CGFloat,
             singlePulseDuration: CGFloat,
             delay: CGFloat,
             scale: CGFloat,
             fade: CGFloat
        ) {
            self.views = views
            self.spacing = spacing
            self.singlePulseDuration = singlePulseDuration
            self.delay = delay
            self.scale = scale
            self.fade = fade
        }
    }
    
    // MARK: Properties
    
    private let config: Configuration
    @State private var animate = false
    
    // MARK: Lifecycle
    
    public var body: some View {
        let delay1 = config.singlePulseDuration/CGFloat(config.views.count)
        HStack(alignment: .center, spacing: config.spacing) {
            ForEach((0...config.views.count-1), id: \.self) {
                config.views[$0]
                    .scaleEffect(animate ? 1.0 : config.scale)
                    .opacity(animate ? 1.0 : config.fade)
                    .animation(.easeInOut(duration: config.singlePulseDuration)
                                .repeatForever()
                                .delay(delay1 * CGFloat($0)), value: animate)
            }
        }
        .onAppear {
            animate = true
        }
    }
    
    public init(config: Configuration) {
        self.config = config
    }
}

// MARK: Examples


public extension PulsingActivityIndicator.Configuration {
    static let example_three_shapes: PulsingActivityIndicator.Configuration = .init(views: [AnyView(Circle().fill(Color.red).frame(width:20, height:20)),
                                                                                            AnyView(Triangle().fill(Color.blue).frame(width:20, height:20)),
                                                                                            AnyView(Rectangle().fill(Color.yellow).frame(width:20, height:20))
                                                                                           ],
                                                                                    spacing: 8,
                                                                                    singlePulseDuration: 0.5,
                                                                                    delay: 0.2,
                                                                                    scale: 0.5,
                                                                                    fade: 0.5)
    
    static let example_text: PulsingActivityIndicator.Configuration = .init(views: [AnyView(Text("L")),
                                                                                    AnyView(Text("O")),
                                                                                    AnyView(Text("A")),
                                                                                    AnyView(Text("D")),
                                                                                    AnyView(Text("I")),
                                                                                    AnyView(Text("N")),
                                                                                    AnyView(Text("G"))
                                                                                   ],
                                                                            spacing: 1,
                                                                            singlePulseDuration: 0.5,
                                                                            delay: 0.1,
                                                                            scale: 0.75,
                                                                            fade: 1)
    
    static let example_one_view: PulsingActivityIndicator.Configuration = .init(views: [AnyView(Circle().fill(Color.green).frame(width:40, height:40))],
                                                                                spacing: 1,
                                                                                singlePulseDuration: 0.5,
                                                                                delay: 0.01,
                                                                                scale: 0.75,
                                                                                fade: 0.2)
    
    static let example_shimmer: PulsingActivityIndicator.Configuration = .init(views: (1...200).map({ _ in AnyView(Rectangle().fill(Color.purple).frame(width:1, height:20)) }),
                                                                               spacing: 0,
                                                                               singlePulseDuration: 1,
                                                                               delay: 0.1,
                                                                               scale: 1,
                                                                               fade: 0.5)
    
    static let example_four_circles: PulsingActivityIndicator.Configuration = .init(views: [AnyView(Circle().fill(Color(.sRGB, red: 96.0/255.0, green: 153.0/255.0, blue: 45.0/255.0, opacity: 1.0)).frame(width:20, height:20)),
                                                                                            AnyView(Circle().fill(Color(.sRGB, red: 73.0/255.0, green: 198.0/255.0, blue: 229.0/255.0, opacity: 1.0)).frame(width:20, height:20)),
                                                                                            AnyView(Circle().fill(Color(.sRGB, red: 247.0/255.0, green: 203.0/255.0, blue: 21.0/255.0, opacity: 1.0)).frame(width:20, height:20)),
                                                                                            AnyView(Circle().fill(Color(.sRGB, red: 226.0/255.0, green: 132.0/255.0, blue: 19.0/25.0, opacity: 1.0)).frame(width:20, height:20))
                                                                                           ],
                                                                                    spacing: 16,
                                                                                    singlePulseDuration: 0.5,
                                                                                    delay: 0.2,
                                                                                    scale: 0.5,
                                                                                    fade: 1.0)
    
    
    static let example_images: PulsingActivityIndicator.Configuration = .init(views: [AnyView(Image(systemName: "airplane").resizable().foregroundColor(Color.blue).frame(width:10, height:10)),
                                                                                      AnyView(Image(systemName: "airplane").resizable().foregroundColor(Color.blue).frame(width:20, height:20)),
                                                                                      AnyView(Image(systemName: "airplane").resizable().foregroundColor(Color.blue).frame(width:30, height:30)),
                                                                                     ],
                                                                              spacing: 8,
                                                                              singlePulseDuration: 0.75,
                                                                              delay: 0.2,
                                                                              scale: 0.75,
                                                                              fade: 0.72)
}

// MARK: Preview

struct PulsingActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        VStack (alignment: .center, spacing: 16) {
            PulsingActivityIndicator(config: .example_three_shapes)
            PulsingActivityIndicator(config: .example_text)
            PulsingActivityIndicator(config: .example_one_view)
            PulsingActivityIndicator(config: .example_shimmer)
                .cornerRadius(20)
            PulsingActivityIndicator(config: .example_four_circles)
            PulsingActivityIndicator(config: .example_images)
        }
    }
}

