import SwiftUI

struct QuoteSettingsPopup: View {
    @ObservedObject var viewModel: QuoteReminderViewModel
    @Binding var showThemeSheet: Bool
    @State private var expandedSection: SettingSection?
    
    enum SettingSection {
        case textSize, autoPlay, haptic
    }
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach([
                ("Text Size", SettingSection.textSize),
                ("Auto Play", SettingSection.autoPlay),
                ("Haptic", SettingSection.haptic),
                ("Theme", nil)
            ], id: \.0) { title, section in
                if let section = section {
                    // 확장 가능한 섹션
                    VStack(spacing: 0) {
                        Button(action: {
                            withAnimation {
                                expandedSection = expandedSection == section ? nil : section
                            }
                        }) {
                            HStack {
                                Text(title)
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                                    .rotationEffect(.degrees(expandedSection == section ? 90 : 0))
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                        
                        if expandedSection == section {
                            sectionContent(for: section)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(Color(.systemGray5))
                                .cornerRadius(12)
                                .transition(.scale)
                        }
                    }
                } else {
                    // Theme 버튼
                    Button(action: {
                        showThemeSheet = true
                    }) {
                        HStack {
                            Text(title)
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray5))
        .cornerRadius(20)
        .shadow(radius: 10)
    }
    
    @ViewBuilder
    private func sectionContent(for section: SettingSection) -> some View {
        switch section {
        case .textSize:
            VStack(alignment: .leading, spacing: 10) {
                Text("Bible Verse")
                    .foregroundColor(.white)
                Slider(value: $viewModel.settings.textSize, in: 20...40, step: 1)
                    .accentColor(.white)
                
                Text("Reference")
                    .foregroundColor(.white)
                Slider(value: $viewModel.settings.referenceSize, in: 16...32, step: 1)
                    .accentColor(.white)
            }
            
        case .autoPlay:
           VStack(alignment: .leading, spacing: 10) {
               HStack {
                   Text("\(Int(viewModel.settings.autoPlayInterval))s")
                       .foregroundColor(.white)
                   Spacer()
               }
               Slider(
                   value: $viewModel.settings.autoPlayInterval,
                   in: 1...60,
                   step: 1
               )
               .accentColor(.white)
           }
            
        case .haptic:
            Toggle("Enable Haptic", isOn: $viewModel.settings.hapticEnabled)
                .foregroundColor(.white)
        }
    }
}
