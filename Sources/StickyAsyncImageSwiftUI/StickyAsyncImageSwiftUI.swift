import SwiftUI

@available(iOS 15.0, *)
public struct StickyTopAsyncImage: View {
    private let url: URL?
    private let size: CGFloat
    private let widthConstant: CGFloat = 100.0.responsiveW
    private let coordinateSpace: AnyHashable
    
    init(url: URL?, size: CGFloat? = nil, coordinateSpace: AnyHashable) {
        self.url = url
        self.size = size ?? 100.0.responsiveW
        self.coordinateSpace = coordinateSpace
    }
    
    public var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let height = (size.height + proxy.frame(in: .named(coordinateSpace)).minY * 1.5)
           
            AnimatedAsyncImageView(url, width: size.width, height: height < self.size ? self.size : height, cornerRadius: 0)
                .frame(width: widthConstant, height: self.size, alignment: .bottom)
        }.frame(width: widthConstant, height: self.size)
    }
}

#if DEBUG
struct SwiftUIPercentChart_Previews : PreviewProvider {
    @available(iOS 13.0, *)
    static var previews: some View {
        
        if #available(iOS 15.0, *) {
            ScrollView {
                StickyTopAsyncImage(url: URL(string: "https://soundjungle.de/wp-content/uploads/2022/10/1-Tate_McRae_main_photo_c_baeth.jpg"), coordinateSpace: "Sticky")
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
            
        } else {
            // Fallback on earlier versions
        }
    }
}
#endif

@available(iOS 15.0, *)
private struct AnimatedAsyncImageView: View {
    @State private var refleshState: Bool = false
    private let imageURL: URL?
    private let imageWidth: CGFloat
    private let imageHeight: CGFloat
    private let imageCornerRadius: CGFloat
    private let imageTintColor: Color = .accentColor
    private let isProgressViewDisable: Bool
    
    init(
        _ imageURL: URL?,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        cornerRadius: CGFloat? = nil,
        isProgressViewDisable: Bool? = nil
    ) {
        self.imageURL = imageURL
        self.imageWidth = width ?? 14.0.responsiveW
        self.imageHeight = height ?? self.imageWidth
        self.imageCornerRadius = cornerRadius ?? 10.0
        self.isProgressViewDisable = isProgressViewDisable ?? false
    }
    
    var body: some View {
        if refleshState {
            Rectangle()
                .frame(width: imageWidth, height: imageHeight, alignment: .center)
                .foregroundColor(.gray.opacity(0.2))
                .cornerRadius(imageCornerRadius)
        } else {
            AsyncImage(url: imageURL, scale: 1, transaction: .init(animation: .easeIn)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageWidth, height: imageHeight, alignment: .center)
                        .clipped()
                        .cornerRadius(imageCornerRadius)
                } else if phase.error != nil {
                    Image(systemName: "xmark")
                        .background(
                            Rectangle()
                            .frame(width: imageWidth, height: imageHeight, alignment: .center)
                            .foregroundColor(.gray.opacity(0.2))
                            .cornerRadius(imageCornerRadius)
                        ).onAppear {
                            refleshState = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    refleshState = false
                            }
                            }
                } else {
                    if isProgressViewDisable {
                        Rectangle()
                            .frame(width: imageWidth, height: imageHeight, alignment: .center)
                            .foregroundColor(.gray.opacity(0.2))
                            .cornerRadius(imageCornerRadius)
                    } else {
                        ProgressView()
                            .tint(imageTintColor)
                            .background(
                                Rectangle()
                                .frame(width: imageWidth, height: imageHeight, alignment: .center)
                                .foregroundColor(.gray.opacity(0.2))
                                .cornerRadius(imageCornerRadius)
                            )
                    }
                }
            }.frame(width: imageWidth, height: imageHeight, alignment: .center)
        }
    }
}
