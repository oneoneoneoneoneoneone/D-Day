# :pushpin: D-Day
디데이 이벤트를 관리할 수 있는 앱을 만들고 앱스토어 심사까지 진행해본 프로젝트 입니다.
>제작 기간: 2023.01 ~ 2023.03</br>
>참여 인원: 개인 프로젝트


</br>


## 기술 스택
- UIKit / SnapKit
- Realm
- MVP Architecture


</br>


## 기능 구현
### 1. 화면
  
|<img src="https://user-images.githubusercontent.com/94464179/226660360-6135616b-b121-4ebe-a64b-4800e7168dcb.png" width="60%" height="60%" alt>|<img src="https://user-images.githubusercontent.com/94464179/226660463-a2985b25-a308-47cd-969b-9d43aaa1e944.png" width="60%" height="60%" alt>|<img src="https://user-images.githubusercontent.com/94464179/226661179-d62d390b-3f64-4917-94a1-d4fb8db42811.png" width="60%" height="60%" alt>|<img src="https://user-images.githubusercontent.com/94464179/226660881-4904760b-65c3-40cd-9734-209b436e2e28.png" width="60%" height="60%" alt>|
|:--:|:--:|:--:|:--:|
| *목록(메인)* | *상세* | *신규/수정* | *설정* |


</br>


### 2. Repository

- **주요 데이터 Realm으로 저장** 
  - Repository.swift 코드: [🔗](https://github.com/oneoneoneoneoneoneone/NAVER-WEBTOON-CloneCoding/blob/main/NaverWebtoonCloneCoding/Util/Repository.swift)
  
- **설정값은 User Defaults로 저장** 
  - UserDefaultsManager.swift 코드: [🔗](https://github.com/oneoneoneoneoneoneone/NAVER-WEBTOON-CloneCoding/blob/main/NaverWebtoonCloneCoding/Util/Repository.swift)
     

</br>


## 트러블 슈팅 
### 1. 신규/수정 화면 구현 및 Cell 관리
  - 초기에는 수정 화면을 ScollView와 StackView를 사용해 나열하는 방식으로 만들었습니다. 입력하는 기능이 적었기 때문에 불편한 점은 없었지만, 입력 데이터가 추가될 수 있다는 가정하에 Cell 재사용이 가능한 UITableView를 사용하는 것이 좋겠다고 생각해 수정했습니다.
    - UITableViewDatasource 상속 메소드 내에서 Switch문으로 셀을 구분하는 코드를 작성하면서 모든 case를 자동완성 및 항목을 누락시키지 않기 위해 enum을 미리 작성한 뒤, 배열로 만들어 사용했습니다.
      <details>
      <summary><b>코드</b></summary>
      <div markdown="1">

      ~~~Swift
      //EditPresenter
        private final let cellList = EditViewController.CellList.allCases
      ~~~

      ~~~Swift
      //EditViewController
        enum CellList: CaseIterable{
          case title, date, backgroundColor, backgroundImage, isCircle, memo
          // isStartCount, repeatCode
          ...
        }
      ~~~

      </div>
      </details>
  

</br>


  ### 2. Realm Schema 변경
  - 기존에 사용해본 로컬디비인 UserDefaults와 다르게 Class 파일 내 칼럼을 수정/삭제하고 빌드했을때 read하는 부분에서 오류가 발생되었습니다.
    - 저장하는 데이터 타입 내 컬럼에 대해 변경사항이 있을 경우에 버전을 올리고 관계 데이터를 추가하는 작업이 필요하다는 점을 알게되었습니다.
      <details>
      <summary><b>코드</b></summary>
      <div markdown="1">

      - 현재는 스키마버전을 올리는 코드만 사용하고 있습니다.
      ~~~Swift
      //EditPresenter
        let config = Realm.Configuration(fileURL: realmURL, schemaVersion: 5)
        return try! Realm(configuration: config)
      ~~~

      </div>
      </details>


</br>


  ### 3. Realm 데이터 조회 후 수정했을 때 오류
  - 수정/신규 화면에서 데이터를 저장할 때 Realm 오류가 발생되었습니다.
    - Realm에서 조회한 object는 단순 복제한 값이 아니라, core database에 연동 된 값이라는 것을 확인했습니다.
    - 읽어온 값을 바로 수정하면 오류가 나기 때문에, 저장할 인스턴스를 추가하여 수정된 값을 치환한 후 저장하도록 수정했습니다.
      <details>
      <summary><b>코드</b></summary>
      <div markdown="1">

      ~~~Swift
      //EditPresenter
        let saveItem = Item()
          saveItem.id = item.id
          saveItem.title = editItem.title
          saveItem.titleColor = editItem.titleColor
          saveItem.date = editItem.date
          saveItem.isBackgroundColor = editItem.isBackgroundColor
          saveItem.backgroundColor = editItem.backgroundColor
          saveItem.isBackgroundImage = editItem.isBackgroundImage
          saveItem.isCircle = editItem.isCircle
          saveItem.memo = editItem.memo == textViewPlaceHolder ? "" : editItem.memo

          //저장
          repository.editItem(saveItem)
      ~~~

      </div>
      </details>
  
  
  </br>


  ### 4. 앱심사 반려 - ipad 오류 및 16.3.1 버전 오류
  - iPad에서 UIActivityViewController를 띄웠을때, iOS 16.3.1 버전에서 UIAlertController를 띄웠을때 앱이 죽는 현상이 있었습니다.
    - popoverPresentationController의 위치값을 주기위한 속성을 추가해 해결했습니다.

      <details>
      <summary><b>코드</b></summary>
      <div markdown="1">

      ~~~Swift
      //DetailViewController
          alert.popoverPresentationController?.sourceView = button
      ~~~

      </div>
      </details>
   
  
  </br>

  
  ### 5. 위젯(미완성 기능) 빌드 오류 & 토스트 메시지 커스텀
  - App에서 사용한 Repository나 클래스 파일을 Widget Extension에 공유하기 위해 그룹 저장소를 사용했습니다.
  - 기존에 모든 공용 메소드를 Util 클래스에 넣고 사용했는데, 위젯에서 추가하지 않은 View관련 라이브러리를 import 하고있어 오류가 발생되었습니다.
    - Utill 클래스 내 메소드를 세분화하여 분리하고 커스텀 가능한 외부 라이브러리인 Toast-Swift(토스트 메시지 기능)는 삭제했습니다.
      - 토스트 메시지 커스텀 클래스 코드: [🔗](https://github.com/oneoneoneoneoneoneone/D-Day/blob/main/D-Day/Presentation/Custom/ToastView.swift)
