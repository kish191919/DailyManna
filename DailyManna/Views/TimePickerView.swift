import SwiftUI

struct TimePickerView: View {
    @Binding var selectedTime: Date
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var tempSelectedTime: Date
    
    init(selectedTime: Binding<Date>) {
        _selectedTime = selectedTime
        _tempSelectedTime = State(initialValue: selectedTime.wrappedValue)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Time Picker
            DatePicker("", selection: $tempSelectedTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .frame(maxWidth: 250, maxHeight: 160)
                .padding(.top, 16)
            
            Spacer()
                .frame(height: 60)  // 시계와 버튼 사이 간격 증가
            
            // Done Button
            Button(action: {
                selectedTime = tempSelectedTime
                dismiss()
            }) {
                Text("Done")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 300)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.orange)
                    )
            }
            .padding(.bottom, 16)
        }
        .padding(.horizontal, 20)
        .background(colorScheme == .dark ? Color(.systemGray6) : .white)
        .cornerRadius(12)
    }
}

