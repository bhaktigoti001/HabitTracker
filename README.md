# 🧠 Habit Tracker Demo (SwiftUI + CoreData)

A beautifully designed iOS habit tracking app built using **SwiftUI**, **Core Data**, and **local notifications**, allowing users to create, monitor, and maintain daily habits with reminders, analytics, and history tracking.

---

## 📱 Features

### 1. Habit Management
- Add, edit, and delete habits
- Assign daily target counts
- Track current progress per habit
- Auto-reset daily progress at midnight

### 2. Local Notifications
- Custom daily reminders at user-defined times
- Smart **streak-risk notifications** if a habit is at risk of breaking
- Notification permissions and scheduling handled via `UNUserNotificationCenter`

### 3. Habit Detail & Analytics
- Full-screen detail view on habit selection
- Real-time progress bar using `GeometryReader`
- 🔥 Streak Tracker: consecutive days completed
- 📅 Last Completed: Today, Yesterday, or specific day
- ✅ Weekly Completion Rate: percentage based on last 7 days

### 4. Habit History
- View history logs grouped by date
- Filters: All / This Week / This Month
- Scrollable, sectioned UI with empty states
- Powered by Core Data relationships

### 5. Settings
- Toggle for Dark Mode (via `@AppStorage`)
- Toggle for enabling/disabling Daily Reminders
- Tab bar with bubble-style navigation
- Persistent preferences for user experience

---

## 🛠 Tools & Technologies

- **Language:** Swift 5
- **UI Framework:** SwiftUI (Xcode 16+)
- **Persistence:** Core Data (with custom relationships)
- **Notifications:** UserNotifications (`UNUserNotificationCenter`)
- **Design System:** SwiftUI components + custom modifiers

---

## 🧩 Architecture & Core Concepts

- MVVM architecture with `@StateObject`, `@ObservedObject`, and custom `ViewModel`s
- Data binding via `@Binding` and `@AppStorage`
- `FetchRequest` and `NSManagedObjectContext` for Core Data
- GeometryReader for dynamic progress layout
- NavigationStack & NavigationLink for seamless screen transitions
- Modular & reusable UI components

---

## 🌱 Future Scope

- iCloud Sync with Core Data + CloudKit  
- Weekly and monthly analytics charts  
- Home screen widgets (using WidgetKit)  
- Siri Shortcut integration  
- Sync across Apple Watch / iPad  
- Authentication with Face ID / Touch ID  
- Gamification elements (badges, XP, rewards)  

---

## 🔍 Project Importance

This project is ideal for:
- SwiftUI learners aiming to build a full-featured app
- Understanding Core Data with relationships and filtering
- Exploring notification logic and smart reminders
- Practicing SwiftUI state and navigation patterns
- Building a real-world productivity tool for habit building

---
