# App Store 제출 체크리스트

## 자동화 가능 (완료)
- [x] pubspec.yaml version 1.0.0+1
- [x] 스토어 메타데이터 (ko) 텍스트
- [x] 개인정보처리방침 URL 연결
- [x] Info.plist 권한 설명 문구

## 수동 작업 필요
- [ ] App Store Connect 앱 등록 (Bundle ID: com.bookclub.app)
- [ ] TestFlight 내부 테스트 빌드 업로드 (xcodebuild archive)
- [ ] 스크린샷 6.5" 3장 이상 (iPhone 15 Pro Max 시뮬레이터)
- [ ] 스크린샷 5.5" 3장 이상 (iPhone 8 Plus 시뮬레이터)
- [ ] 앱 아이콘 1024x1024 PNG (투명 배경 불가)
- [ ] 개인정보처리방침 페이지 실제 배포 (https://bookclub.app/privacy)
- [ ] App Store Connect 심사 제출
- [ ] 출시 후 v1.0.0 Git 태그 및 Phase 10 종료 커밋
