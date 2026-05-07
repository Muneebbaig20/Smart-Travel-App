# Smart Travel App

A modern Flutter application for smart travel planning and exploration. This app provides weather information and place recommendations to help users plan their trips effectively.

## 📱 Features

- **Weather Information**: Real-time weather data for destinations
- **Place Discovery**: Browse and explore places of interest
- **Caching**: Local caching for offline access using SharedPreferences
- **Modern UI**: Clean and intuitive user interface with Google Fonts
- **State Management**: Provider-based state management for efficient app performance

## 🏗️ Project Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── Smart_app/
│   ├── Domain/              # Business logic & API services
│   │   ├── cache_service.dart
│   │   ├── place_api.dart
│   │   └── weather_api.dart
│   ├── Model/               # Data models
│   │   ├── place_model.dart
│   │   └── weather_model.dart
│   └── Presentation/        # UI & State Management
│       ├── Provider/        # Provider-based state management
│       └── UI/              # Screens and widgets
└── main.dart
```

## 🛠️ Technology Stack

- **Framework**: Flutter
- **Language**: Dart
- **State Management**: Provider (v6.1.5+1)
- **HTTP**: http (v1.6.0)
- **Local Storage**: shared_preferences (v2.5.5)
- **Fonts**: google_fonts (v8.1.0)
- **Icons**: cupertino_icons (v1.0.8)


## 🚀 Getting Started

### 1. Clone or Extract the Project
```bash
cd flutter_application_1
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Run the Application
```bash
# For development
flutter run

# For iOS
flutter run -d iphone

# For Android
flutter run -d android

# For Web
flutter run -d chrome

# For Windows
flutter run -d windows
```

### 4. Build Release
```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# Windows
flutter build windows --release
```

## 📦 Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter` | sdk | Core Flutter framework |
| `cupertino_icons` | ^1.0.8 | iOS-style icons |
| `shared_preferences` | ^2.5.5 | Local data persistence |
| `http` | ^1.6.0 | HTTP requests for APIs |
| `provider` | ^6.1.5+1 | State management |
| `google_fonts` | ^8.1.0 | Custom fonts |

## 📖 Project Structure Explanation

### Domain Layer
- **cache_service.dart**: Manages local caching using SharedPreferences
- **place_api.dart**: Handles place-related API calls
- **weather_api.dart**: Handles weather-related API calls

### Model Layer
- **place_model.dart**: Data models for places
- **weather_model.dart**: Data models for weather information

### Presentation Layer

#### **Provider Folder** 📊
**File: `smart_provider.dart`**

This file contains the `SmartProvider` class - the central state management hub using the Provider package.

**Key Features:**
- **State Management**: Manages all app-wide state using `ChangeNotifier`
- **Place Management**: Stores and manages list of places with filtering and sorting
- **Weather Caching**: Caches weather data for each place to reduce API calls
- **Search & Filter**: Handles search queries, place filtering, and sorting
- **Pagination**: Supports infinite scrolling with pagination (20 places per page)
- **Offline Support**: Falls back to cached data when network is unavailable
- **Dark Mode**: Theme toggle support

**Main States Managed:**
```dart
LoadingState { initial, loading, loaded, error, offline }
PlaceFilter { all, favorites, recent }
SortBy { nameAsc, nameDesc, locationAsc }
```

**Key Methods:**
- `loadPlaces()` - Fetches places from API
- `loadMore()` - Pagination support
- `toggleFavorite()` - Mark places as favorites
- `updateSearch()` - Search with debouncing
- `fetchWeather()` - Fetch weather for specific place
- `filterPlaces()` - Apply filters and sorting

---

#### **UI Folder** 🎨

**Complete Screen Structure:**

```
UI/
├── smart_app.dart           # Main app entry point & routing
├── home_screen.dart         # Main listing screen
├── detail_screen.dart       # Place details page
├── search_filter_screen.dart # Advanced search & filters
├── map_screen.dart          # Map visualization
├── drawer_menu.dart         # Side navigation drawer
└── widgets/                 # Reusable UI components
    ├── place_card.dart      # Place display card
    ├── bottom_nav.dart      # Bottom navigation bar
    ├── weather_widget.dart  # Weather display widget
    ├── empty_state.dart     # Empty state UI
    └── offline_state.dart   # Offline mode indicator
```

---

### **Screen Details** 📱

#### **1. SmartTravelApp (`smart_app.dart`)**
- **Purpose**: Main application root and routing configuration
- **Features**:
  - Initializes Provider state management
  - Configures theme (light/dark mode)
  - Handles all route navigation
  - Page transitions with animations
  - Material App setup with custom themes

**Routes Defined:**
- `/` → HomeScreen
- `/detail` → DetailScreen (with PlaceModel argument)
- `/search` → SearchFilterScreen
- `/map` → MapScreen (with optional PlaceModel)

---

#### **2. HomeScreen (`home_screen.dart`)**
- **Purpose**: Main discovery and browsing interface
- **Features**:
  - Grid/List view of all places
  - Real-time search with debouncing
  - Bottom navigation bar for section switching
  - Pull-to-refresh functionality
  - Infinite scrolling/pagination
  - Empty state and offline indicators
  - Smooth animations and transitions
  - Quick access buttons (search, filters, map)

**Key Components:**
- Animated header with search bar
- ScrollView with AnimatedList for smooth item insertion
- PlaceCard widgets for each location
- Loading states (initial, loading, loaded, error, offline)
- Filter badge display

---

#### **3. DetailScreen (`detail_screen.dart`)**
- **Purpose**: Show comprehensive information about a selected place
- **Features**:
  - High-res place image with hero animation
  - Detailed place information (description, ratings, etc.)
  - Real-time weather data fetching
  - Favorite toggle functionality
  - Expandable description text
  - Share functionality
  - Navigation to map view
  - Add to itinerary option
  - Smooth fade-in animations

**Key Elements:**
- Hero animation for image transition
- Weather widget integration
- Action buttons (map, share, favorite)
- Place metadata (rating, category, location)
- Full description with read more/less toggle

---

#### **4. SearchFilterScreen (`search_filter_screen.dart`)**
- **Purpose**: Advanced search and filtering capabilities
- **Features**:
  - Real-time search filtering
  - Filter by region/location
  - Sort options (name A-Z, Z-A, location)
  - Filter by favorites
  - Filter by recently viewed
  - Result count display
  - Quick filter chips
  - Back navigation with result preservation

**Filter Options:**
- Search by name or description
- Region filter (dynamically generated from places)
- Favorites-only toggle
- Recently viewed list
- Sort by name (ascending/descending) or location

---

#### **5. MapScreen (`map_screen.dart`)**
- **Purpose**: Visual map representation of places
- **Features**:
  - Custom painted map grid background
  - Place location visualization
  - Information card overlay
  - Back navigation
  - Gradient background styling
  - Responsive positioning

**Components:**
- Custom MapGridPainter for visual effect
- Location marker display
- Place name and basic info overlay
- Close/back button overlay

---

#### **6. DrawerMenu (`drawer_menu.dart`)**
- **Purpose**: Side navigation and app settings
- **Features**:
  - User profile section header
  - Navigation menu items
  - Theme toggle (dark/light mode)
  - Settings options
  - Favorites count display
  - About section
  - Logout/navigation actions
  - Smooth animations and transitions

**Menu Sections:**
- Profile info with avatar
- Navigation links (Home, Favorites, Recents, Settings)
- Theme toggle switch
- Language/preferences
- Help & Support
- About & Legal

---

### **Reusable Widgets** 🧩

#### **place_card.dart**
A reusable card widget displaying place information in a compact format.
- Place image thumbnail
- Name and location
- Rating/category badge
- Favorite button
- Tap action to navigate to detail screen
- Hover effects

#### **bottom_nav.dart**
Navigation bar with multiple sections.
- Icons for different app sections
- Section switching
- Animation indicators
- Badge for notification count

#### **weather_widget.dart**
Displays weather information for a place.
- Current temperature
- Weather condition description
- Wind speed, humidity
- Weather icon display
- Loading state handling
- Error handling

#### **empty_state.dart**
Shows user-friendly message when no places found.
- Illustration/icon
- Helpful message
- Action buttons to resolve
- Smooth animations

#### **offline_state.dart**
Indicates offline mode with cached data.
- Offline indicator banner
- Cache information
- Sync status

---

## 🔧 Configuration

Before running the app, ensure that:
1. All Flutter dependencies are properly installed
2. Your development environment is set up correctly
3. API endpoints are configured if required








