import SwiftUI
import UserNotifications

class QuoteReminderViewModel: ObservableObject {
   @Published var selectedCategory: SubCategory?
   @Published var selectedDays: Set<Int> = []
   @Published var selectedTime: Date = Date()
   @Published var selectedSound: NotificationSound = .systemDefault
   @Published var currentQuote: Quote?
   @Published var isReminderSet: Bool = false
   @Published var isFavorite: Bool = false
   @Published var quotes: [Quote] = []
   
   private var autoPlayTimer: Timer?
   
   init() {
       requestNotificationPermission()
   }
   
   func loadQuotesForCategory(_ category: SubCategory) async {
       do {
           let newQuotes = try await APIClient.fetchVerses(forCategory: category)
           await MainActor.run {
               self.quotes = newQuotes
               self.currentQuote = newQuotes.first
           }
       } catch {
           print("Error loading quotes: \(error)")
       }
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
           
           if let quote = quotes.randomElement() {
               notification.body = quote.text
           }
           
           notification.sound = UNNotificationSound(named: selectedSound.soundName)
           
           var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: selectedTime)
           dateComponents.weekday = day + 1
           
           let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
           let request = UNNotificationRequest(identifier: UUID().uuidString, content: notification, trigger: trigger)
           
           UNUserNotificationCenter.current().add(request)
       }
       
       isReminderSet = true
   }
   
   func toggleFavorite() {
       isFavorite.toggle()
   }
   
   func startAutoPlay() {
       autoPlayTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
           self?.showNextQuote()
       }
   }
   
   func stopAutoPlay() {
       autoPlayTimer?.invalidate()
       autoPlayTimer = nil
   }
   
    func showNextQuote() {
        guard let currentQuote = currentQuote,
              let currentIndex = quotes.firstIndex(where: { $0.id == currentQuote.id }) else { return }
        
        let nextIndex = (currentIndex + 1) % quotes.count
        self.currentQuote = quotes[nextIndex]
    }

    func showPreviousQuote() {
        guard let currentQuote = currentQuote,
              let currentIndex = quotes.firstIndex(where: { $0.id == currentQuote.id }) else { return }
        
        let previousIndex = (currentIndex - 1 + quotes.count) % quotes.count
        self.currentQuote = quotes[previousIndex]
    }
}
