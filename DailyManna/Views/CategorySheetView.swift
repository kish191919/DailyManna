
import SwiftUI

struct CategorySheetView: View {
    @Binding var selectedCategory: SubCategory?
    @ObservedObject var viewModel: QuoteReminderViewModel  // 추가
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedMainCategory: MainCategory = .faithAndChristianLiving
    
    init(selectedCategory: Binding<SubCategory?>, viewModel: QuoteReminderViewModel) {  // 수정
        _selectedCategory = selectedCategory
        self.viewModel = viewModel
    }
    
    var backgroundColor: Color {
        Color(.systemGray6)  // 항상 다크모드 색상 사용
    }
    
    // 현재 카테고리의 인덱스
    private var currentIndex: Int {
        MainCategory.allCases.firstIndex(of: selectedMainCategory) ?? 0
    }
    
    // 이전 카테고리로 이동 가능 여부
    private var canMoveToPrevious: Bool {
        currentIndex > 0
    }
    
    // 다음 카테고리로 이동 가능 여부
    private var canMoveToNext: Bool {
        currentIndex < MainCategory.allCases.count - 1
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 네비게이션 바 커스텀
                HStack {
                    Spacer()
                    Text("Select Category")
                        .font(.system(size: 20, weight: .bold))
                    Spacer()
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.system(size: 18))
                    .foregroundColor(.blue)
                }
                .padding(.horizontal)
                .padding(.vertical, 16)
                
                // 메인 카테고리 선택 영역
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(MainCategory.allCases, id: \.self) { category in
                            MainCategoryButton(
                                title: category.rawValue,
                                isSelected: selectedMainCategory == category,
                                action: { selectedMainCategory = category }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 16)
                
                Divider()
                    .padding(.bottom, 8)
                
                // 서브 카테고리 그리드
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        ForEach(CategoryData.getSubCategories(for: selectedMainCategory), id: \.id) { subCategory in
                            Button(action: {
                                selectedCategory = subCategory
                                Task {
                                    await viewModel.loadQuotesForCategory(subCategory)
                                }
                                dismiss()
                            }) {
                                VStack(spacing: 8) {
                                    Text(subCategory.icon)
                                        .font(.system(size: 32))
                                    Text(subCategory.name)
                                        .font(.system(size: 16, weight: .medium))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(colorScheme == .dark ? .white : .black)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(selectedCategory?.id == subCategory.id ?
                                             Color.orange.opacity(0.15) :
                                                (colorScheme == .dark ? Color(.systemGray5) : Color(.systemGray6)))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(selectedCategory?.id == subCategory.id ?
                                                       Color.orange : Color.clear,
                                                       lineWidth: 2)
                                        )
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                
                // 화살표 버튼
                HStack(spacing: 40) {
                    Button(action: {
                        if canMoveToPrevious {
                            withAnimation {
                                selectedMainCategory = MainCategory.allCases[currentIndex - 1]
                            }
                        }
                    }) {
                        Image(systemName: "chevron.left.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(canMoveToPrevious ? .orange : .gray.opacity(0.3))
                    }
                    .disabled(!canMoveToPrevious)
                    
                    Button(action: {
                        if canMoveToNext {
                            withAnimation {
                                selectedMainCategory = MainCategory.allCases[currentIndex + 1]
                            }
                        }
                    }) {
                        Image(systemName: "chevron.right.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(canMoveToNext ? .orange : .gray.opacity(0.3))
                    }
                    .disabled(!canMoveToNext)
                }
                .padding(.vertical, 20)
            }
            .background(backgroundColor.ignoresSafeArea())
        }
        .navigationBarHidden(true)
    }
}

struct MainCategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .medium))
                .lineLimit(1)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.orange : (colorScheme == .dark ? Color(.systemGray5) : Color(.systemGray6)))
                )
                .foregroundColor(isSelected ? .white : .primary)
                .contentShape(Rectangle())
                .fixedSize(horizontal: true, vertical: false)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
