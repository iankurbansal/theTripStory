# TripStory - Travel Planning Application

A modern travel planning application with mobile-first approach.

## 🏗️ Architecture

```
Mobile Apps (iOS/Android) → Firebase Auth → Railway API → Database
                          (JWT tokens)    (Spring Boot)
```

## 📁 Project Structure

```
├── backend/          # Spring Boot REST API
│   ├── src/          # Java source code
│   ├── pom.xml       # Maven dependencies
│   └── Dockerfile    # Container config
├── frontend/         # Flutter web source
│   ├── lib/          # Dart source code
│   └── pubspec.yaml  # Flutter dependencies
├── webapp/           # GitHub Pages (built Flutter)
├── mobile/           # Future iOS/Android apps
└── docs/             # Documentation
```

## 🚀 Tech Stack

### Backend
- **Framework**: Spring Boot 3.2
- **Language**: Java 17
- **Database**: PostgreSQL (Railway)
- **Authentication**: Firebase Admin SDK
- **Deployment**: Railway

### Frontend  
- **Framework**: Flutter 3.x
- **Authentication**: Firebase Auth
- **Hosting**: GitHub Pages
- **Domain**: thetripstory.com/webapp

### Mobile (Planned)
- **iOS**: Swift/Flutter
- **Android**: Kotlin/Flutter
- **Authentication**: Firebase Auth

## 🔧 Development Setup

### Backend
```bash
cd backend
mvn spring-boot:run
```

### Frontend
```bash
cd frontend  
flutter run -d chrome
```

## 🌐 Live Deployment

- **Web App**: https://thetripstory.com/webapp
- **API**: [Railway URL after deployment]
- **Mobile**: [App Store/Play Store - Coming Soon]

## 🔒 Security

- Firebase Authentication with JWT tokens
- CORS configured for production domains
- Environment variables for sensitive config
- No secrets committed to repository

## 📱 Future Plans

- Native iOS app
- Native Android app  
- Offline capability
- Advanced trip planning features

---

Built with ❤️ for travelers everywhere