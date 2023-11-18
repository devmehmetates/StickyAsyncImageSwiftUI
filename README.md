# StickyAsyncImageSwiftUI

## How to use
Follow all the steps for 3rd party Swift packages and add the package to your project. If you have no idea, have a look here 👉🏻 <a href="https://github.com/devmehmetates/SwiftUIDragMenu#how-to-install-this-package"> Click here.</a>


Then add it to your project as follows.
```swift
// MARK: STEP 1
import StickyAsyncImageSwiftUI 
```

## Recommended Usage
```swift
import StickyAsyncImageSwiftUI 

struct ExampleView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                AnimatableAsyncImageView(urlPath: "url") { image in // Your Sticky View
                    image
                        .resizable()
                        .scaledToFill()
                }.modifier(StickyTopViewModifier(height: 40.0.responsiveH))
                
                // Your Views
            }
        }
    }
}
```

## Preview
![Simulator Screen Recording - iPhone 13 - 2022-10-10 at 22 28 00](https://user-images.githubusercontent.com/74152011/194940299-5bee110d-241d-48b8-b35e-c9a8c2335c53.gif)
