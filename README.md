# 🎬 Movie App with Themes & Caching

A beautiful Flutter application that displays popular movies with **infinite scroll pagination**, **dynamic theming** (Light: White & Gold | Dark: Black & Gold), **SQLite caching**, and **image caching** for offline support.

## ✨ Features

- **Popular Movies List** - Fetches movies from The Movie Database (TMDb) API
- **Infinite Scroll Pagination** - Automatically loads next page when scrolling near bottom with smooth scroll preservation
- **SQLite Database Caching** - Caches movie responses locally for offline access and faster subsequent loads
- **Smart Offline Mode** - Automatically switches to cached data when internet is unavailable
- **Offline Indicator** - Clear visual feedback showing when cached data is being displayed
- **Image Caching** - Movie posters cached using `cached_network_image` for offline viewing
- **Theme Switching** - Toggle between light (white & gold) and dark (black & gold) themes
- **Persistent Theme** - Selected theme is saved and restored on app restart
- **Loading States** - Shimmer skeleton while loading movies
- **Error Handling** - Retry button on failed requests
- **Responsive Design** - Optimized for mobile devices (375x812 design size)

## 🏗️ Architecture

Built with **Clean Architecture** principles:
- **Domain Layer** - Business logic interfaces and repository contracts
- **Data Layer** - API models, local database, and repository implementations
- **Presentation Layer** - UI, Widgets, and State Management (BLoC/Cubit)

**Tech Stack:**
- Flutter BLoC/Cubit for state management with offline awareness
- GetIt for dependency injection
- Retrofit + Dio for API calls
- Freezed for immutable models
- SQLite for local database caching
- ScreenUtil for responsive UI
- SharedPreferences for theme persistence
- cached_network_image for image caching

## 📁 Project Structure

```
lib/
├── core/
│   ├── database/                       # SQLite database management
│   │   └── db_helper.dart              # Database initialization and schema
│   ├── di/                             # Dependency Injection setup
│   ├── helpers/                        # Spacing and utility helpers
│   ├── networking/                     # API services (Retrofit, Dio)
│   └── theming/                        # Colors, themes, and theme Cubit
├── features/
│   └── movies/
│       ├── domain/
│       │   └── repos/                  # Abstract repository interfaces
│       ├── data/
│       │   ├── models/                 # Movie models with JSON serialization
│       │   ├── datasources/            # Local data source (SQLite operations)
│       │   └── repos/                  # Repository implementations
│       └── presentation/
│           ├── cubit/                  # Movies state management (offline-aware)
│           └── ui/                     # Screens and widgets
└── main.dart                           # App entry point
```

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (3.5.4+)
- Dart (latest)

### Installation

```bash
# 1. Navigate to project
cd /Users/daf/Documents/assignments/assigment_5/movie_app_themes_caching

# 2. Install dependencies
flutter pub get

# 3. Generate code (Freezed, JSON serializable, Retrofit, SQLite)
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Run the app
flutter run
```

## 📖 Usage

### First Launch - Online
1. App launches and fetches popular movies from TMDb API
2. Movies are displayed in a list with posters cached
3. Movie data is automatically saved to SQLite database
4. All images are cached for offline access

### Subsequent Launches
1. App loads from SQLite cache instantly (much faster)
2. In background, app attempts to fetch fresh data
3. If fresh data is available, list updates with new movies

### Offline Mode
1. Disconnect internet (or turn on airplane mode)
2. App automatically switches to cached data
3. Orange "Showing cached data" banner appears at top
4. All previously loaded movies remain accessible
5. Images display from cache

### Viewing Movies
1. Each movie card displays:
   - Poster image (cached locally)
   - Movie title
   - Release date with calendar icon
   - Star rating (0-10) and vote count
   - Full movie overview/description

### Switching Themes
- Tap the **sun/moon icon** in the AppBar (top-right)
- App instantly switches between light and dark themes
- Theme preference is automatically saved to SharedPreferences
- Works seamlessly in both online and offline modes

### Loading More Movies
- Scroll down the list smoothly
- When you reach ~500px from the bottom, next page loads automatically
- Loading indicator appears at the bottom while fetching
- Movies are appended to the existing list without jumping to top
- Scroll position is preserved while loading

## 🗄️ Caching Strategy

### API Response Caching (SQLite)

**What Gets Cached:**
- Movie data (title, overview, rating, release date, etc.)
- Poster and backdrop paths
- Pagination information (page, totalPages, totalResults)
- Timestamp of when data was cached

**Cache Behavior:**
- Every successful API response is automatically cached to SQLite
- Each page of movies is stored separately by page number
- Cache is persistent across app restarts
- Old data is kept but marked with cache timestamps

**When Cache Is Used:**
- On subsequent app launches (instant loading)
- When internet connection is unavailable
- When API is slow or returns errors
- Data source is indicated to user via orange "cached" banner

### Image Caching (cached_network_image)

**Configuration:**
- Base URL: `https://image.tmdb.org/t/p/w342` (342px width)
- Images cached automatically with package defaults
- Failed images show error placeholder
- Null posterPath shows default placeholder

## 🎨 Color Schemes

### Light Theme
- **Background**: White (#FFFFFF)
- **Accent**: Gold (#D4AF37)
- **Text**: Dark (#1A1A1A)
- **Cards**: Light Gray (#F8F8F8)

### Dark Theme
- **Background**: Black (#121212)
- **Accent**: Gold (#D4AF37)
- **Text**: Light (#FFFAF0)
- **Cards**: Dark Gray (#1E1E1E)

### Offline Indicator
- **Background**: Orange (#F57C00)
- **Text**: White
- **Icon**: Cloud Off icon

## 🔌 API Integration

**Service**: The Movie Database (TMDb) API
- **Endpoint**: `/movie/popular`
- **Base URL**: `https://api.themoviedb.org/3`
- **Authentication**: Bearer Token (TMDb API Key)
- **Parameters**:
  - `language`: "en-US"
  - `page`: Page number (1, 2, 3...)
  - `Authorization`: Bearer token in header

**Response Handling:**
- Successful responses cached to SQLite immediately
- Failed responses return cached data if available
- Returns null only if both API and cache fail

## 📱 Key Files

| File | Description |
|------|-------------|
| `lib/main.dart` | App initialization, theme setup, DI initialization |
| `lib/core/database/db_helper.dart` | SQLite database setup and schema |
| `lib/core/di/dependency_injection.dart` | GetIt DI setup including DB & local data source |
| `lib/features/movies/data/datasources/local_data_source.dart` | SQLite CRUD operations for movies |
| `lib/features/movies/data/repos/movies_repo_impl.dart` | Repository with caching logic |
| `lib/features/movies/domain/repos/movies_repo.dart` | Abstract repository interface |
| `lib/features/movies/presentation/cubit/movies_cubit.dart` | State management with offline awareness |
| `lib/features/movies/presentation/cubit/movies_state.dart` | State definitions (includes `isFromCache` flag) |
| `lib/features/movies/presentation/ui/movies_screen.dart` | Main UI with offline indicator |
| `lib/features/movies/presentation/ui/widgets/movie_card.dart` | Individual movie card widget |
| `lib/core/theming/colors.dart` | All color definitions |
| `lib/core/theming/app_theme.dart` | Theme data and styling |

## 🔄 Data Flow with Caching

```
App Start
    ↓
Check if cache exists?
    ├─ YES → Load from SQLite (instant)
    │         └─ Show cached data while fetching fresh
    │
    └─ NO → Attempt API call
            ├─ Success → Cache to SQLite + Show data
            ├─ Fail (no internet) → Check cache
            │                       ├─ Has cache → Show cached + "offline" banner
            │                       └─ No cache → Show error
            └─ Fail (API error) → Try cache
                                  ├─ Has cache → Show cached + "offline" banner
                                  └─ No cache → Show error

User Scrolls → Load More
    ├─ Online → Fetch from API, cache it
    └─ Offline → Load cached page if available

Theme Toggle → Save to SharedPreferences (works online & offline)

Images → Cached via cached_network_image package
         ├─ First load → Download and cache
         └─ Subsequent loads → Load from cache instantly
```

## 📝 Important Notes

### Build Runner
After modifying any of these, regenerate code:
- `@freezed` classes
- `@JsonSerializable` models
- Retrofit service methods
- SQLite database models

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### State Management
The `MoviesState.success` now includes:
- `isLoadingMore`: Boolean indicating if next page is being fetched
- `isFromCache`: Boolean indicating if data is from cache (shows offline banner)

### API Key
The TMDb API key is embedded in `MoviesCubit._authorization`. **For production:**
- Move to environment variables (`.env` file)
- Use `flutter_dotenv` package
- Implement secure token refresh mechanism
- Never commit API keys to version control

### Database
- SQLite database automatically created on first app run
- Located in app's documents directory (platform-specific)
- All movies are stored with timestamps
- Database persists across app restarts
- Can be cleared by uninstalling app

### Design System
- **Design Size**: 375x812 (iPhone SE)
- **Tool**: Flutter ScreenUtil for responsive scaling
- **Colors**: Defined in `lib/core/theming/colors.dart`
- **Spacing**: Constants in `lib/core/helpers/spacing.dart`

## 🛠️ Customization

### Change Colors
Edit `lib/core/theming/colors.dart`:
```dart
static const Color gold = Color(0xFFD4AF37); // Change gold color
static const Color lightBg = Color(0xFFFFFFFF); // Change light background
```

### Modify Infinite Scroll Trigger Distance
In `lib/features/movies/presentation/ui/movies_screen.dart`:
```dart
// Line ~38: Change 500 to desired distance in pixels
_scrollController.position.maxScrollExtent - 500
```

### Adjust Cache Behavior
In `lib/features/movies/data/repos/movies_repo_impl.dart`:
- Modify logic to always use cache
- Adjust fallback behavior
- Add cache expiration logic

### Add More Movie Information
Edit `lib/features/movies/presentation/ui/widgets/movie_card.dart` to display additional fields:
- Budget, Revenue
- Genres (requires mapping genreIds to names)
- Director/Cast information

### Customize Theme Styling
Edit `lib/core/theming/app_theme.dart`:
- Change font sizes and weights
- Modify shadows and elevations
- Adjust padding and margins globally

## 🧪 Testing & Quality

```bash
# Run analyzer
flutter analyze

# Run tests
flutter test

# Format code
flutter format .

# Check for issues
flutter doctor

# Check dependencies
flutter pub outdated
```

### Testing Caching Behavior
1. **First Launch**: Open app, verify movies load from API
2. **Second Launch**: Close and reopen app, should load instantly from cache
3. **Offline Test**:
   - Turn on airplane mode
   - Close and reopen app
   - Verify cached movies appear with offline banner
4. **Scroll Test**: Scroll to load more pages, verify smooth loading
5. **Theme Test**: Toggle theme offline, should work without issue
6. **Image Test**: View movies offline, images should display from cache

## 📚 Documentation

- **Architecture Details**: See `claude.md`
- **Setup Guide**: See `SETUP_GUIDE.md`
- **Caching Plan**: Original caching implementation plan (see project notes)

## 🐛 Troubleshooting

**Movies not showing?**
- Check internet connection
- Check if database file was created
- Verify API credentials
- Check app logs: `flutter run -v` for verbose output

**Offline banner always showing?**
- Check internet connection availability
- Verify connectivity service is initialized
- Check database has cached data

**Cache not persisting?**
- Verify database file location (platform-specific)
- Check database initialization in `setupGetIt()`
- Ensure app has proper permissions to access storage
- Try `flutter clean && flutter pub get`

**Images not caching?**
- Check image URLs are valid
- Verify network connectivity for image downloads
- Check app has proper permissions for file storage
- Clear app cache: Settings → Apps → [App Name] → Clear Cache

**Theme not persisting?**
- Clear app cache: `flutter clean`
- Reinstall: `flutter pub get && flutter pub run build_runner build`
- Check SharedPreferences initialization in `setupGetIt()`

**Build errors?**
- Run `flutter clean`
- Run `flutter pub get`
- Run build_runner: `flutter pub run build_runner build --delete-conflicting-outputs`
- Delete `.dart_tool` and `build` directories
- Restart IDE

## 📦 Dependencies

### State Management & DI
- `flutter_bloc: ^8.1.3` - State management (Cubit pattern)
- `get_it: ^7.6.4` - Service locator/dependency injection

### Networking
- `dio: ^5.3.3` - HTTP client
- `retrofit: ^4.0.3` - Type-safe API client generation
- `pretty_dio_logger: ^1.3.1` - HTTP request/response logging

### Code Generation
- `freezed_annotation: ^2.4.1` - Immutable class annotations
- `freezed: ^2.4.5` - Code generator for freezed classes
- `json_serializable: ^6.7.1` - JSON serialization code generation
- `json_annotation: ^4.8.1` - JSON annotations
- `retrofit_generator: ^8.0.4` - Retrofit code generation
- `build_runner: ^2.4.7` - Code generation runner

### Data Persistence
- `sqflite: ^2.4.1` - SQLite database for caching
- `shared_preferences: ^2.2.3` - Key-value storage for theme preference

### UI & UX
- `flutter_screenutil: ^5.9.0` - Responsive design (375x812 base size)
- `cached_network_image: ^3.3.1` - Image caching and placeholder support
- `shimmer: ^3.0.0` - Loading skeleton/shimmer effect

## 📄 License

This project is created for educational purposes.

## 👨‍💻 Author

Built with Flutter & BLoC pattern following clean architecture principles with comprehensive caching strategies.

---

## 🚀 What's New in This Version

✨ **SQLite Database Caching**
- Automatic caching of all API responses
- Instant loading on subsequent app launches
- Offline support for previously loaded data

✨ **Smart Offline Mode**
- Automatic fallback to cache when internet unavailable
- Clear visual indicator (orange banner) showing cached data
- Seamless user experience without disruptions

✨ **Improved Infinite Scroll**
- Fixed scroll jumping to top during page loads
- Smooth scroll preservation while loading more
- Loading indicator appears at bottom only when needed

✨ **Enhanced State Management**
- `isLoadingMore` flag for tracking pagination load state
- `isFromCache` flag for indicating data source
- Better error handling with cache fallback

---

**Ready to use!** Run `flutter run` to start the app. The app will cache everything automatically and work seamlessly offline. 🎬✨
# movie-app-cashing-theming
