import SwiftUI

struct CategoryChip: View {
    let category: SubCategory
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 4) {
            Text(category.icon)
            Text(category.name)
                .font(.subheadline)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.orange.opacity(colorScheme == .dark ? 0.3 : 0.1))
        )
        .foregroundColor(colorScheme == .dark ? .white : .black)
    }
}
