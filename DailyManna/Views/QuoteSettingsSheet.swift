
import SwiftUI

struct QuoteSettingsSheet: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: QuoteReminderViewModel
    @State private var isPremiumLocked = false
    
    var body: some View {
        NavigationView {
            List {
                // 텍스트 크기 조절
                Section(header: Text("Text Size")) {
                    VStack(alignment: .leading) {
                        Text("Bible Verse")
                        Slider(
                            value: $viewModel.settings.textSize,
                            in: 20...40,
                            step: 1
                        ) {
                            Text("Text Size")
                        } minimumValueLabel: {
                            Text("A").font(.system(size: 14))
                        } maximumValueLabel: {
                            Text("A").font(.system(size: 20))
                        }
                        
                        Text("Reference")
                        Slider(
                            value: $viewModel.settings.referenceSize,
                            in: 16...32,
                            step: 1
                        ) {
                            Text("Reference Size")
                        } minimumValueLabel: {
                            Text("A").font(.system(size: 12))
                        } maximumValueLabel: {
                            Text("A").font(.system(size: 18))
                        }
                    }
                }
                
                // 자동 재생 설정
                Section(header: Text("Auto Play")) {
                    Picker("Interval", selection: $viewModel.settings.autoPlayInterval) {
                        Text("8 seconds").tag(8.0)
                        Text("12 seconds").tag(12.0)
                        Text("16 seconds").tag(16.0)
                    }
                }
                
                // 햅틱 피드백
                Section {
                    Toggle("Haptic Feedback", isOn: $viewModel.settings.hapticEnabled)
                }
                
                // 테마 선택
                Section(header: Text("Theme")) {
                    ForEach(QuoteTheme.allCases, id: \.self) { theme in
                        HStack {
                            Circle()
                                .fill(theme.color)
                                .frame(width: 20, height: 20)
                            
                            Text(theme.rawValue)
                            
                            if theme != .classic && theme != .midnight {
                                Spacer()
                                Image(systemName: "crown.fill")
                                    .foregroundColor(.yellow)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if theme == .classic || theme == .midnight {
                                viewModel.settings.theme = theme
                            } else {
                                isPremiumLocked = true
                            }
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarItems(trailing: Button("Done") {
                viewModel.saveSettings()
                dismiss()
            })
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
}

// QuoteTheme extension for colors
extension QuoteTheme {
    var color: Color {
        switch self {
        case .classic: return .black
        case .midnight: return Color(red: 0.1, green: 0.1, blue: 0.2)
        case .ocean: return Color(red: 0, green: 0.3, blue: 0.6)
        case .forest: return Color(red: 0.1, green: 0.3, blue: 0.1)
        case .sunset: return Color(red: 0.6, green: 0.2, blue: 0.3)
        }
    }
}
