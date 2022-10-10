# StickyAsyncImageSwiftUI

## How to use
Follow all the steps for 3rd party Swift packages and add the package to your project. If you have no idea, have a look here 👉🏻 <a href="https://github.com/devmehmetates/SwiftUIDragMenu#how-to-install-this-package"> Click here.</a>


Then add it to your project as follows.
```swift
// MARK: STEP 1
import StickyAsyncImageSwiftUI 

// MARK: STEP 2
StickyAsyncImageSwiftUI(url: URL(string: "<some url>"), coordinateSpace: "<some key>")
```

## Recommended Usage
```swift
import StickyAsyncImageSwiftUI 

ScrollView {
    StickyAsyncImageSwiftUI(url: CommonConstants.exampleImageURL, coordinateSpace: "Sticky")
    // Your code
}.coordinateSpace(name: "Sticky")
    .ignoresSafeArea(edges: .top)
```

## Preview
![Simulator Screen Recording - iPhone 13 - 2022-10-10 at 22 28 00](https://user-images.githubusercontent.com/74152011/194940299-5bee110d-241d-48b8-b35e-c9a8c2335c53.gif)

## Preview Codes
```swift
import SwiftUI
import StickyAsyncImageSwiftUI

struct PreviewCodes: View {
    var body: some View {
        ScrollView {
            StickyAsyncImageSwiftUI(url: CommonConstants.exampleImageURL, coordinateSpace: "Sticky")
            ForEach(0..<100) { number in
                Group {
                    VStack {
                        Text(number.formatted())
                    }
                    Divider()
                }.frame(width: 90.0.responsiveW)
            }.padding(.top)
                
        }.coordinateSpace(name: "Sticky")
            .ignoresSafeArea(edges: .top)
    }
}
```

