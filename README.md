# Recipe Meal Planner

An AI-powered Flutter application for personalized meal planning with nutrition goals, recipe management, and grocery list generation.

## 🚀 Project Overview

This is a comprehensive meal planning application built with Flutter that helps users create personalized meal plans based on their dietary preferences, health goals, and cooking constraints. The app features AI-powered recipe recommendations, smart grocery list generation, and nutrition tracking.

## 📱 Features Implemented

### ✅ **Authentication & Onboarding**
- **User Registration**: Email/password signup with validation
- **User Login**: Secure authentication with JWT tokens
- **Password Reset**: Email-based password recovery
- **Onboarding Flow**: 4-slide introduction to app features
- **Profile Setup**: Comprehensive user preference collection

### ✅ **Core Navigation & UI**
- **Bottom Navigation**: 5-tab navigation (Home, Recipes, Meal Plan, Grocery, Profile)
- **Material Design 3**: Modern, consistent UI with custom theming
- **Responsive Design**: Works across different screen sizes
- **State Management**: Riverpod for efficient state handling

### ✅ **Recipe Management**
- **Recipe Search**: Filter by category, diet type, cooking time
- **Recipe Details**: Nutrition info, cooking instructions, ratings
- **Recipe Categories**: Breakfast, Lunch, Dinner, Snacks, etc.
- **Diet Filters**: Vegetarian, Vegan, Keto, Gluten-Free, etc.
- **Mock Recipe Database**: 4 sample recipes for testing

### ✅ **Meal Planning**
- **Flexible Duration**: 3-7 day meal plan creation
- **Meal Types**: Breakfast, Lunch, Dinner, Snacks
- **Plan Generation**: AI-powered meal plan suggestions
- **Recipe Integration**: Add recipes to specific meals
- **Plan Management**: Edit and customize meal plans

### ✅ **Grocery List Management**
- **Smart Consolidation**: Automatically groups ingredients
- **Category Organization**: Meat, Vegetables, Dairy, Grains, Pantry
- **Quantity Management**: Adjust quantities and units
- **Check-off Functionality**: Mark items as purchased
- **Manual Add/Remove**: Full CRUD operations

### ✅ **User Profile & Preferences**
- **Health Goals**: Weight loss, maintenance, muscle building
- **Activity Levels**: Sedentary to very active
- **Dietary Restrictions**: Allergies, intolerances, diet types
- **Cooking Preferences**: Budget, time constraints, serving sizes
- **Profile Management**: Edit personal information

### ✅ **AI Chat Brief**
- **Natural Language Input**: Describe preferences in plain English
- **Smart Responses**: Context-aware AI responses
- **Preference Capture**: Stores user preferences from conversations
- **Chat History**: Persistent conversation memory

### ✅ **Settings & Account**
- **App Settings**: Notifications, theme, units
- **Data Management**: Export data, clear cache
- **Account Management**: Profile editing, logout
- **Support**: Help, contact, about information

## 🏗️ Architecture

### **Project Structure**
```
lib/
├── core/
│   ├── providers/          # Global state management
│   ├── router/            # Navigation configuration
│   └── theme/             # App theming and styling
├── features/
│   ├── auth/              # Authentication screens
│   ├── onboarding/        # App introduction
│   ├── profile/           # User profile management
│   ├── home/              # Main dashboard
│   ├── chat/              # AI chat interface
│   ├── recipes/           # Recipe search and management
│   ├── meal_plan/         # Meal planning functionality
│   ├── grocery/           # Grocery list management
│   └── settings/          # App settings
└── main.dart              # App entry point
```

### **Technology Stack**
- **Framework**: Flutter 3.3.4+
- **State Management**: Riverpod 2.4.9
- **Navigation**: GoRouter 12.1.3
- **Local Storage**: SharedPreferences 2.2.2
- **HTTP Client**: Dio 5.4.0
- **UI Components**: Material Design 3

## 🚀 Getting Started

### **Prerequisites**
- Flutter SDK 3.3.4 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code
- Chrome browser (for web testing)

### **Installation**

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd GroceryListApp
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   # For web (recommended for testing)
   flutter run -d chrome
   
   # For Android
   flutter run -d android
   
   # For iOS
   flutter run -d ios
   ```

### **Testing the App**

1. **Launch the app** - You'll see the onboarding screen
2. **Complete onboarding** - Go through the 4 introduction slides
3. **Login/Register** - Use any email/password (mock authentication)
4. **Setup Profile** - Configure your preferences and goals
5. **Explore Features** - Navigate through all screens using bottom navigation

## 📖 User Workflow

### **First Time User**
1. **Onboarding** → Learn about app features
2. **Registration** → Create account with email/password
3. **Profile Setup** → Set health goals, dietary preferences, cooking constraints
4. **Home Dashboard** → Access quick actions and navigation

### **Daily Usage**
1. **Home Screen** → View recent activity and quick actions
2. **Recipe Search** → Find recipes by category, diet, or cooking time
3. **Meal Planning** → Create 3-7 day meal plans
4. **Grocery Lists** → Generate and manage shopping lists
5. **Chat Brief** → Update preferences through natural conversation

### **Feature Navigation**
- **Bottom Navigation**: Switch between main features
- **Search & Filters**: Find specific recipes or content
- **Settings**: Manage app preferences and account

## 🔧 Current Implementation Status

### **MVP Features (Fully Functional)**
- ✅ Complete authentication flow
- ✅ User onboarding and profile setup
- ✅ Recipe search with filtering
- ✅ Basic meal planning interface
- ✅ Grocery list management
- ✅ AI chat interface
- ✅ Settings and account management
- ✅ Navigation and routing

### **Mock/Placeholder Features**
- 🔄 **Authentication**: Uses mock JWT tokens (no real backend)
- 🔄 **Recipe Database**: 4 sample recipes (no real database)
- 🔄 **AI Responses**: Simple keyword-based responses
- 🔄 **Meal Plan Generation**: Placeholder logic
- 🔄 **Grocery List Export**: Basic sharing functionality
- 🔄 **Nutrition Data**: Static nutrition information

## 🚧 What's Left to Complete

### **Backend Integration**
- [ ] **Real Authentication API**: JWT token validation with Spring Security
- [ ] **User Profile API**: CRUD operations for user data
- [ ] **Recipe Database**: PostgreSQL with pgvector for semantic search
- [ ] **Meal Plan API**: Save and retrieve meal plans
- [ ] **Grocery List API**: Persistent grocery list storage

### **AI & Machine Learning**
- [ ] **Recipe Recommendations**: ML-based recipe suggestions
- [ ] **Nutrition Analysis**: Real-time nutrition calculations
- [ ] **Meal Plan Optimization**: AI-powered meal plan generation
- [ ] **Natural Language Processing**: Advanced chat brief processing
- [ ] **Semantic Search**: Vector-based recipe search

### **Advanced Features**
- [ ] **Recipe Import**: Admin endpoint for recipe curation
- [ ] **Pantry Management**: Track available ingredients
- [ ] **Meal Prep Mode**: Optimize for batch cooking
- [ ] **Budget Optimization**: Cost-effective meal suggestions
- [ ] **Allergy Enforcement**: Strict allergen filtering
- [ ] **Nutrition Tracking**: Daily calorie/protein monitoring

### **UI/UX Enhancements**
- [ ] **Recipe Images**: Real recipe photos
- [ ] **Cooking Instructions**: Step-by-step guides
- [ ] **Nutrition Charts**: Visual nutrition tracking
- [ ] **Offline Support**: Cache recipes for offline use
- [ ] **Dark Mode**: Complete dark theme implementation
- [ ] **Accessibility**: Screen reader and accessibility support

### **Performance & Quality**
- [ ] **Error Handling**: Comprehensive error management
- [ ] **Loading States**: Better loading indicators
- [ ] **Caching Strategy**: Efficient data caching
- [ ] **Testing**: Unit and widget tests
- [ ] **Performance Optimization**: App performance tuning

## 🎯 MVP vs Production Features

### **MVP (Current State)**
- Basic authentication with mock backend
- Simple recipe search with static data
- Manual meal planning interface
- Basic grocery list functionality
- Simple AI chat with keyword responses
- Core navigation and settings

### **Production Ready**
- Real backend integration with Spring Security
- Comprehensive recipe database with images
- AI-powered meal plan generation
- Smart grocery list with cost optimization
- Advanced AI chat with natural language processing
- Complete nutrition tracking and analysis

## 🛠️ Development Notes

### **Mock Authentication**
The app currently uses mock authentication for testing:
- Any email/password combination will work
- Mock JWT tokens are generated
- User data is stored in SharedPreferences
- No real backend validation

### **Sample Data**
- 4 sample recipes with basic nutrition info
- Mock user profiles and preferences
- Static meal plan templates
- Sample grocery list items

### **State Management**
- Riverpod for global state management
- SharedPreferences for local storage
- Provider pattern for dependency injection

## 📱 Supported Platforms

- ✅ **Web**: Chrome, Edge, Safari
- ✅ **Android**: API 21+ (Android 5.0+)
- ✅ **iOS**: iOS 11.0+
- ✅ **Windows**: Windows 10+ (requires Developer Mode)
- ✅ **macOS**: macOS 10.14+
- ✅ **Linux**: Ubuntu 18.04+

---

**Built with ❤️ using Flutter**
