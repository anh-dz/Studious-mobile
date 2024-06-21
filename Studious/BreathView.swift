//
//  BreathView.swift
//  Studious
//
//  Created by Alex on 6/20/24.
//

import SwiftUI

struct BreathView: View {
    @State private var isInhaling = true
    @State private var isHolding = false
    @State private var radius: CGFloat = 100
    @State private var elapsedTime: TimeInterval = 0
    @State private var holdTime: TimeInterval = 0
    @State private var breathCount = 0
    @State private var scriptIndex = 0
    
    private let breathDuration: TimeInterval = 5.0 // Duration for inhale/exhale in seconds
    private let holdDuration: TimeInterval = 2.0 // Duration for holding the breath
    private let animationInterval: TimeInterval = 0.02 // Interval for the animation in seconds
    private let scripts = [
        "Cảm nhận chút không khí trong lành nào",
        "Thở ra một hơi thật dài và sẵn sàng",
        "Từ từ nhắm mắt lại và hít thở thật sâu. Cảm nhận không khí lấp đầy phổi của bạn",
        "Giữ hơi thở một lúc, sau đó chậm rãi thở ra bằng miệng. Hãy để những căng thẳng trôi ra cùng hơi thở bạn",
        "Chậm rãi hít thở thật sâu lần nữa, bạn sẽ cảm thấy như được lên thiên đàng",
        "Khi bạn thở ra, bạn sẽ cảm thấy thật sung sướng và sảng khoái",
        "Tiếp tục hít vào năng lượng tích cực và thở ra căng thẳng. Bạn sẽ cảm thấy bản thân trở nên thư thái hơn với từng hơi thở",
        "Bạn đang có cảm nhận gì rồi?"
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    Text(isInhaling ? (isHolding ? "Giữ..." : "Chậm rãi hít vào...") : (isHolding ? "Giữ..." : "Chậm rãi thở ra..."))
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                    
                    Circle()
                        .fill(Color(red: 51/255, green: 124/255, blue: 207/255))
                        .frame(width: self.radius * 2, height: self.radius * 2)
                        .animation(.linear(duration: self.animationInterval), value: radius)
                    
                    Spacer()
                    
                    Text(self.scripts[self.scriptIndex])
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .padding()
                        .multilineTextAlignment(.center)
                    
                    Text("Thực hiện: \(self.breathCount) lần")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                    
//                    Button(action: {
//                        exit(0)
//                    }) {
//                        Text("ĐÓNG")
//                            .font(.system(size: 18))
//                            .foregroundColor(.white)
//                            .padding()
//                            .background(Color.red)
//                            .cornerRadius(5)
//                    }
//                    .frame(width: 100, height: 50)
                    
                    Spacer().frame(height: geometry.safeAreaInsets.bottom)
                }
                .onAppear(perform: self.startAnimation)
            }
        }
    }
    
    private func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: animationInterval, repeats: true) { timer in
            if self.isHolding {
                self.holdTime += self.animationInterval
                if self.holdTime >= self.holdDuration {
                    self.isHolding = false
                    self.holdTime = 0
                    self.isInhaling.toggle()
                    self.elapsedTime = 0
                    if !self.isInhaling {
                        self.breathCount += 1
                        self.scriptIndex = (self.scriptIndex + 1) % self.scripts.count
                    }
                }
            } else {
                self.elapsedTime += self.animationInterval
                if self.isInhaling {
                    self.radius += 0.2
                } else {
                    self.radius -= 0.2
                }
                
                if self.elapsedTime >= self.breathDuration {
                    self.isHolding = true
                }
            }
            
            if self.radius >= 150 {
                self.isInhaling = false
            } else if self.radius <= 100 {
                self.isInhaling = true
            }
        }
    }
}

struct BreathView_Previews: PreviewProvider {
    static var previews: some View {
        BreathView()
    }
}
