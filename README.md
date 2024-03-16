# MULOG - 나만의 음악 일기 앱


<p align="center">
  <img src="https://github.com/limsub/MyMusicDiary/assets/99518799/310c1162-9178-4012-b55c-3ee4cfd352f9" align="center" width="19%">
  <img src="https://github.com/limsub/MyMusicDiary/assets/99518799/bd0a11e9-1785-41fa-a2b8-86b431e78f56" align="center" width="19%">
  <img src="https://github.com/limsub/MyMusicDiary/assets/99518799/f0b71c62-7483-4e0d-a61e-f54c6a3d1726" align="center" width="19%">
  <img src="https://github.com/limsub/MyMusicDiary/assets/99518799/dce024cf-c9fa-4156-b9de-04988672db47" align="center" width="19%">
  <img src="https://github.com/limsub/MyMusicDiary/assets/99518799/e248cc49-148c-4066-81f4-0a5c1851d3b1" align="center" width="19%">
</p>

<br>

## 🎧 Mulog
> 서비스 소개 : 오늘 들었던 음악을 기록하는 음악 일기 앱<br>
개발 인원 : 1인<br>
개발 기간 : 2023.09.25 ~ 2023.10.19 (4주) <br>
[앱스토어 링크](https://apps.apple.com/kr/app/mulog-%EB%AE%A4%EB%A1%9C%EA%B7%B8-%EB%82%98%EB%A7%8C%EC%9D%98-%EC%9D%8C%EC%95%85-%EC%9D%BC%EA%B8%B0-%EC%95%B1/id6469449605)


<br>


## 📚 Tech Blog
- [FSPagerView + Custom Cell](https://velog.io/@s_sub/%EC%83%88%EC%8B%B9-iOS-12%EC%A3%BC%EC%B0%A8)
- [FSCalendar + Custom Cell](https://velog.io/@s_sub/%EC%83%88%EC%8B%B9-iOS-11%EC%A3%BC%EC%B0%A8)
- [MusicKit](https://velog.io/@s_sub/%EC%83%88%EC%8B%B9-iOS-13%EC%A3%BC%EC%B0%A8)
- [TestFlight / App Store 심사](https://velog.io/@s_sub/%EC%83%88%EC%8B%B9-iOS-14%EC%A3%BC%EC%B0%A8)
- [개인 앱 출시 회고](https://velog.io/@s_sub/%EC%83%88%EC%8B%B9-iOS-%EA%B0%9C%EC%9D%B8-%EC%95%B1-%EC%B6%9C%EC%8B%9C-%ED%9A%8C%EA%B3%A0-MULOG-%EB%AE%A4%EB%A1%9C%EA%B7%B8)


<br>


## 🛠 기술 스택
- UIKit, MVVM
- MusicKit, AVFoundation
- RealmSwift
- SnapKit, KingFisher, FSPagerView, FSCalendar, DGCharts
- Singleton pattern, Repository pattern
- Firebase Analytics, Firebase Crashlytics


<br>


## 💪 핵심 기능
- 특정 음악 검색 & 장르별 음악 차트
- 1일 최대 3개의 음악 저장
- 월간 & 주간 기록한 음악 통계
- 당일 음악 미기록 시 설정 시간에 로컬 푸시 알림
- 음악 선택 시 Apple Music 또는 Youtube Music 앱으로 이동
- 각 음악에 대한 preview 음원 재생


<br>


## 💻 구현 내용
### 1. MusicKit 프레임워크를 이용한 Apple Music 데이터 수집
<details>
<summary><b>func fetchMusic(_ searchTerm: String)</b> </summary>
<div markdown="1">

```swift
func fetchMusic(_ searchTerm: String) {
    
    Task {
        let status = await MusicAuthorization.request() // 미디어 및 Apple Music 접근 허용 여부 확인
        
        switch status {
        case .authorized:
            do {
                var request = MusicCatalogSearchRequest(
                    term: term,
                    types: [Song.self]  // 음악 검색
                )
                request.limit = 25
                request.offset = 1

                let result = try await request.response()

                self.musicList.value = result.songs.map({
                    return .init(
                        /* ... */
                    )
                })
                
            } catch {
                /* ... */
            }

        case .notDetermined, .denied, .restricted:
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            
            self.showAlert(
	            "미디어 및 Apple Music에 대한 접근이 허용되어 있지 않습니다", 
	            message: "접근 권한이 없으면 음악 검색이 불가능합니다. 권한을 허용해주세요", 
	            okTitle: "설정으로 이동"
	          ) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
            
        @unknown default:
		        /* ... */
        }
    }
}
```

</div>
</details>

<details>
<summary><b>음악 검색</b> </summary>
<div markdown="1">

</div>
</details>


<br>


### 2. Custom Observable 클래스를 이용한 반응형 MVVM 구현
<details>
<summary><b>class Observable</b> </summary>
<div markdown="1">

```swift
class Observable<T> {
    
    private var listener: ( (T) -> Void )?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> Void ) {
        print("바인드 실행")
        self.listener = closure
    }
}
```

</div>
</details>


<br>


### 3. AVPlayer를 이용한 preview 음원 재생
<details>
<summary><b>class PagerViewController</b> </summary>
<div markdown="1">

```swift
class PagerViewController: BaseViewController {
		
		let player = AVPlayer()
		let playerItem: AVPlayerItem?
		var isPlaying = false
		
		
		override func viewDidDisappear(_ animated: Bool) {
		    super.viewDidDisappear(animated)
		    // 재생중인 음악이 있다면, 정지해야 한다
		    
		    isPlaying = false
		    player.pause()
		    player.seek(to: .zero)
		}
}

extension PagerViewController: FSPagerViewDelegate {
		// 다음 곡으로 넘기는 경우
		func pagerViewDidEndDecelerating(_ pagerView: FSPagerView) {
				player.pause()
				isPlaying = false
				replacePlayer()  // 여기서 바로 플레이어를 대체하여, 버튼을 눌렀을 때 재생까지 딜레이가 없도록 한다
		}
}

extension PagerViewController {
		// player에서 재생할 곡 세팅 (url을 통해 미리 playerItem을 만들어둔다)
		func replacePlayer() {
				viewModel.updatePreviewURL(pagerView.currentIndex)
				
				guard let url = viewModel.makeURL() else { return }
				
				playerItem = AVPlayerItem(url: url)
				player.replaceCurrentItem(with: playerItem)
		}
		
		
		// 재생 버튼 클릭 (재생 or 정지)
		func playButtonClicked() {
				if !isPlaying() {
						player.play()
				} else {
						player.pause()
				}
		}
}


```

</div>
</details>
<details>

<summary><b>preview 음원 재생</b> </summary>
<div markdown="1">

</div>
</details>


<br>


### 4. 당일 음악 기록 여부에 따라 푸시 알림 제공
<details>
<summary><b>func updateNotifications()</b> </summary>
<div markdown="1">

```swift
func updateNotifications() {

    // UserDefault에 저장된 시간
    let time = UserDefaults.standard.string(forKey: NotificationUserDefaults.time.key)!
    guard let hour = Int(time.substring(from: 0, to: 1)) else { return }
    guard let minute =  Int(time.substring(from: 2, to: 3)) else { return }
    
    
		// 기존에 저장된 알림 모두 제거
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    
		// 오늘 포함 이후 60일에 대해 알림 등록
    for i in 0...59 {
        
        guard let notiDay = Calendar.current.date(byAdding: .day, value: i, to: Date()) else { continue }
        let notiDayComponent = Calendar.current.dateComponents([.day, .month, .year], from: notiDay)
        
        var component = DateComponents()
        component.hour = hour
        component.minute = minute
        component.year = notiDayComponent.year
        component.month = notiDayComponent.month
        component.day = notiDayComponent.day
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: component,
            repeats: false
        )
        
        let identifier = notiDay.toString(of: .full)
        
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
						/* ... */
        }
    }
}
```

</div>
</details>

<br>


- 기획<br>
  1. 사용자가 설정한 시각에 알림이 온다
  2. 당일 기록된 음악이 있으면 알림이 오지 않는다.


<br>


- 과정<br>
  - 반복 알림을 구현하기 위해 단순히 `NotificationTrigger`의 `repeats`를 true로 설정한다면<br>
  알림이 오기 전 당일 기록된 음악 유무를 확인할 수 없기 때문에 **기획-2** 구현이 불가능하다.
  - 따라서, 모든 날짜에 대해 다른 identifier로 알림을 등록하고, <br>
  기록된 음악 유무에 따라 수동으로 알림을 관리해야 한다.


<br>


- 구현<br>
  - 해당 날짜를 포함한 이후 60일에 대해 알림을 등록한다. (사용자가 설정한 시각으로 등록)
    - 각 알림의 identifier는 날짜를 String 타입으로 변환한 값 ("20231010")
  - 앱 실행 시 항상 등록된 알림의 개수를 파악하고,<br>
  개수가 15개 미만으로 떨어질 시 다시 60개의 알림을 새로 등록한다.


<br>


- 기록된 음악 유무 파악 방법<br>
  - 음악을 1개 이상 기록했을 때, 해당 날짜(identifier)의 알림 제거
  - 음악을 모두 제거했을 때, 해당 날짜의 알림 추가


<br>


- 알림을 업데이트하는 시점<br>
  - 알림 허용 스위치를 on으로 설정한 시점
  - 알림 시간 timePicker 값을 변경한 시점
  - 앱 실행 시 등록된 알림이 15개 미만임을 파악한 시점
  - (당일) 기록했던 음악을 모두 삭제한 시점


<br>


### 5. UI
- **DiffableDataSource** 를 이용한 snapshot 기반 UICollectionView 애니메이션 구현
- **UISwipeGestureRecognizer** 를 이용한 이전/이후 날짜 전환에 대해 간편한 방법 제공
- **UICollectionViewDragDelegate**, **UICollectionViewDropDelegate** 를 이용한 셀 drag & drop 구현


<br>



## 🔥트러블 슈팅
### 1. 백그라운드 상태에서의 날짜 변경을 감지하지 못하는 이슈
- Singleton pattern과 Observable 클래스를 활용한 데이터 변경 감지


### 2. 시스템 알림 허용 여부와 앱 내 알림 허용 여부 동작 관리
