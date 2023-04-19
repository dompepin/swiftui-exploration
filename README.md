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

Exploring Toggle where you can configure the shape of the background and knob in on and off state.

<img src="https://github.com/dompepin/swiftui-exploration/blob/main/Documentation/ExamplesImages/CustomToggleExample.gif" width="250">

Left to do: 
* Animate the transition of the knob. Seems there is an issue with
* Use <Content: View> instead of using AnyView
* Fix UITests: Knob does not seem to render in UI Tests





### Pull-To-Refresh

Exploring the ability to do a custom Pull-To-Refresh animation.

<img src="https://github.com/dompepin/swiftui-exploration/blob/main/Documentation/ExamplesImages/CustomPullToRefreshExample.gif" width="250">

Left to do (and issues): 
* Create a `refreshable()` modifier that can be applied to a `ScrollView()` and a `List()`
* See if we can pass the PTR View/Animation
* This will not work with a `List()`
* I did not find a way to detect when the finger is touching the scroll view or not. This has some side effect where you can trigger the PTR by flicking the view down.



### Drag and Drop

Exploring the ability to do drag and drop custom objects.

##### Drag and dropping between Lists

Drag and Drop is supported by default within a lists, this example explores the ability to drag and drop an object/row between lists.

<img src="https://github.com/dompepin/swiftui-exploration/blob/main/Documentation/ExamplesImages/DragAndDropBetweenListsExample.gif" width="250">

Pros:
* You keep what the list offers by default: Move, re-order, delete, edit button.
 
Cons: 
* You are limited with how you can render the cell

##### Drag and dropping using a VStack

This example explores adding drag and drop to a LazyVStack (Since 'LIST' offer limited ways to customize their rows). 

<img src="https://github.com/dompepin/swiftui-exploration/blob/main/Documentation/ExamplesImages/DragAndDropVStackExampleView.gif" width="250">

Pros:
* You can have any design of cell you like.

Cons:
* You lose some of the out-of-the box functionality of the list: delete, move, edit.
* I could not get the drop action to recognize the Item UType. This issue was addressed by storing the dragged item in the drag closure.
* I could not get the insert '+' to show up when dragging.

Left to do (issues): 
* Drag and drop between VStack or another external source (ie. string from Safari)


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
