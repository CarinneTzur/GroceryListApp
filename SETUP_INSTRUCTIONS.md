# Recipe Meal Planner - Setup Instructions

## Prerequisites

### 1. Install Flutter
- Download Flutter from: https://flutter.dev/docs/get-started/install/windows
- Follow the installation instructions for your OS
- Verify installation by running: `flutter doctor`
- Ensure Chrome is installed (comes with most Windows systems)

### 2. Install Git (if not already installed)
- Download from: https://git-scm.com/downloads
- Follow installation wizard

---

## Step-by-Step Setup

### Step 1: Clone the Repository
```bash
git clone <repository-url>
cd recipe_meal_planner
```
Note: Replace `<repository-url>` with your actual GitHub repository URL.

### Step 2: Navigate to Project Directory
Open PowerShell or Command Prompt and navigate to the project:
```bash
cd "C:\Users\YourName\recipe_meal_planner"
```

### Step 3: Install Dependencies
```bash
flutter pub get
```

This will download all required packages listed in `pubspec.yaml`.

### Step 4: Get Your FREE Gemini API Key
1. Go to: https://gemini.google.com/apps/apikey (Or use this one for now: AIzaSyCSHGLIyidOK-RfatiJhW3X0tG4_0itQoY)
2. Sign in with your Google account
3. Click "Create API Key" or "Get API Key"
4. Copy the generated API key (save it somewhere safe - you'll need it later)

### Step 5: Run the App
```bash
flutter run -d chrome
```

**First time running might take 2-3 minutes** while Flutter builds the app.

**Note:** If you get an error about "build directory locked":
- Close all Chrome windows
- Open Task Manager (Ctrl+Shift+Esc)
- End any `chrome.exe` or `dart.exe` processes
- Run `flutter run -d chrome` again

### Step 6: Configure Gemini API Key
1. The app should open in Chrome automatically
2. Navigate to **Settings** (gear icon)
3. Click **"AI Chat Settings"**
4. Paste your Gemini API key
5. Click **"Save"**

### Step 7: Test the AI Chat Feature
1. Navigate to **Chat Brief** in the app
2. Type a message like: "I want healthy vegetarian meals"
3. Press Send
4. You should receive an AI-powered response from Gemini!

---

## Troubleshooting

### Issue: "No pubspec.yaml file found"
**Solution:** Make sure you're in the project root directory. Run:
```bash
cd recipe_meal_planner
```

### Issue: Build directory locked error
**Solution:**
1. Close Chrome completely
2. Run: `flutter clean`
3. Run: `flutter run -d chrome`

### Issue: Gemini API not working
**Solution:**
1. Verify your API key is correct at https://gemini.google.com/apps/apikey
2. Make sure you saved it in Settings → AI Chat Settings
3. Restart the app after saving the key

### Issue: Dependencies not installing
**Solution:**
```bash
flutter clean
flutter pub cache repair
flutter pub get
```

### Issue: Chrome not launching
**Solution:**
- Make sure Chrome is installed
- Try: `flutter devices` to see available devices
- Use: `flutter run -d web-server --web-port=8080` to run on a different port

---

## Project Structure

```
recipe_meal_planner/
├── lib/
│   ├── features/
│   │   ├── chat/          # AI chat feature with Gemini
│   │   ├── auth/          # Authentication screens
│   │   ├── recipes/      # Recipe search and display
│   │   └── ...
│   └── core/              # App-wide providers and routing
├── assets/                 # Images, icons, animations
├── pubspec.yaml            # Dependencies and configuration
└── README.md
```

---

## Key Dependencies

- **Flutter SDK**: UI framework
- **Riverpod**: State management
- **go_router**: Navigation
- **shared_preferences**: Local storage
- **http**: API calls
- **Gemini API**: AI chat functionality

---

## Development Commands

- **Run app**: `flutter run -d chrome`
- **Hot reload**: Press `r` in terminal while app is running
- **Hot restart**: Press `R` in terminal
- **Stop app**: Press `q` in terminal
- **Check for devices**: `flutter devices`
- **Clean build**: `flutter clean`

---

## Features Implemented

✅ Onboarding screens  
✅ User authentication (mock)  
✅ Profile setup  
✅ Recipe search  
✅ Meal planning interface  
✅ Grocery list management  
✅ AI chat with Gemini  
✅ Settings  

---

## Important Notes

- **No backend server required** - all data is stored locally
- **Mock authentication** - uses placeholder tokens
- **Gemini API key required** for AI chat to work
- **Requires internet** for AI responses (Gemini API calls)

---

## Getting Help

If you encounter issues:
1. Check the error message in the terminal
2. Run `flutter doctor` to verify setup
3. Check GitHub issues (if repository has issue tracker)
4. Verify all prerequisites are installed

---

Enjoy building with Recipe Meal Planner! 🍽️
