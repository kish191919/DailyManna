import SwiftUI

struct ReminderSetupView: View {
    @ObservedObject var viewModel: QuoteReminderViewModel
    @State private var showCategorySheet = false
    @State private var showTimePicker = false
    @State private var showSoundPicker = false
    @State private var showQuoteView = false  // QuoteView 전환을 위한 상태 추가
    @State private var timePickerAnchor: CGPoint = .zero
    @State private var soundPickerAnchor: CGPoint = .zero
    @Environment(\.colorScheme) var colorScheme
    
    var backgroundColor: Color {
        Color(.systemGray6)  // 항상 다크모드 색상 사용
    }
    
    var buttonBackgroundColor: Color {
        colorScheme == .dark ? Color(.systemGray5) : Color(.systemGray6)
    }
    
    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: viewModel.selectedTime)
    }
    
    var selectedCategoryString: String {
        if let category = viewModel.selectedCategory {
            return "\(category.icon) \(category.name)"
        }
        return "Select"
    }
    
    // Save 버튼이 활성화될 조건
    private var isSaveEnabled: Bool {
        viewModel.selectedCategory != nil
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // 상단 아이콘 및 제목
                HStack(spacing: 8) {
                    Image(systemName: "bell.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.orange)
                    
                    Text("Daily Manna")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                }
                .padding(.top, 20)
                .padding(.bottom, 20)
                
                VStack(spacing: 20) {
                    // 카테고리 섹션
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Categories")
                                .font(.headline)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            
                            Spacer()
                            
                            Button(action: {
                                showCategorySheet = true
                            }) {
                                Text(selectedCategoryString)
                                    .font(.headline)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(buttonBackgroundColor)
                                    )
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Sound 섹션
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Sound")
                                .font(.headline)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            
                            Spacer()
                            
                            Button(action: {
                                showSoundPicker = true
                            }) {
                                Text(viewModel.selectedSound.rawValue)
                                    .font(.headline)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(buttonBackgroundColor)
                                    )
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // 시간 선택 섹션
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Time")
                                .font(.headline)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            
                            Spacer()
                            
                            Button(action: {
                                showTimePicker = true
                            }) {
                                Text(timeString)
                                    .font(.headline)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(buttonBackgroundColor)
                                    )
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // 요일 선택 섹션
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            ForEach(0..<7) { index in
                                DayButton(
                                    day: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"][index],
                                    isSelected: viewModel.selectedDays.contains(index)
                                ) {
                                    if viewModel.selectedDays.contains(index) {
                                        viewModel.selectedDays.remove(index)
                                    } else {
                                        viewModel.selectedDays.insert(index)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                // 저장 버튼
                Button(action: {
                    viewModel.scheduleReminders()
                    // 선택된 카테고리와 현재 말씀 저장
                    viewModel.saveUserPreferences()
                    showQuoteView = true
                }) {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(isSaveEnabled ? Color.orange : Color.gray)
                        )
                }
                .disabled(!isSaveEnabled)
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
        .background(Color(.systemGray6).ignoresSafeArea())
        .preferredColorScheme(.dark) // 강제로 다크모드 적용
        .sheet(isPresented: $showCategorySheet) {
            CategorySheetView(selectedCategory: $viewModel.selectedCategory, viewModel: viewModel)
        }
        .popover(isPresented: $showTimePicker, attachmentAnchor: .point(.bottom), arrowEdge: .bottom) {
            TimePickerView(selectedTime: $viewModel.selectedTime)
        }
        .popover(isPresented: $showSoundPicker, attachmentAnchor: .point(.bottom), arrowEdge: .bottom) {
            SoundPickerView(selectedSound: $viewModel.selectedSound)
        }
        .fullScreenCover(isPresented: $showQuoteView) {
            QuoteView(viewModel: viewModel)
        }
    }
}

struct TimeAnchorPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        value = nextValue()
    }
}

struct SoundAnchorPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        value = nextValue()
    }
}
