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
<summary><b>음악 검색 & 장르별 차트</b> </summary>
<div markdown="1">
	
  |![음악 검색](https://github.com/limsub/MULOG/assets/99518799/3a7f2978-d1be-403d-ac44-34e0cf2e8fd4)|![장르 차트](https://github.com/limsub/MULOG/assets/99518799/2451b25f-be0c-4124-b22d-f5c70a453dd9)|
  |:--:|:--:|
  |음악 검색|장르별 차트|

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

|![playbutton - 1](https://github.com/limsub/MULOG/assets/99518799/415cf94c-d0d4-4183-ace7-c6c9343ab037)|![playbutton - 2](https://github.com/limsub/MULOG/assets/99518799/a5fda1d7-b32d-4c51-9e92-316fa8984b0c)|
|:--:|:--:|
|재생|정지|

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




<details>

<summary><b>원하는 시간에 푸시 알림 구현 과정</b> </summary>
<div markdown="1">

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


</div>
</details>



<br>


### 5. UI
- **DiffableDataSource** 를 이용한 snapshot 기반 UICollectionView 애니메이션 구현
  |<img src="https://github.com/limsub/MULOG/assets/99518799/b59e7a84-3d1d-48cf-92bc-6f3994564c6c" align="center" width="200">|<img src="https://github.com/limsub/MULOG/assets/99518799/03840b22-881e-43cb-9ec8-7d2e477dc82c" align="center" width="200">|
  |--|--|
  |||
  
- **UISwipeGestureRecognizer** 를 이용한 제스처를 통해 이전/이후 날짜 전환
  |<img src="https://github.com/limsub/MULOG/assets/99518799/2b5bc315-04e2-4897-8d81-c039819f27ca" align="center" width="200">|<img src="https://github.com/limsub/MULOG/assets/99518799/79612ddf-b313-416d-90d5-f374ee5b0415" align="center" width="200">|
  |:--:|:--:|
  |이전 날짜|이후 날짜|
  
- **UICollectionViewDragDelegate**, **UICollectionViewDropDelegate** 를 이용한 셀 drag & drop 구현
  |<img src="https://github.com/limsub/MULOG/assets/99518799/f7b23a48-8f65-418b-9413-b065481e5a68" align="center" width="200">|<img src="https://github.com/limsub/MULOG/assets/99518799/516d2530-0de9-4571-83d6-68ff8f97985b" align="center" width="200">|
  |--|--|
  |||
  
- **UIBezierPath** 를 이용한 Custom Stacked Bar Chart 구현
  |<img src="https://github.com/limsub/MULOG/assets/99518799/e06d8636-05f9-44f5-b90d-6b3bc3682472" align="center" width="200">|<img src="https://github.com/limsub/MULOG/assets/99518799/768d1457-2c9e-44c6-9f6e-2e992a6a4ee9" align="center" width="200">|
  |:--:|:--:|
  |월간 차트|주간 차트|

	<details>
	
	<summary><b>CustomBarChartView 코드</b> </summary>
	<div markdown="1">
	
	```swift
	class CustomBarChartView: BaseView {
	
		var dataList: [DayGenreCountForBarChart]  // 날짜와 각 장르별 개수 
		var dayCount: Int  // 7, 28, 29, 30, 31
		var startDayString: String  // "20231001" 형식으로 String 타입의 시작 날짜
		
		/* ... */
		
		
		override func draw(_ rect: CGRect) {
		    super.draw(rect)
				
				// 여백
		    let leftSpace: CGFloat = 18
		    let rightSpace: CGFloat = 18
		    let bottomSpace: CGFloat = 20
		    
		    // 높이 및 너비
		    let height = rect.height
		    let width = rect.width
		    
		    // bar의 시작 위치 (x좌표)
		    var x: CGFloat = leftSpace
				
				// bar가 차지하는 공간의 너비
		    let itemWidth = (width - x - rightSpace) / CGFloat(dayCount)
		    
		    // 실제 bar의 너비
		    let barWidth = itemWidth * 0.8
		    
		    
		    x += itemWidth / 2  // bar 공간의 가운데에 그리기 위함
		    
		    // 시작 날짜 Int값으로 변환
		    guard let startDayIntLet = Int(startDayString) else { return }
		    var startDayInt = startDayIntLet   
		    
		    
		    // 반복문 시작 (dayCount만큼 bar 그림) (가로 방향)
		    for i in 0..<dayCount {
			if i >= dataList.count { return }
			
			let day = dataList[i].day
			let dayGenres = dataList[i].genreCounts
			
			let startY = height - bottomSpace
			var currentY = startY
			
			// day 작업
			if day != String(startDayInt + i) {
			    var space: CGFloat = CGFloat(Int(day)! - (startDayInt + i))
			    startDayInt += Int(space)   // 이후 배열에 맞춰주기 위해 아예 스타트 데이를 땡겨준다
			    x += (itemWidth * space)    // 더하고 그려주자
			}
			
			
			// 해당 날짜의 장르에 대한 반복문 시작 (세로 방향)
			for (index, name) in genres.enumerated() {
			    
			    var barColor: UIColor
			    var valueCnt: Int
			    
			    // 해당 장르에 대한 색상 찾기
			    for (key, value) in dayGenres {
				if key == name {
				    barColor = UIColor(hexCode: colors[index])
				    valueCnt = value
				}
			    }
			    
			    barColor.setStroke()
			    
			    let barPath = UIBezierPath()
			    barPath.lineWidth = barWidth
			    barPath.move(to:
					    CGPoint(x: x, y: currentY)
			    )
			    barPath.addLine(to:
										CGPoint(x: x, y: currentY - 15 * CGFloat(valueCnt))
			    )
			    currentY -= 15 * CGFloat(valueCnt)
			    barPath.stroke()
			    barPath.close()
			}
			
			x += itemWidth
		    }
		}
	}
	
	struct DayGenreCountForBarChart: Hashable { 
	    let day: String
	    let genreCounts: [String: Int]
	}
	```
	
	</div>
	</details>

<br>



## 🔥트러블 슈팅
### 1. 백그라운드 상태에서의 날짜 변경을 감지하지 못하는 이슈
<details>
<summary><b>앱스토어 버그 제보</b> </summary>
<div markdown="1">

<img src="https://github.com/limsub/MULOG/assets/99518799/cc603973-0c55-4c7b-9cc9-90630bed603c" align="center" width="400">

</div>
</details>

<details>
<summary><b>날짜 변경에 대해 세팅이 필요한 UI 객체</b> </summary>
<div markdown="1">

<img src="https://github.com/limsub/MULOG/assets/99518799/d8580588-6141-4f83-917d-4a55d8514a4c" align="center">

</div>
</details>

<br>


이슈
- Calendar 화면에서 `Date()` 값을 기반으로 오늘 날짜 파악 및 초기 세팅
- `viewDidLoad` 에서만 파악하기 때문에, 백그라운드 모드에서 날짜 변경을 감지하지 못함.


<br>


해결
- SceneDelegate의 `sceneWillEnterForeground` 에서 오늘 날짜 파악
- **Singleton Pattern** 을 활용하여 SceneDelegate와 CalendarVC에서 모두 접근 가능한 변수 생성
- **RxSwift**의 `BehaviorSubject` 타입으로 변수 생성, <br>
  새로 파악한 날짜를 `.onNext` 로 전달<br>
  `.bind` 로 이벤트 구독, `.distinctUntilChanged()` 를 이용해 값이 변경된 시점에 세팅 재실행


<br>




<br>



### 2. 시스템 알림 허용 여부와 앱 내 알림 허용 여부 동작 관리

<img src="https://github.com/limsub/MULOG/assets/99518799/7d7d72ff-e488-4889-a7fa-5334f168b507" align="center">


#### 2 - 1. 시스템 알림이 허용되어 있을 때, 앱 내 알림을 off해도 **앱 재실행 시 앱 내 알림이 on되는 이슈**

- 문제 원인
	- 구상 로직 : 초기 앱 실행 시 **시스템 알림 허용 여부 얼럿에서 허용** => **앱 내 알림 on**
		```swift
		UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { success, error in
		    UserDefaults.standard.set(success, forKey: NotificationUserDefaults.isAllowed.key)
		}
		```
	
	- `requestAuthorization` 메서드는 시스템 알림 허용 여부 얼럿 이 표시될 때만 실행되는 것이 아니라,<br>
	  **시스템 알림 허용 여부를 체크하기 위해 항상 실행**된다.
	  따라서 계속해서 메서드가 실행되었고 시스템 알림이 허용되었을 때 계속해서 앱 내 알림이 on된다.


<br>


- 문제 해결
	- UserDefaults에 추가로 bool 타입 값을 저장하여 **앱 최초 실행 여부** 값을 저장한다.
		```swift
		UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { success, error in
		    // 초기 앱 실행이라는 점 분기처리 -> 추가 UserDefaults
		    if !UserDefaults.standard.bool(forKey: NotificationUserDefaults.isFirst.key) {
		        UserDefaults.standard.set(success, forKey: NotificationUserDefaults.isAllowed.key)
		        UserDefaults.standard.set(true, forKey: NotificationUserDefaults.isFirst.key)
		    }
		    print("시스템 알림 설정 여부 : ", success)
		}
		```


<br>


#### 2 - 2. **앱 내 알림 설정 화면에서 시스템 알림 거부 시 대응**
- 기획
	- 앱 내 알림 on 상태에서 시스템 알림 off -> 앱 내 알림 off<br>
	  (앱 내 알림 off 상태에서 시스템 알림 on -> 별다른 대처 필요 x)


<br>


- 이슈 
 	- 시스템 알림 창에서 다시 앱을 실행시켰을 때, 시스템 알림 허용 여부 변경 사항을 캐치하지 못함


<br>


- 해결
	- SceneDelegate의 `sceneWillEnterForeground` 에서 시스템 알림 허용 여부를 항상 확인
   	- **Singleton Pattern** + **Custom Observable** 을 활용하여<br>
  	  시스템 알림이 off 되었을 때, 즉각 세팅 재실행
		```swift
		// SceneDelegate.swift
		func sceneWillEnterForeground(_ scene: UIScene) {
		    NotificationRepository.shared.checkSystemSetting {
				    SystemNotification.shared.isOn.value = true
					} failureCompletionHandler: {
				    SystemNotification.shared.isOn.value = false
				}
		}
		
		// NotificationSettingVC.swift
		override func viewDidLoad() {
		    super.viewDidLoad()
				SystemNotification.shared.isOn.bind { value in
				    DispatchQueue.main.async {
				        if value {
				            // 시스템에서 혀용했을 때는 다시 돌아오면 직접 허용시키게 하지만
				        } else {
				            // 시스템에서 거절했을 때는 아예 여기서도 거절을 시켜줘야 한다
				            self.settingView.controlSwitch.isOn = false
				            self.timeView.isHidden = true
				        }
				    }
				}		
		}
		```


  
