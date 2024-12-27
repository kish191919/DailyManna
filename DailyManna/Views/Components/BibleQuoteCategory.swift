import SwiftUI

// 메인 카테고리
enum MainCategory: String, CaseIterable {
    case faithAndChristianLiving = "Pillars of Faith and Christian Living"
    case personalGrowth = "Personal Growth and Life Balance"
    case relationships = "Relationships and Community"
    case practicalLiving = "Practical Living"
}

// 서브 카테고리
struct SubCategory: Identifiable, Hashable, Codable {
    let id = UUID()
    let name: String
    let topics: [String]
    let icon: String
    
    // Hashable 구현
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: SubCategory, rhs: SubCategory) -> Bool {
        lhs.id == rhs.id
    }
}

// 카테고리 데이터 구조
struct CategoryData {
    static let faithAndChristianLiving: [SubCategory] = [
        SubCategory(name: "Faith", topics: [
            "Strengthening Your Faith",
            "Living by Faith, Not by Sight",
            "Faith in God's Promises"
        ], icon: "✝️"),
        SubCategory(name: "Trust", topics: [
            "Trusting God's Timing",
            "Letting Go of Worry",
            "Confidence in God's Plan"
        ], icon: "🙏"),
        SubCategory(name: "Hope", topics: [
            "Finding Hope in Difficult Times",
            "God's Promises for the Future",
            "Hope in Eternal Life"
        ], icon: "⭐️"),
        SubCategory(name: "Love", topics: [
            "God's Unconditional Love",
            "Loving Your Neighbor",
            "Forgiving with Love"
        ], icon: "❤️"),
        SubCategory(name: "Peace", topics: [
            "Peace in Times of Anxiety",
            "God's Gift of Inner Peace",
            "Living as a Peacemaker"
        ], icon: "🕊️"),
        SubCategory(name: "Joy", topics: [
            "Finding Joy in Trials",
            "Rejoicing in the Lord",
            "Sustaining Joy Through Faith"
        ], icon: "😊"),
        SubCategory(name: "Wisdom", topics: [
            "Seeking Godly Wisdom",
            "Wisdom in Decision-Making",
            "The Fear of the Lord as Wisdom"
        ], icon: "📚"),
        SubCategory(name: "Strength", topics: [
            "God's Strength in Our Weakness",
            "Overcoming Challenges with His Power",
            "Renewing Strength Through Prayer"
        ], icon: "💪"),
        SubCategory(name: "Grace", topics: [
            "Living in God's Grace",
            "Extending Grace to Others",
            "The Gift of Salvation by Grace"
        ], icon: "🌟"),
        SubCategory(name: "Forgiveness", topics: [
            "God's Forgiveness of Sins",
            "Forgiving Those Who Hurt Us",
            "Freedom Through Forgiveness"
        ], icon: "🕊️")
    ]
    
    static let personalGrowth: [SubCategory] = [
        SubCategory(name: "Take Care of Your Health", topics: [
            "Finding Strength in Physical Weakness",
            "Trusting God Through Illness",
            "Caring for Your Body as God's Temple"
        ], icon: "💪"),
        SubCategory(name: "Improve Your Mindset", topics: [
            "Renewing Your Mind with God's Word",
            "Developing a Positive Attitude",
            "Replacing Negative Thoughts with Truth"
        ], icon: "🧠"),
        SubCategory(name: "Look on the Bright Side", topics: [
            "Gratitude in Every Situation",
            "Seeing God's Goodness Around You",
            "Overcoming Complaints with Thankfulness"
        ], icon: "☀️"),
        SubCategory(name: "Stay Mentally Strong", topics: [
            "Battling Stress and Anxiety Through Prayer",
            "Standing Firm in the Storms of Life",
            "Finding Rest in God's Peace"
        ], icon: "🏋️‍♂️")
    ]
    
    static let relationships: [SubCategory] = [
        SubCategory(name: "Build Healthy Relationships", topics: [
            "Strengthening Bonds with Loved Ones",
            "Resolving Conflicts in Love",
            "Supporting Each Other in Faith"
        ], icon: "👥")
    ]
    
    static let practicalLiving: [SubCategory] = [
        SubCategory(name: "Work-Life Balance", topics: [
            "Trusting God in Your Career",
            "Honoring God with Your Time",
            "Resting in the Sabbath Principle"
        ], icon: "⚖️"),
        SubCategory(name: "Financial Wisdom", topics: [
            "Trusting God as Your Provider",
            "Stewarding Resources Wisely",
            "Overcoming Fear of Financial Lack"
        ], icon: "💰")
    ]
    
    static func getSubCategories(for mainCategory: MainCategory) -> [SubCategory] {
        switch mainCategory {
        case .faithAndChristianLiving:
            return faithAndChristianLiving
        case .personalGrowth:
            return personalGrowth
        case .relationships:
            return relationships
        case .practicalLiving:
            return practicalLiving
        }
    }
}
