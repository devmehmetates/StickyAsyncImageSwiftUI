import SwiftUI

@available(iOS 13.0, *)
public struct StickyTopViewModifier: ViewModifier {
    var height: CGFloat = 30.0.responsiveH
    
    public init(height: CGFloat) {
        self.height = height
    }

    public func body(content: Content) -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            let calculatedHeight = (size.height + proxy.frame(in: .global).minY * 1.5)
            let actualHeight = max(calculatedHeight, height)
            content
                .frame(width: size.width, height: actualHeight, alignment: .bottom)
                .frame(width: 100.0.responsiveW, height: height, alignment: .bottom)
        }.frame(width: 100.0.responsiveW, height: height, alignment: .bottom)
    }
}

@available(iOS 15.0, *)
public struct AnimatableAsyncImageView<Content: View, Placeholder: View, ErrorView: View>: View {
    private var contentUrl: URL?
    private var scale: CGFloat
    private var transaction: Transaction
    @ViewBuilder private var content: (_ image: Image) -> Content
    @ViewBuilder private var placeholder: Placeholder
    @ViewBuilder private var errorView: ErrorView

    public init(
        urlPath: String? = nil,
        url: URL? = nil,
        scale: CGFloat = 1,
        transaction: Transaction = .init(animation: .spring),
        content: @escaping (_: Image) -> Content,
        @ViewBuilder placeholder: () -> Placeholder,
        @ViewBuilder errorView: () -> ErrorView
    ) {
        if let urlPath {
            contentUrl = URL(string: urlPath)
        } else {
            contentUrl = url
        }
        self.scale = scale
        self.transaction = transaction
        self.content = content
        self.placeholder = placeholder()
        self.errorView = errorView()
    }
    
    public var body: some View {
        AsyncImage(url: contentUrl, scale: scale, transaction: transaction) { phase in
            if let image = phase.image {
                content(image)
            } else if phase.error != nil {
                errorView
            } else {
                placeholder
            }
        }
    }
}

@available(iOS 15.0, *)
public extension AnimatableAsyncImageView where Placeholder == EmptyView, ErrorView == EmptyView {
    init(
        urlPath: String? = nil,
        url: URL? = nil,
        scale: CGFloat = 1,
        transaction: Transaction = .init(animation: .spring),
        content: @escaping (_: Image) -> Content
    ) {
        if let urlPath {
            contentUrl = URL(string: urlPath)
        } else {
            contentUrl = url
        }
        self.scale = scale
        self.transaction = transaction
        self.content = content
        self.placeholder = EmptyView()
        self.errorView = EmptyView()
    }
}

@available(iOS 15.0, *)
public extension AnimatableAsyncImageView where Placeholder == EmptyView {
    init(
        urlPath: String? = nil,
        url: URL? = nil,
        scale: CGFloat = 1,
        transaction: Transaction = .init(animation: .spring),
        content: @escaping (_: Image) -> Content,
        @ViewBuilder errorView: () -> ErrorView
    ) {
        if let urlPath {
            contentUrl = URL(string: urlPath)
        } else {
            contentUrl = url
        }
        self.scale = scale
        self.transaction = transaction
        self.content = content
        self.placeholder = EmptyView()
        self.errorView = errorView()
    }
}

@available(iOS 15.0, *)
public extension AnimatableAsyncImageView where ErrorView == EmptyView {
    init(
        urlPath: String? = nil,
        url: URL? = nil,
        scale: CGFloat = 1,
        transaction: Transaction = .init(animation: .spring),
        content: @escaping (_: Image) -> Content,
        @ViewBuilder placeholder: () -> Placeholder
    ) {
        if let urlPath {
            contentUrl = URL(string: urlPath)
        } else {
            contentUrl = url
        }
        self.scale = scale
        self.transaction = transaction
        self.content = content
        self.placeholder = placeholder()
        self.errorView = EmptyView()
    }
}

#if DEBUG
struct StickyAsyncImageSwiftUI_Previews : PreviewProvider {
    @available(iOS 13.0, *)
    static var previews: some View {
        
        if #available(iOS 15.0, *) {
            ExampleView()
        } else {
            // Fallback on earlier versions
        }
    }
}

@available(iOS 15.0, *)
struct ExampleView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                AnimatableAsyncImageView(urlPath: "https://picsum.photos/1200/1200") { image in
                    image
                        .resizable()
                        .scaledToFill()
                }.modifier(StickyTopViewModifier(height: 40.0.responsiveH))
                
                ForEach(0..<10) { number in
                    Group {
                        VStack {
                            Text(number.formatted())
                        }
                        Divider()
                    }.frame(width: 90.0.responsiveW)
                }.padding(.top)
            }

        }
    }
}
#endif

@available(iOS 15.0, *)
@available(iOS, introduced: 13.0, deprecated, renamed: "AnimatableAsyncImageView", message: "")
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

// MARK: - Deprecated
@available(iOS 15.0, *)
@available(*, deprecated, renamed: "StickyTopViewModifier", message: "")
public struct StickyTopView<Content: View>: View {
    private var content: Content
    let model: StickyViewModel
    
    public init(_ model: StickyViewModel = ._defaultModel, @ViewBuilder _ content: () -> Content) {
        self.model = model
        self.content = content()
    }
    
    public var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let calculatedHeight = (size.height + proxy.frame(in: .named(model.coordinateSpace)).minY * 1.5)
            let actualHeight = calculatedHeight < model.height ? model.height : calculatedHeight
            
            VStack {
                content
                    .frame(width: size.width, height: actualHeight, alignment: .bottom)
            }.frame(width: model.width, height: model.height, alignment: .bottom)
               
        }.frame(width: model.width, height: model.height, alignment: .bottom)
           
    }
}

@available(iOS 15.0, *)
@available(*, deprecated, renamed: "StickyTopViewModifier", message: "")
public struct StickyAsyncImageSwiftUI: View {
    private let url: URL?
    private let size: CGFloat
    private let widthConstant: CGFloat = 100.0.responsiveW
    private let coordinateSpace: AnyHashable
    private let isGradientOn: Bool
    private let linearGradient: LinearGradient
    
    public init(url: URL?, size: CGFloat? = nil, coordinateSpace: AnyHashable, isGradientOn: Bool? = nil, linearGradient: LinearGradient? = nil) {
        self.url = url
        self.size = size ?? 100.0.responsiveW
        self.coordinateSpace = coordinateSpace
        self.isGradientOn = isGradientOn ?? false
        self.linearGradient = linearGradient ?? LinearGradient(colors: [.clear, .accentColor], startPoint: .top, endPoint: .bottom)
    }
    
    public var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let height = (size.height + proxy.frame(in: .named(coordinateSpace)).minY * 1.5)
           
            AnimatedAsyncImageView(url, width: size.width, height: height < self.size ? self.size : height, cornerRadius: 0)
                .frame(width: widthConstant, height: self.size, alignment: .bottom)
            
            if isGradientOn {
                Rectangle()
                    .frame(width: size.width, height: height < self.size ? self.size : height, alignment: .bottom)
                    .frame(width: widthConstant, height: self.size, alignment: .bottom)
                    .foregroundStyle(linearGradient)
            }
        }.frame(width: widthConstant, height: self.size)
    }
}

@available(iOS 15.0, *)
@available(iOS, introduced: 13.0, deprecated, renamed: "StickyTopViewModifier", message: "Deleted")
public struct StickyViewModel {
    let width: CGFloat = 100.0.responsiveW
    var height: CGFloat = 100.0.responsiveW
    let coordinateSpace: AnyHashable
    var linearGradient: LinearGradient?
    
    public static let _defaultModel: StickyViewModel = StickyViewModel(coordinateSpace: "Sticky")
}
