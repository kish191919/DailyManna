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
    private let lastQuoteIndexKey = "lastQuoteIndex"
   
   private var autoPlayTimer: Timer?
   
    @Published var settings: QuoteSettings {
        didSet {
            saveSettings()
        }
    }
    
    private let settingsKey = "quoteSettings"
    
    init() {
        // Load saved settings or use defaults
        if let data = UserDefaults.standard.data(forKey: settingsKey),
           let loadedSettings = try? JSONDecoder().decode(QuoteSettings.self, from: data) {
            self.settings = loadedSettings
        } else {
            self.settings = QuoteSettings()
        }
    }
    
    func saveSettings() {
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: settingsKey)
        }
    }
    
    // UserDefaults에 저장할 키
    private let isFirstLaunchKey = "isFirstLaunch"
    private let categoryKey = "selectedCategory"
    private let lastQuoteKey = "lastQuote"
    
    // 사용자 선택 저장
    var isFirstLaunch: Bool {
        get {
            !UserDefaults.standard.bool(forKey: isFirstLaunchKey)
        }
        set {
            UserDefaults.standard.set(!newValue, forKey: isFirstLaunchKey)
        }
    }
    
    func saveUserPreferences() {
        if let category = selectedCategory {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(category) {
                UserDefaults.standard.set(encoded, forKey: categoryKey)
            }
        }
        
        // 현재 말씀의 인덱스 저장
        if let currentQuote = currentQuote,
           let currentIndex = quotes.firstIndex(where: { $0.id == currentQuote.id }) {
            UserDefaults.standard.set(currentIndex, forKey: lastQuoteIndexKey)
        }
        
        isFirstLaunch = false
    }
    
    func loadSavedCategory() async -> Bool {
        // Load saved category
        if let savedCategory = UserDefaults.standard.data(forKey: categoryKey) {
            let decoder = JSONDecoder()
            if let loadedCategory = try? decoder.decode(SubCategory.self, from: savedCategory) {
                await MainActor.run {
                    self.selectedCategory = loadedCategory
                }
                
                // Load quotes for the saved category
                await loadQuotesForCategory(loadedCategory)
                return true
            }
        }
        return false
    }
    
    func loadQuotesForCategory(_ category: SubCategory) async {
        do {
            let newQuotes = try await APIClient.fetchVerses(forCategory: category)
            await MainActor.run {
                self.quotes = newQuotes
                
                // Restore last viewed quote index
                if let savedIndex = UserDefaults.standard.object(forKey: lastQuoteIndexKey) as? Int,
                   savedIndex < newQuotes.count {
                    self.currentQuote = newQuotes[savedIndex]
                } else {
                    self.currentQuote = newQuotes.first
                }
            }
        } catch {
            print("Error loading quotes: \(error)")
        }
    }
    // 저장된 선택 불러오기
    private func loadUserPreferences() {
        // 카테고리 불러오기
        if let savedCategory = UserDefaults.standard.data(forKey: categoryKey) {
            let decoder = JSONDecoder()
            if let loadedCategory = try? decoder.decode(SubCategory.self, from: savedCategory) {
                selectedCategory = loadedCategory
                
                // 해당 카테고리의 말씀들 불러오기
                Task {
                    await loadQuotesForCategory(loadedCategory)
                }
            }
        }
        
        // 마지막 말씀 불러오기
        if let savedQuote = UserDefaults.standard.data(forKey: lastQuoteKey) {
            let decoder = JSONDecoder()
            if let loadedQuote = try? decoder.decode(Quote.self, from: savedQuote) {
                currentQuote = loadedQuote
            }
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
        saveUserPreferences()  // 인덱스 저장
    }

    func showPreviousQuote() {
        guard let currentQuote = currentQuote,
              let currentIndex = quotes.firstIndex(where: { $0.id == currentQuote.id }) else { return }
        
        let previousIndex = (currentIndex - 1 + quotes.count) % quotes.count
        self.currentQuote = quotes[previousIndex]
        saveUserPreferences()  // 인덱스 저장
    }
}
