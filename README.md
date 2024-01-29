# MULOG - 나만의 음악 일기 앱


<p align="center">
  <img src="https://github.com/limsub/MyMusicDiary/assets/99518799/310c1162-9178-4012-b55c-3ee4cfd352f9" align="center" width="19%">
  <img src="https://github.com/limsub/MyMusicDiary/assets/99518799/bd0a11e9-1785-41fa-a2b8-86b431e78f56" align="center" width="19%">
  <img src="https://github.com/limsub/MyMusicDiary/assets/99518799/f0b71c62-7483-4e0d-a61e-f54c6a3d1726" align="center" width="19%">
  <img src="https://github.com/limsub/MyMusicDiary/assets/99518799/dce024cf-c9fa-4156-b9de-04988672db47" align="center" width="19%">
  <img src="https://github.com/limsub/MyMusicDiary/assets/99518799/e248cc49-148c-4066-81f4-0a5c1851d3b1" align="center" width="19%">
</p>

<br>

## 앱 소개

- 오늘 들은 음악으로 하루를 기록하는 앱
- MusicKit 프레임워크를 기반 Apple Music 음악 정보 제공
- 기록한 음악들의 통계를 보여주는 차트 제공 (Charts)
- 오늘의 음악을 기록하지 않았을 때, 푸시 알림 제공 (UNUserNotification)

- [앱 출시 회고 블로그 게시글](https://velog.io/@s_sub/%EC%83%88%EC%8B%B9-iOS-%EA%B0%9C%EC%9D%B8-%EC%95%B1-%EC%B6%9C%EC%8B%9C-%ED%9A%8C%EA%B3%A0-MULOG-%EB%AE%A4%EB%A1%9C%EA%B7%B8)
- [앱스토어 링크](https://apps.apple.com/kr/app/mulog-%EB%AE%A4%EB%A1%9C%EA%B7%B8-%EB%82%98%EB%A7%8C%EC%9D%98-%EC%9D%8C%EC%95%85-%EC%9D%BC%EA%B8%B0-%EC%95%B1/id6469449605)

<br>

## 사용 기술

- UIKit, AutoLayout, SnapKit
- MVVM, Singleton, Repository
- FSPagerView, FSCalendar, Charts
- MusicKit
- Realm

<br>

## 구현
- Custom Observable 클래스를 활용한 MVVM 구현
- Repository pattern을 이용한 Realm CRUD 구현
- NetworkMonitor를 통한 네트워크 예외처리
- SingleTon Pattern의 활용 - 데이터 변경 감지 및 foreground 진입 시 상태 변화 감지
- UIBezierPath를 이용한 Bar chart 구현
- AVPlayer를 이용한 음악 재생 기능 구현
- DiffableDatasource를 이용한 UICollectionView 애니메이션 구현
- 디비 정규화 + Realm Migration

<br>

## 트러블 슈팅
- [시스템 알림과 앱 내 알림 간 상호작용](https://prairie-drill-e3a.notion.site/MULOG-c2aad11e2b7e4eac9e3c43bf1df7744c)
- 앱이 백그라운드에서 유지되는 동안 다음 날짜로 바뀌었을 때 캘린더 선택 범위 이슈
