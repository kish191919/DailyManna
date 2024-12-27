import SwiftUI

struct SoundPickerView: View {
    @Binding var selectedSound: NotificationSound
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Choose a sound for notifications")
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(NotificationSound.allCases, id: \.self) { sound in
                            Button(action: {
                                selectedSound = sound
                                NotificationSound.playSound(sound)
                            }) {
                                HStack {
                                    // Sound icon
                                    Image(systemName: sound == .noSound ? "speaker.slash" : "speaker.wave.2")
                                        .foregroundColor(.orange)
                                        .frame(width: 30)
                                    
                                    // Sound name
                                    Text(sound.rawValue)
                                        .foregroundColor(colorScheme == .dark ? .white : .black)
                                    
                                    Spacer()
                                    
                                    // Checkmark for selected sound
                                    if sound == selectedSound {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.orange)
                                    } else {
                                        Circle()
                                            .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
                                            .frame(width: 22, height: 22)
                                    }
                                }
                                .contentShape(Rectangle())
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal)
                            .background(
                                Rectangle()
                                    .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
                            )
                            
                            if sound != NotificationSound.allCases.last {
                                Divider()
                                    .padding(.leading, 56)
                            }
                        }
                    }
                    .background(colorScheme == .dark ? Color(.systemGray6) : .white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                
                Button(action: {
                    dismiss()
                }) {
                    Text("Done")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.orange)
                        )
                }
                .padding()
            }
            .navigationTitle("Sound")
            .navigationBarTitleDisplayMode(.inline)
            .background(colorScheme == .dark ? Color.black : Color(.systemGray6))
        }
    }
}
