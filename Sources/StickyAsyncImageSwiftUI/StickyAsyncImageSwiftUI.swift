import SwiftUI

public struct StickyTopViewModifier: ViewModifier {
    var height: CGFloat
    var anchor: Alignment
    
    public init(height: CGFloat = 300, anchor: Alignment = .bottom) {
        self.height = height
        self.anchor = anchor
    }

    public func body(content: Content) -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            let calculatedHeight = (size.height + proxy.frame(in: .global).minY * 1.5)
            let actualHeight = max(calculatedHeight, height)
            content
                .frame(width: size.width, height: actualHeight, alignment: anchor)
                .clipped()
                .frame(width: 100.0.relativeToWidth, height: height, alignment: .bottom)
        }.frame(width: 100.0.relativeToWidth, height: height, alignment: .bottom)
    }
}


public extension View {
    func makeSticky(height: CGFloat = 300, anchor: Alignment = .bottom) -> some View {
        modifier(StickyTopViewModifier(height: height, anchor: anchor))
    }
}

#if DEBUG
#Preview {
    ScrollView {
        AsyncImage(url: .init(string: "https://i.ytimg.com/vi/HpJmv11xRAM/hq720.jpg?sqp=-oaymwE7CK4FEIIDSFryq4qpAy0IARUAAAAAGAElAADIQj0AgKJD8AEB-AHsCYAC0AWKAgwIABABGGEgZShXMA8=&rs=AOn4CLBH6cp_OFBEFZ73zx2QWVNiArWcXA")) { image in
            image.image?.resizable()
                .scaledToFill()
        }.makeSticky(height: 200)
    }
}
#endif
