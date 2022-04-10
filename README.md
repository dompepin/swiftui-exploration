# SwiftUI Exploration

### Bottom Sheet

My goal was to see how we could build a prettier action sheet. Basically a sheet that presents a custom view from the bottom of the screen. 

Left to explore (WIP):
- Ability to drag the view down
- Max size: Make sure the view stays within the device viewing area
- iPad: Figure out how should the panel render on the iPad: Popover or something else?

<img src="https://github.com/dompepin/swiftui-exploration/blob/main/Documentation/ExamplesImages/BottomSheetExample.gif" width="250">





### Buttons

Exploring button styles that support basic configurations: 
* Foreground Color
* Background Color
* Border Color
* Border Width
* Corner Radius
* Inner Padding

<img src="https://github.com/dompepin/swiftui-exploration/blob/main/Documentation/ExamplesImages/ButtonsExample.gif" width="250">





### Pulsing Activity Indicator

Activity Indicator that pulses/fades objects in sequence. You can pulse any type of view: Shapes, Images, Text, etc.

<img src="https://github.com/dompepin/swiftui-exploration/blob/main/Documentation/ExamplesImages/PulsingActivityIndicatorsExample.gif" width="250">





### Toggles

Exploring Toggle where you can configure the shape of the background and knob in on and off statee

<img src="https://github.com/dompepin/swiftui-exploration/blob/main/Documentation/ExamplesImages/CustomToggleExample.gif" width="250">

Left to do: 
* Animate the transition of the knob. Seems there is an issue with
* Use <Content: View> instead of using AnyView
* Fix UITests: Knob does not seem to render in UI Tests

### Unit-Testing SwiftUI View

When building a view, it's not always easy to test your code. A lot of time, the result of your code can only be visually verified. I was looking for a way to generate screenshots of my views and compare them against source screenshots. I found the Point Free snapshot testing framework (https://github.com/pointfreeco/swift-snapshot-testing) and decided to give it a try. 

I need to play with this more, but here are my observation so far:

Pros:
* Reasonable speed to generate screenshots
* Can generate screenshots of any view
* Support for different snapshots strategy, not just images (Did not try yet).

Cons:
* Not a fan of all the __Snapshots__ folder. I had to create my own method in order to generate all the snapshots at the same location.
* If a test fails, it's a bit of a manual process to figure out what changed (unless it's the size of the view). I used https://www.diffchecker.com/image-diff/ for help
* Running the same tests on different simulators may cause the test to fail. 

Future exploration
* Can I generate app store screenshots?
* Create a CI job that runs these tests
