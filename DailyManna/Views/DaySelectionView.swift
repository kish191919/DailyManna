import SwiftUI

struct DaySelectionView: View {
    @Binding var selectedDays: Set<Int>
    private let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        HStack {
            ForEach(0..<7) { index in
                DayButton(
                    day: days[index],
                    isSelected: selectedDays.contains(index)
                ) {
                    if selectedDays.contains(index) {
                        selectedDays.remove(index)
                    } else {
                        selectedDays.insert(index)
                    }
                }
            }
        }
    }
}
