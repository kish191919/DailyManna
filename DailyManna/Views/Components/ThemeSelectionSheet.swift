import SwiftUI

struct ThemeSelectionSheet: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: QuoteReminderViewModel
    @State private var isPremiumLocked = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Themes")
                    .font(.largeTitle)
                    .bold()
                
                // Theme Preview
                ZStack {
                    viewModel.settings.theme.color
                        .frame(width: 300, height: 400)
                        .cornerRadius(20)
                    
                    Text("Sample Text")
                        .foregroundColor(.white)
                        .font(.system(size: 24))
                }
                
                // Theme Options
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(QuoteTheme.allCases, id: \.self) { theme in
                            VStack {
                                theme.color
                                    .frame(width: 100, height: 150)
                                    .cornerRadius(10)
                                    .overlay(
                                        theme == viewModel.settings.theme ?
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.white, lineWidth: 2) : nil
                                    )
                                
                                if theme != .classic && theme != .midnight {
                                    Image(systemName: "crown.fill")
                                        .foregroundColor(.yellow)
                                }
                            }
                            .onTapGesture {
                                if theme == .classic || theme == .midnight {
                                    viewModel.settings.theme = theme
                                } else {
                                    isPremiumLocked = true
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationBarItems(trailing: Button("Done") { dismiss() })
        }
        .alert("Premium Feature", isPresented: $isPremiumLocked) {
            Button("Get Premium") {
                // Premium 구매 로직
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Unlock all themes with Premium!")
        }
    }
}
