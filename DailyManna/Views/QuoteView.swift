
import  SwiftUI

struct QuoteView: View {
   @ObservedObject var viewModel: QuoteReminderViewModel
   @State private var showCategorySheet = false
   @State private var isPlaying = false
   @State private var showUpgradeAlert = false
   @State private var offset: CGFloat = 0
   @State private var opacity: Double = 1.0
   @State private var scale: CGFloat = 1.0  // 추가
   @Environment(\.colorScheme) var colorScheme
   @State private var progress: Double = 0
   @State private var timer: Timer?
   private let autoPlayDuration: Double = 12.0
  @State private var showSettings = false
    @State private var showThemeSheet = false
    @State private var settingsPosition: CGPoint = .zero
   
    var categoryButton: some View {
        Button(action: {
            showCategorySheet = true
        }) {
            if let category = viewModel.selectedCategory {
                HStack(spacing: 8) {
                    Text(category.icon)
                        .font(.system(size: 20))
                    Text(category.name)
                        .font(.system(size: 18, weight: .medium))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(Color(.systemGray5))
                )
            }
        }
        .foregroundColor(.white)
    }
   
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Top Navigation Bar
                HStack {
                    categoryButton
                    Spacer()
                    Button(action: {
                        showUpgradeAlert = true
                    }) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.yellow)
                            .opacity(0.8)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Quote Content
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        Spacer()
                        Text(viewModel.currentQuote?.text ?? "")
                            .font(.system(size: viewModel.settings.textSize, weight: .regular))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                            .minimumScaleFactor(0.5)
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(.white)
                        
                        Text(viewModel.currentQuote?.reference ?? "")
                            .font(.system(size: viewModel.settings.referenceSize, weight: .regular))
                            .foregroundColor(.gray)
                            .padding(.top, 24)
                        Spacer()
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .offset(y: offset)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    // 말씀 내용을 더 위로 이동
                    .offset(y: showSettings ? -200 : 0)  // -120에서 -200으로 수정
                    .animation(.spring(), value: showSettings)
                }
                .contentShape(Rectangle())
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            let translation = gesture.translation.height
                            offset = translation
                            scale = 1.0
                            opacity = 1.0 - (abs(translation) / 500.0)
                        }
                        .onEnded { gesture in
                            let translation = gesture.translation.height
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            
                            if translation < -50 {  // Swipe up for next quote
                                if viewModel.settings.hapticEnabled {
                                    generator.impactOccurred()
                                }
                                withAnimation(.easeOut(duration: 0.3)) {
                                    offset = -200
                                    opacity = 0
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    viewModel.showNextQuote()
                                    scale = 0.5
                                    opacity = 0
                                    offset = 0
                                    
                                    withAnimation(.spring(response: 1.0, dampingFraction: 0.9, blendDuration: 0.5)) {
                                        scale = 1.0
                                        opacity = 1
                                    }
                                }
                            } else if translation > 50 {  // Swipe down for previous quote
                                if viewModel.settings.hapticEnabled {
                                    generator.impactOccurred()
                                }
                                withAnimation(.easeOut(duration: 0.3)) {
                                    offset = 200
                                    opacity = 0
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    viewModel.showPreviousQuote()
                                    scale = 0.5
                                    opacity = 0
                                    offset = 0
                                    
                                    withAnimation(.spring(response: 1.0, dampingFraction: 0.9, blendDuration: 0.5)) {
                                        scale = 1.0
                                        opacity = 1
                                    }
                                }
                            } else {
                                withAnimation(.spring()) {
                                    offset = 0
                                    scale = 1.0
                                    opacity = 1
                                }
                            }
                        }
                )
                
                // Bottom Control Bar
                HStack(spacing: 60) {
                    Button(action: toggleFavorite) {
                        Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                    
                    Button(action: shareQuote) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                    
                    Button(action: toggleAutoPlay) {
                        playButton  // Use the custom playButton view
                    }
                    
                    Button(action: {
                        withAnimation {
                            showSettings.toggle()
                        }
                    }) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                }
                .padding(.bottom, 40)
                .padding(.top, 20)
            }
            
            // Settings Popup
            if showSettings {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showSettings = false
                        }
                    }
                
                VStack {
                    Spacer()
                    QuoteSettingsPopup(viewModel: viewModel, showThemeSheet: $showThemeSheet)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .padding(.bottom, 40)
                }
                .transition(.move(edge: .bottom))
                .zIndex(1)
            }
        }
        .background(viewModel.settings.theme.color.ignoresSafeArea())
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showCategorySheet) {
            CategorySheetView(selectedCategory: $viewModel.selectedCategory, viewModel: viewModel)
        }
        .sheet(isPresented: $showThemeSheet) {
            ThemeSelectionSheet(viewModel: viewModel)
        }
        .alert(isPresented: $showUpgradeAlert) {
            Alert(
                title: Text("Upgrade to Premium"),
                message: Text("Get access to all features and unlimited quotes!"),
                primaryButton: .default(Text("Upgrade Now")),
                secondaryButton: .cancel()
            )
        }
        .onTapGesture {
            if showSettings {
                withAnimation {
                    showSettings = false
                }
            }
        }
    }
    
    // CircularProgressButton 구현
    private var playButton: some View {
        ZStack {
            // Progress background circle
            Circle()
                .stroke(lineWidth: 2)
                .opacity(0.3)
                .foregroundColor(.white)
            
            // Progress indicator
            Circle()
                .trim(from: 0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                .foregroundColor(.white)
                .rotationEffect(Angle(degrees: -90))
            
            // Play/Pause icon
            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                .font(.system(size: 24))
                .foregroundColor(.white)
        }
        .frame(width: 32, height: 32)  // Increased size for better visibility
    }
    
    // toggleAutoPlay 함수를 수정하여 애니메이션을 부드럽게 처리
    private func toggleAutoPlay() {
        isPlaying.toggle()
        if isPlaying {
            progress = 0
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { currentTimer in
                guard currentTimer == self.timer else {
                    currentTimer.invalidate()
                    return
                }
                
                if self.progress < 1.0 {
                    withAnimation(.linear(duration: 0.1)) {
                        self.progress += 0.1 / self.viewModel.settings.autoPlayInterval
                    }
                } else {
                    currentTimer.invalidate()
                    self.timer = nil
                    self.handleQuoteTransition()
                }
            }
        } else {
            timer?.invalidate()
            timer = nil
            withAnimation {
                progress = 0
            }
        }
    }

    private func startNewTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { currentTimer in
            if self.progress < 1.0 {
                withAnimation(.linear(duration: 0.1)) {
                    self.progress += 0.1 / self.viewModel.settings.autoPlayInterval
                }
            } else {
                currentTimer.invalidate()
                self.timer = nil
                self.handleQuoteTransition()
            }
        }
    }

    private func handleQuoteTransition() {
        // Increase animation duration from 0.3 to 0.8 for slower exit animation
        withAnimation(.easeOut(duration: 0.8)) {
            offset = -200
            opacity = 0
            scale = 0.8
        }
        
        // Increase delay time to match the slower exit animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.viewModel.showNextQuote()
            
            // Reset position for entrance animation
            self.offset = 0
            self.scale = 0.8
            self.opacity = 0
            
            // Adjust entrance animation timing for smooth transition
            withAnimation(.spring(
                response: 0.6,      // Slightly increased response time
                dampingFraction: 0.8,
                blendDuration: 0.6  // Added blend duration for smoother animation
            )) {
                self.scale = 1.0
                self.opacity = 1
            }
            
            self.progress = 0
            if self.isPlaying {
                self.startNewTimer()
            }
        }
    }
   
   private func shareQuote() {
       guard let quote = viewModel.currentQuote else { return }
       let shareText = "\(quote.text)\n- \(quote.reference)"
       let av = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
       if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let window = windowScene.windows.first {
           window.rootViewController?.present(av, animated: true)
       }
   }
   
   private func toggleFavorite() {
       viewModel.toggleFavorite()
   }
}
