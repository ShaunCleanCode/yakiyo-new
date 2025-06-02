# Yakiyo New

## 개발 환경
- Flutter SDK: 최신 버전
- Xcode: 16.0 (Build version 16A242d)
- iOS 최소 배포 버전: 13.0
- macOS: 23.6.0 (M1 Max)

## 주요 설정
1. iOS 설정
   - Podfile에서 iOS 플랫폼 버전을 13.0으로 설정
   - Firebase Auth를 위한 최소 iOS 버전 요구사항 충족

2. Firebase 설정
   - GoogleService-Info.plist 파일이 iOS와 macOS 프로젝트에 포함됨
   - Firebase Auth 설정 완료

## 프로젝트 구조
- lib/
  - common/: 공통 위젯 및 에셋
  - core/: 앱의 핵심 설정 및 상수
  - features/: 주요 기능별 모듈
  - services/: API 및 서비스 관련 코드

## 실행 방법
1. Flutter 의존성 설치
```bash
flutter pub get
```

2. iOS 의존성 설치
```bash
cd ios
pod install
cd ..
```

3. 앱 실행
```bash
flutter run
```

## 주의사항
- iOS 시뮬레이터 실행 시 iOS 13.0 이상 필요
- Firebase Auth 사용을 위한 적절한 설정 필요
