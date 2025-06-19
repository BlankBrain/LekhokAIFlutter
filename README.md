# KelhokAI - AI Content Generator

A Flutter mobile application MVP that leverages an existing AI backend to provide users with core content generation features: **story generation** and **caption generation**.

## 🎯 Overview

KelhokAI is a clean, intuitive Flutter mobile application designed to provide seamless access to AI-powered content generation. The app follows clean architecture principles and best coding practices to ensure maintainability, testability, and scalability.

## 🚀 Features

### Core MVP Features
- **Story Generation**: Generate creative stories based on textual prompts
- **Caption Generation**: Generate captions/descriptions based on context
- **Copy to Clipboard**: Easy copying of generated content
- **Clean, Modern UI**: Intuitive tabbed interface for both features
- **Loading States**: Clear visual feedback during API calls
- **Error Handling**: User-friendly error messages

### Technical Features
- **Clean Architecture**: Separation of concerns with Domain, Data, and Presentation layers
- **State Management**: Riverpod for robust state management
- **Dependency Injection**: GetIt for managing dependencies
- **Error Handling**: Comprehensive error handling with custom failure classes
- **Responsive Design**: Adapts to different screen sizes
- **Testing Infrastructure**: Unit and widget tests

## 🏗️ Architecture

The application follows **Clean Architecture** principles with three main layers:

### 📊 Project Structure
```
lib/
├── core/                           # Core utilities and common code
│   ├── errors/                     # Failure classes and error handling
│   ├── usecases/                   # Base use case definitions
│   └── utils/                      # Constants and utility functions
├── features/                       # Feature-based organization
│   └── content_generation/         # Main feature
│       ├── data/                   # Data layer
│       │   ├── datasources/        # API client implementation
│       │   ├── models/             # Data Transfer Objects (DTOs)
│       │   └── repositories/       # Repository implementations
│       ├── domain/                 # Domain layer (Business Logic)
│       │   ├── entities/           # Business objects
│       │   ├── repositories/       # Repository interfaces
│       │   └── usecases/           # Business use cases
│       └── presentation/           # Presentation layer (UI)
│           ├── providers/          # Riverpod state management
│           ├── screens/            # App screens
│           └── widgets/            # Reusable UI components
├── app.dart                        # App configuration and theming
├── main.dart                       # App entry point
└── injection_container.dart       # Dependency injection setup
```

### 🔄 Data Flow
1. **UI** triggers actions through Riverpod providers
2. **Providers** call use cases from the domain layer
3. **Use Cases** execute business logic and call repositories
4. **Repositories** fetch data from remote data sources
5. **Data Sources** make API calls and handle responses
6. **Results** flow back through the layers to update the UI

## 🛠️ Tech Stack

### Core Technologies
- **Flutter**: ^3.32.4 - Cross-platform mobile framework
- **Dart**: ^3.8.1 - Programming language

### Key Dependencies
- **flutter_riverpod**: ^2.4.9 - State management
- **http**: ^1.1.2 - HTTP client for API calls
- **get_it**: ^7.6.4 - Dependency injection
- **dartz**: ^0.10.1 - Functional programming (Either type)
- **equatable**: ^2.0.5 - Value equality
- **logging**: ^1.2.0 - Logging infrastructure

### Development Dependencies
- **flutter_test**: Testing framework
- **mockito**: ^5.4.2 - Mocking for tests
- **build_runner**: ^2.4.7 - Code generation
- **json_serializable**: ^6.7.1 - JSON serialization

## 🔧 Setup and Installation

### Prerequisites
- Flutter SDK (^3.32.4)
- Dart SDK (^3.8.1)
- An IDE (VS Code, Android Studio, or IntelliJ)

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd kelhok_ai
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code (for JSON serialization)**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### 🔧 Configuration

#### API Configuration
Update the API base URL in `lib/core/utils/constants.dart`:
```dart
class ApiConstants {
  static const String baseUrl = 'https://your-api-domain.com/api/v1';
  // ... other constants
}
```

#### Environment Setup
The app is configured to work with the backend API that provides:
- **Endpoint**: `POST /generate`
- **Request**: `{"storyIdea": "string", "character": "string"}`
- **Response**: `{"story": "string", "imagePrompt": "string", ...}`

## 📱 Usage

### Story Generation
1. Open the app and navigate to the "Story Generator" tab
2. Enter your story idea in the text field (e.g., "A knight searching for a legendary sword")
3. Tap "Generate Story"
4. View the generated story and copy it to clipboard if needed

### Caption Generation
1. Navigate to the "Caption Generator" tab
2. Enter context for your caption (e.g., "A serene beach at sunrise")
3. Tap "Generate Caption"
4. View the generated caption and copy it to clipboard if needed

## 🧪 Testing

### Running Tests
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test
flutter test test/widget_test.dart
```

### Test Structure
- **Unit Tests**: Test business logic and use cases
- **Widget Tests**: Test UI components
- **Integration Tests**: Test complete user flows (future enhancement)

## 🔍 Code Quality

### Static Analysis
```bash
# Run Flutter analyzer
flutter analyze

# Run linter
flutter pub run dart_code_metrics:metrics analyze lib

# Format code
flutter format .
```

### Architecture Validation
The app follows these architectural principles:
- **Dependency Inversion**: Higher-level modules don't depend on lower-level modules
- **Single Responsibility**: Each class has one reason to change
- **Open/Closed**: Open for extension, closed for modification
- **Interface Segregation**: Clients depend on interfaces they use

## 🚀 Building and Deployment

### Build for Production

#### Web
```bash
flutter build web
```

#### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

#### iOS
```bash
flutter build ios --release
```

## 🔮 Future Enhancements

The current MVP can be extended with:
- **User Authentication**: Login/registration system
- **Content History**: Save and view previously generated content
- **Character Selection**: Choose different AI personas
- **Offline Support**: Cache content for offline viewing
- **Advanced Settings**: Customize generation parameters
- **Image Generation**: Visual content creation
- **Push Notifications**: Content updates and reminders

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Follow the coding standards and architecture patterns
4. Add tests for new functionality
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### Coding Standards
- Follow Dart's official style guide
- Use meaningful variable and function names
- Add documentation comments for public APIs
- Maintain test coverage above 80%
- Ensure all linting rules pass

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For support, email [support@kelhok.ai](mailto:support@kelhok.ai) or create an issue in the repository.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Riverpod community for state management guidance
- Clean Architecture principles by Robert C. Martin
- The AI backend team for providing the content generation API

---

**Built with ❤️ using Flutter and Clean Architecture principles**
