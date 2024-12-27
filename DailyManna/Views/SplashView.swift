import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)
                
                VStack {
                    VStack(spacing: 20) {
                        // 메인 이미지
                        Image(systemName: "sun.max.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.orange)
                        
                        // 앱 이름
                        Text("DailyManna")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.black.opacity(0.80))
                        
                        // 앱 설명
                        Text("Daily bread for your soul")
                            .font(.title3)
                            .foregroundColor(.black.opacity(0.60))
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.2)) {
                            self.size = 0.9
                            self.opacity = 1.0
                        }
                    }
                    
                    // 성경 구절
                    VStack {
                        Text("\"Give us this day our daily bread\"")
                            .font(.system(size: 16, weight: .medium))
                            .italic()
                            .foregroundColor(.black.opacity(0.6))
                        Text("Matthew 6:11")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.black.opacity(0.5))
                    }
                    .padding(.top, 50)
                    .opacity(opacity)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}
