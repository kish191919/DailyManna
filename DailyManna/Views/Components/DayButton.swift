
import SwiftUI

struct DayButton: View {
    let day: String
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            Text(day)
                .font(.subheadline)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? Color.orange : (colorScheme == .dark ? Color(.systemGray5) : Color(.systemGray6)))
                )
                .foregroundColor(isSelected ? .white : (colorScheme == .dark ? .white : .black))
        }
    }
}
