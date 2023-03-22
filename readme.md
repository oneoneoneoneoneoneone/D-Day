# :pushpin: D-Day
디데이 이벤트를 관리할 수 있는 앱을 만들고 앱스토어 출시까지 진행해본 프로젝트 입니다.
>제작 기간: 2023.01 ~ 2023.03</br>
>참여 인원: 개인 프로젝트


</br>


## 기술 스택
> UIKit / SnapKit / Realm / MVP Architecture


</br>


## 기능 구현
### 1. 화면
  
|<img src="https://user-images.githubusercontent.com/94464179/226660360-6135616b-b121-4ebe-a64b-4800e7168dcb.png" width="90%" height="90%" alt>|<img src="https://user-images.githubusercontent.com/94464179/226660463-a2985b25-a308-47cd-969b-9d43aaa1e944.png" width="90%" height="90%" alt>|<img src="https://user-images.githubusercontent.com/94464179/226661179-d62d390b-3f64-4917-94a1-d4fb8db42811.png" width="85%" height="85%" alt>|<img src="https://user-images.githubusercontent.com/94464179/226660881-4904760b-65c3-40cd-9734-209b436e2e28.png" width="90%" height="90%" alt>|
|:--:|:--:|:--:|:--:|
| *목록(메인)* | *상세* | *신규/수정* | *설정* |


</br>


### 2. 구조
  
- MVP..
- delegate 패턴으로 화면간 데이터를 전달했습니다.
- Cell에서 수정된 값을 TableView로 전달
- Edit화면에서 생성한 item id를 Main에 전달
  
  
</br>


### 3. Repository

- **Realm으로 저장** 
  - Repository.swift 코드 확인: [🔗](https://github.com/oneoneoneoneoneoneone/NAVER-WEBTOON-CloneCoding/blob/main/NaverWebtoonCloneCoding/Util/Repository.swift)
  
- **설정값은 User Defaults로 저장** 
  - UserDefaultsManager.swift 코드 확인: [🔗](https://github.com/oneoneoneoneoneoneone/NAVER-WEBTOON-CloneCoding/blob/main/NaverWebtoonCloneCoding/Util/Repository.swift)
     

</br>

 
### 3.4. 알림
  
- 


</br>


## 트러블 슈팅 
### 1. 초기에는 신규작성화면을 StackView 안에 넣어서 나열하는 방식으로 만들었으나, UITableView를 사용하면서 메소드 내 Switch문으로 셀을 구분하는 코드가 필요했습니다.
  - 모든 case를 자동완성 및 항목을 누락시키지 않기 위해 enum을 미리 작성한 뒤, 배열로 만들어 사용했습니다.
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


  ### 2. 수정한 데이터를 저장했을 때 Realm 오류
  - 오류내용: Attempting to modify object outside of a write transaction - call beginWriteTransaction on an RLMRealm instance first.
  - 읽어온 item을 바로 수정하면 오류가 발생하기 때문에 저장할 item 인스턴스를 추가하고 수정된 값을 치환 후 저장하도록 했습니다.

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


  ### 3. 공유하기 ipad 오류
  - 오류 내용: terminating with uncaught exception of type NSException
  - ipad에서만 공유하기 UIActivityViewController를 띄웠을때 앱이 죽는 현상이 있었습니다.
  - popoverPresentationController에 barButtonItem을 이벤트를 일으킨 버튼으로 추가하여 해결했습니다.

  <details>
  <summary><b>코드</b></summary>
  <div markdown="1">
  
  ~~~Swift
  //DetailViewController
      activityViewController.popoverPresentationController?.barButtonItem = UIBarButtonItem(customView: shareButton)
  ~~~
  
  </div>
  </details>
   
  
  </br>

  
  ### 4. 기존에 navigationView.pop을 이용해 모든 화면을 연결했으나, 상세>수정을 반복하면 화면이 계속 쌓이고 홈으로 돌아가기 번거로워져서 Edit화면은 present로 띄우도록 수정했습니다. 새로운 item을 썼을 때는 Main화면에 id 값을 넘겨주고 해당 item의 상세화면을 띄우는 방식으로 화면을 설계했습니다.
  
     
  </br>

  
  ### 4. 위젯(미완료) 빌드오류 & 토스트메시지 라이브러리 커스텀
  - 오류 내용: undefined symbol error
  - 위젯 익스텐션?? 에서 데이터를 사용하기위해 그룹저장소를 사용했는데, Util 내 메소드도 위젯에서 사용하기 위해 그룹에 추가해서 사용하려했음. 위젯에 없는 라이브러리를 유틸 파일에서 import 하고있어서 오류가 남. util 내 메소드를 세분화하여 분리, 커스텀 가능한 라이브러리는 삭제했습니다.
  - 토스트메시지 라이브러리 커스텀
      - animation 사용
