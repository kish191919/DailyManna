import SwiftUI

struct CategoryButton: View {
    let category: SubCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Text(category.icon)
                    .font(.system(size: 30))
                Text(category.name)
                    .font(.system(size: 14, weight: .medium))
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.orange.opacity(0.1) : Color.gray.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.orange : Color.clear, lineWidth: 2)
                    )
            )
        }
        .foregroundColor(isSelected ? .orange : .primary)
    }
}
