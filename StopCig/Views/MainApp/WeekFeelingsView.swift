import SwiftUI

struct WeekFeelingsView: View {
    
    @Binding var smokerModel : SmokerModel?
    
    @State var initCircleX: CGFloat = 0
    @State var initCircleY: CGFloat = 0
    
    @State var circleX: CGFloat = 0
    @State var circleY: CGFloat = 0
        
    @State private var optionFrame: [CGRect] = [.zero, .zero, .zero, .zero]
    
    @State private var optionPoliceLength: [CGFloat] = [20, 20, 20, 20]
    
    @State private var lastIndexReturned: Int = -1
    
    @State private var circleFrame: CGRect = .zero
    @State private var policeLength: CGFloat = 20
    
    @State private var isAnimating = false
    @State private var isDragged = false
    
    @State private var choice = -1
    //@State private var isSheetPresented = false
    @State private var isSheetPresented : [Bool] = [false, false, false, false]
    
        
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.nightBlue
                    .edgesIgnoringSafeArea(.all)
                
                Text("Alors cette semaine ?")
                    .font(.custom("Quicksand-Light", size: 30))
                    .foregroundColor(.white)
                    .position(x: geo.size.width / 2, y: geo.size.height * 0.08)
                Text("Raconte nous comment ca s'est passé !")
                    .font(.custom("Quicksand-Light", size: 12))
                    .foregroundColor(.white)
                    .position(x: geo.size.width / 2, y: geo.size.height * 0.13)
                if (!isDragged) {
                    Text("Glisse le cercle !")
                        .font(.custom("Quicksand-Light", size: 15))
                        .foregroundColor(.white)
                        .position(x: geo.size.width / 2, y: geo.size.height * 0.95)
                }
                
                Circle()
                    .fill(Color.myYellow)
                    .frame(width: 30, height: 30)
                    .background(
                        GeometryReader { geometry in
                            Color.clear
                                .onAppear {
                                    self.circleFrame = geometry.frame(in: .global)
                                }
                                .onChange(of: geometry.frame(in: .global)) {
                                    self.circleFrame = geometry.frame(in: .global)
                                }
                        }
                    )
                    .position(x: self.circleX, y: self.circleY)
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                self.isDragged = true
                                let deltaX = value.location.x - initCircleX
                                let deltaY = value.location.y - initCircleY
                                let distance = sqrt(deltaX * deltaX + deltaY * deltaY)
                                let resistanceFactor: CGFloat = 0.005
                                let resistance = 1 / (1 + resistanceFactor * distance)
                                self.circleX = initCircleX + deltaX * resistance
                                self.circleY = initCircleY + deltaY * resistance
                                self.lastIndexReturned = self.checkColision()
                                self.choice = lastIndexReturned
                            })
                            .onEnded({ value in
                                withAnimation(.easeInOut) {
                                    self.isDragged = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        self.lastIndexReturned = self.checkColision()
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        self.circleX = self.initCircleX
                                        self.circleY = self.initCircleY
                                    }
                                    
                                    
                                }
                                
                            })
                    )
                
                ZStack {
                    TextView(text: "Bof 😖", optionFrame: $optionFrame[0], optionPoliceLength: $optionPoliceLength[0])
                        .position(x: geo.size.width * 0.25, y: geo.size.height * 0.6)
                    TextView(text: "Super 🔥", optionFrame: $optionFrame[1], optionPoliceLength: $optionPoliceLength[1])
                        .position(x: geo.size.width * 0.52, y: geo.size.height * 0.5)
                    TextView(text: "Dur 😰", optionFrame: $optionFrame[2], optionPoliceLength: $optionPoliceLength[2])
                        .position(x: geo.size.width * 0.75, y: geo.size.height * 0.6)
                    TextView(text: "impossible 🤯", optionFrame: $optionFrame[3], optionPoliceLength: $optionPoliceLength[3])
                        .position(x: geo.size.width * 0.52, y: geo.size.height * 0.7)
                }
                
            }
            .coordinateSpace(name: "global")
            .onChange(of: lastIndexReturned) {
                if lastIndexReturned >= 0 && lastIndexReturned < 4 {
                    startBreathingAnimation(index: self.lastIndexReturned)
                    let hepaticImpact = UIImpactFeedbackGenerator(style: .rigid)
                    hepaticImpact.impactOccurred()
                }
                stopBreathingAnimation(index: self.lastIndexReturned)
            }
            .onChange(of: isDragged) {
                if self.choice >= 0 && self.choice < 4  && !isDragged {
                    switch self.choice {
                    case 0:
                        isSheetPresented[0] = true
                    case 1:
                        isSheetPresented[1] = true
                    case 2:
                        isSheetPresented[2] = true
                    case 3:
                        isSheetPresented[3] = true
                    default:
                        break
                    }
                }
            }
            .onChange(of: isSheetPresented) {
                if !(isSheetPresented[0] && isSheetPresented[1] && isSheetPresented[2] && isSheetPresented[3]) {
                    self.lastIndexReturned = -1
                }
            }
            .onAppear() {
                self.initCircleX = geo.size.width / 2
                self.initCircleY = geo.size.height * 0.6
                self.circleX = geo.size.width / 2
                self.circleY = geo.size.height * 0.6
            }
            .sheet(isPresented: $isSheetPresented[0]) {
                BofValidationView(smokerModel: $smokerModel, isSheetPresented: $isSheetPresented[0])
            }
            .sheet(isPresented: $isSheetPresented[1]) {
                SuperValidationView(smokerModel: $smokerModel, isSheetPresented: $isSheetPresented[1])
            }
            .sheet(isPresented: $isSheetPresented[2]) {
                DurValidationView(smokerModel: $smokerModel, isSheetPresented: $isSheetPresented[2])
            }
            .sheet(isPresented: $isSheetPresented[3]) {
                ImpossibleValidationView(smokerModel: $smokerModel, isSheetPresented: $isSheetPresented[3])
            }
        }
    }
    
    func checkColision() -> Int {
        
        if optionFrame[0].intersects(circleFrame) {
            return 0
        }
        
        if optionFrame[1].intersects(circleFrame) {
           return 1
        }
        
        if optionFrame[2].intersects(circleFrame) {
            return 2
        }
        
        if optionFrame[3].intersects(circleFrame) {
            return 3
        }
        
        return -1
    }
    
    func startBreathingAnimation(index: Int) {
        withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
            self.isAnimating = true
            self.optionPoliceLength[index] = self.isAnimating ? 25 : 20
        }
    }
    
    func stopBreathingAnimation(index: Int) {
        withAnimation(Animation.easeInOut(duration: 1.0)) {
            self.isAnimating = false
            for i in 0..<4 {
                if i != self.lastIndexReturned {
                    self.optionPoliceLength[i] = 20
                }
            }
            
        }
    }
}

#Preview {
    WeekFeelingsView(smokerModel: .constant(nil))
}
