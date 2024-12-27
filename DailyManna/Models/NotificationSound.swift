import UserNotifications
import AVFoundation

enum NotificationSound: String, CaseIterable {
    case coco = "Coco"
    case drums = "Drums"
    case coin = "Coin"
    case sheba = "Sheba"
    case galaxy = "Galaxy"
    case domino = "Domino"
    case correct = "Correct"
    case gucci = "Gucci"
    case magicWand = "Magic wand"
    case noSound = "No sound"
    case positive = "Positive"
    case systemDefault = "System default"
    case piper = "Piper"
    
    var soundName: UNNotificationSoundName {
        if self == .noSound {
            return UNNotificationSoundName("")
        } else if self == .systemDefault {
            return UNNotificationSoundName("DefaultSound")
        } else {
            return UNNotificationSoundName(rawValue: "\(self.rawValue).caf")
        }
    }
    
    var soundFileName: String {
        if self == .noSound {
            return ""
        } else if self == .systemDefault {
            return "DefaultSound"
        } else {
            return self.rawValue
        }
    }
    
    static func playSound(_ sound: NotificationSound) {
        guard sound != .noSound else { return }
        
        var soundID: SystemSoundID = 0
        if let soundURL = Bundle.main.url(forResource: sound.soundFileName, withExtension: "caf") {
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundID)
            AudioServicesPlaySystemSound(soundID)
        }
    }
}
