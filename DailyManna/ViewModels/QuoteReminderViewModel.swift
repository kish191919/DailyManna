import SwiftUI
import UserNotifications

// MARK: - ViewModels
class QuoteReminderViewModel: ObservableObject {
    @Published var selectedCategories: Set<QuoteCategory> = []
    @Published var selectedDays: Set<Int> = []
    @Published var selectedTime: Date = Date()
    @Published var currentQuote: Quote?
    @Published var isReminderSet: Bool = false
    
    private var quotes: [Quote] = []
    
    init() {
        loadQuotes()
        requestNotificationPermission()
    }
    
    private func loadQuotes() {
        // Sample quotes - In real app, load from a database or API
        quotes = [
            Quote(id: UUID(), text: "For I know the plans I have for you, declares the Lord, plans to prosper you and not to harm you, plans to give you hope and a future.", reference: "Jeremiah 29:11", categories: [.motivation, .hope]),
            // Add more quotes here
        ]
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleReminders() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        for day in selectedDays {
            let notification = UNMutableNotificationContent()
            notification.title = "Daily Bible Quote"
            notification.body = quotes.randomElement()?.text ?? ""
            notification.sound = .default
            
            var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: selectedTime)
            dateComponents.weekday = day + 1
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: notification, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
        }
        
        isReminderSet = true
    }
}
