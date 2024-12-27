
import  SwiftUI

struct QuoteView: View {
   @ObservedObject var viewModel: QuoteReminderViewModel
   @State private var showCategorySheet = false
   @State private var isPlaying = false
   @State private var showUpgradeAlert = false
   @State private var offset: CGFloat = 0
   @State private var opacity: Double = 1.0
   @Environment(\.colorScheme) var colorScheme
   
   var backgroundColor: Color {
       Color(.systemGray6)
   }
   
   var categoryButton: some View {
       Button(action: {
           showCategorySheet = true
       }) {
           if let category = viewModel.selectedCategory {
               HStack(spacing: 4) {
                   Text(category.icon)
                       .font(.system(size: 18))
                   Text(category.name)
                       .font(.system(size: 16, weight: .medium))
               }
               .padding(.horizontal, 16)
               .padding(.vertical, 8)
               .background(
                   Capsule()
                       .fill(Color.orange.opacity(0.2))
               )
           }
       }
   }
   
   var body: some View {
       VStack(spacing: 0) {
           HStack {
               categoryButton
               Spacer()
               Button(action: {
                   showUpgradeAlert = true
               }) {
                   Image(systemName: "crown.fill")
                       .font(.system(size: 22))
                       .foregroundColor(.orange)
               }
           }
           .padding()
           
           GeometryReader { geometry in
              VStack(spacing: 20) {
                  Text(viewModel.currentQuote?.text ?? "")
                      .font(.system(size: 32, weight: .medium))
                      .multilineTextAlignment(.center)
                      .padding(.horizontal, 40)
                      .padding(.vertical, 20)
                      .minimumScaleFactor(0.5)

                  Text(viewModel.currentQuote?.reference ?? "")
                      .font(.system(size: 20, weight: .medium))
                      .foregroundColor(.gray)
                      .padding(.top, 20)
              }
              .frame(width: geometry.size.width, height: geometry.size.height)
              .offset(y: offset)
              .opacity(opacity)
           }
           .contentShape(Rectangle())  // 전체 영역을 터치 가능하게 만듦
           .gesture(
                 DragGesture()
                     .onChanged { gesture in
                         let translation = gesture.translation.height
                         offset = translation
                         opacity = 1.0 - (abs(translation) / 500.0)
                     }
                     .onEnded { gesture in
                         let translation = gesture.translation.height
                         let generator = UIImpactFeedbackGenerator(style: .medium)
                         
                         if translation < -50 {  // 위로 스와이프
                             generator.impactOccurred()
                             withAnimation(.spring()) {
                                 offset = -UIScreen.main.bounds.height
                                 opacity = 0
                             }
                             DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                 viewModel.showNextQuote()
                                 offset = UIScreen.main.bounds.height
                                 opacity = 0
                                 withAnimation(.spring()) {
                                     offset = 0
                                     opacity = 1
                                 }
                             }
                         } else if translation > 50 {  // 아래로 스와이프
                             generator.impactOccurred()
                             withAnimation(.spring()) {
                                 offset = UIScreen.main.bounds.height
                                 opacity = 0
                             }
                             DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                 viewModel.showPreviousQuote()
                                 offset = -UIScreen.main.bounds.height
                                 opacity = 0
                                 withAnimation(.spring()) {
                                     offset = 0
                                     opacity = 1
                                 }
                             }
                         } else {
                             withAnimation(.spring()) {
                                 offset = 0
                                 opacity = 1
                             }
                         }
                     }
             )
           
           HStack(spacing: 50) {
               Button(action: shareQuote) {
                   Image(systemName: "square.and.arrow.up")
                       .font(.system(size: 26))
                       .foregroundColor(.orange)
               }
               
               Button(action: toggleFavorite) {
                   Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                       .font(.system(size: 26))
                       .foregroundColor(.red)
               }
               
               Button(action: toggleAutoPlay) {
                   Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                       .font(.system(size: 28))
                       .foregroundColor(.orange)
               }
           }
           .padding(.bottom, 40)
       }
       .background(Color(.systemGray6).ignoresSafeArea())
       .preferredColorScheme(.dark)
       .sheet(isPresented: $showCategorySheet) {
           CategorySheetView(selectedCategory: $viewModel.selectedCategory, viewModel: viewModel)
       }
       .alert(isPresented: $showUpgradeAlert) {
           Alert(
               title: Text("Upgrade to Premium"),
               message: Text("Get access to all features and unlimited quotes!"),
               primaryButton: .default(Text("Upgrade Now")),
               secondaryButton: .cancel()
           )
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
   
   private func toggleAutoPlay() {
       isPlaying.toggle()
       if isPlaying {
           viewModel.startAutoPlay()
       } else {
           viewModel.stopAutoPlay()
       }
   }
}
