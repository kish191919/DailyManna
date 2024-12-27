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
                Color(.systemGray6).edgesIgnoringSafeArea(.all)  // 다크모드 배경색
                
                VStack {
                    VStack(spacing: 20) {
                        // 메인 이미지
                        Image(systemName: "sun.max.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.orange)
                        
                        Text("DailyManna")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)  // 텍스트 색상 변경
                        
                        Text("Daily bread for your soul")
                            .font(.title3)
                            .foregroundColor(.gray)  // 설명 텍스트 색상 변경
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
                            .foregroundColor(.gray)  // 인용구 색상 변경
                        Text("Matthew 6:11")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)  // 참조 색상 변경
                    }
                    .padding(.top, 50)
                    .opacity(opacity)
                }
            }
            .preferredColorScheme(.dark)  // 강제 다크모드 설정
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
