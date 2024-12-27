import SwiftUI

struct ReminderSetupView: View {
    @ObservedObject var viewModel: QuoteReminderViewModel
    @State private var showCategorySheet = false
    @State private var showTimePicker = false
    @Environment(\.colorScheme) var colorScheme
    
    var backgroundColor: Color {
        colorScheme == .dark ? Color(.systemGray6) : Color.white
    }
    
    var buttonBackgroundColor: Color {
        colorScheme == .dark ? Color(.systemGray5) : Color(.systemGray6)
    }
    
    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: viewModel.selectedTime)
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
                
                // 카테고리 섹션
                VStack(alignment: .leading, spacing: 16) {
                    // 카테고리 선택 버튼
                    Button(action: {
                        showCategorySheet = true
                    }) {
                        HStack {
                            Image(systemName: "folder.fill")
                                .font(.headline)
                            Text("Categories")
                                .font(.headline)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(buttonBackgroundColor)
                        )
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                    
                    // 선택된 카테고리 표시
                    if !viewModel.selectedCategories.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(Array(viewModel.selectedCategories), id: \.self) { category in
                                    CategoryChip(category: category)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 32)  // 카테고리 섹션 아래 여백 추가
                
                // 요일 선택 섹션

                
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
                    .padding(.horizontal)
                }
                
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
                
                Spacer()
                
                // 저장 버튼
                Button(action: {
                    viewModel.scheduleReminders()
                }) {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.orange)
                        )
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
        .background(backgroundColor.ignoresSafeArea())
        .sheet(isPresented: $showCategorySheet) {
            CategorySheetView(selectedCategories: $viewModel.selectedCategories)
        }
        .sheet(isPresented: $showTimePicker) {
            TimePickerSheet(selectedTime: $viewModel.selectedTime)
        }
    }
}
