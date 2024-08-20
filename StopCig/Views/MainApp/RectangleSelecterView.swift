import SwiftUI

struct RectangleSelecterView: View {
    @Binding var currentPage: Int
    
    private let littleY: CGFloat = 0.15
    private let bigY: CGFloat = 0.19
    
    @State private var scrollOffset: CGFloat = 0.0
    
    @State private var rectangleDimensionArray: [CGFloat] = [0.19, 0.15, 0.15]
    @State private var rectangleIndex : Int = 0
    @State private var rectanglePrevIndex : Int  = 0
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(0..<rectangleDimensionArray.count, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.nightBlue))
                            .frame(width: geo.size.width * 0.80, height: geo.size.height * rectangleDimensionArray[index])
                            .background(
                                GeometryReader { innerGeo in
                                    Color.clear.preference(key: ScrollOffsetKey.self, value: innerGeo.frame(in: .global).minX)
                                }
                            )
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .safeAreaPadding(.horizontal, 40)
            .onPreferenceChange(ScrollOffsetKey.self) { value in
                scrollOffset = value
                print(value)
            }
            .onChange(of: scrollOffset) { _, _ in
                rectangleIndex = getRectangleIndex(scrollOffset: scrollOffset)
                modifyRectangleHeight(rectangleIndex: rectangleIndex)
            }
        }
    }
    
    struct ScrollOffsetKey: PreferenceKey {
        static var defaultValue: CGFloat = 0.0
        
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }
    
    private func getRectangleIndex(scrollOffset: CGFloat) -> Int {
        if scrollOffset >= 600 && scrollOffset <= 700 {
            return 0
        }
        else if scrollOffset >= 300 && scrollOffset <= 600 {
            return 1
        }
        else if scrollOffset >= 0 && scrollOffset <= 300 {
            return 2
        }
        return -1
    }
    
    private func modifyRectangleHeight(rectangleIndex: Int) {
        switch rectangleIndex {
        case 0:
            withAnimation(.easeInOut(duration: 0.2)) {
                rectangleDimensionArray = [bigY, littleY, littleY]
            }
        case 1:
            withAnimation(.easeInOut(duration: 0.2)) {
                rectangleDimensionArray = [littleY, bigY, littleY]
            }
        case 2:
            withAnimation(.easeInOut(duration: 0.2)) {
                rectangleDimensionArray = [littleY, littleY, bigY]
            }
        default:
            break
        }
            
    }
}

#Preview {
    RectangleSelecterView(currentPage: .constant(1))
}
