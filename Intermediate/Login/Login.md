# Login

FastCampus 의 [30개 프로젝트로 배우는 iOS 앱 개발 with Swift 초격차 패키지 Online](https://fastcampus.co.kr/dev_online_iosappfinal) 강의를 보고 실습, 추가 구현한 내용입니다. 

<br>

---

<br>

> Apple로 로그인하는 경우는 Apple Developer에 연간 구독을 해야되기 때문에 후에 실습하기로 하고 강의 시청만 했습니다. 코드는 따로 정리해놓았습니다.

<Br>

 
이메일/비밀번호, 구글 아이디, 애플 아이디로 로그인 기능을 구현한 실습 앱이다.

- 이메일/비밀번호: 이메일/비밀번호를 입력할 수 있는 화면이 나타나고 입력한 값에 따라 로그인  

<br>

<p align= center><img src="https://user-images.githubusercontent.com/63290629/180634158-37a76f84-6a0a-4ef3-98d9-fab6766b43db.png" width="30%" height="40%"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="https://user-images.githubusercontent.com/63290629/180634160-223969e5-8336-4a0a-92b7-33f83624a1b7.png" width="30%" height="40%"/></p>

<Br>

- 구글: 구글 아이디 로그인 웹뷰로 이동해서 로그인  

<br>

<p align= center><img src="https://user-images.githubusercontent.com/63290629/180633900-33fa55d1-f3b2-4c7e-9e6b-f1ed820159a6.png" width="30%" height="40%"/>&nbsp;&nbsp;&nbsp;&nbsp;<img src="https://user-images.githubusercontent.com/63290629/180633902-f225aabd-d063-4ce0-8665-6771c06c83ce.png" width="30%" height="40%"/>&nbsp;&nbsp;&nbsp;&nbsp;<img src="https://user-images.githubusercontent.com/63290629/180633906-d86728ef-2bde-4a3b-95e4-1c5b0928eab1.png" width="30%" height="40%"/></p>


<Br>

- 애플: 애플 아이디 로그인 웹뷰로 이동해서 로그인 (시뮬레이터로 확인 불가 - 지원 X)

<br>
<br>


**ViewController 구성**

- ViewController: 첫 화면으로, 원하는 로그인 방식을 선택할 수 있다.

- EmailViewController: 이메일/비밀번호를 입력해서 로그인할 수 있는 화면

- MainViewController: 로그인이 성공하면 나타나는 화면으로 환영한다는 라벨이 출력된다.

<br>

<img width="970" alt="Screen Shot 2022-07-24 at 2 36 43 PM" src="https://user-images.githubusercontent.com/63290629/180633889-cb7754b7-1506-4ebe-b7fe-ead4f59fdf6b.png">

<br>
<br>

---

<br>

**추가적인 기능**

- 비밀번호 변경: 이메일로 로그인했을 경우에만 사용가능하고, 이 버튼을 눌렀을 경우 해당 이메일로 메일을 전송해서 비밀번호를 변경할 수 있도록 한다.

- 닉네임 변경: Apple로 로그인할 경우 사용자 보호로 인해 이메일 정보를 가져올 수 없으므로 닉네임을 출력할 수 있도록 했다.