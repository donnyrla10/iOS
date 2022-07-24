# 계산기 앱 🧮

<br>

FastCampus 의 [30개 프로젝트로 배우는 iOS 앱 개발 with Swift 초격차 패키지 Online](https://fastcampus.co.kr/dev_online_iosappfinal) 강의를 보고 실습, 추가 구현한 내용입니다. 

<br>

---

<br>

<p align= center><img src=https://user-images.githubusercontent.com/63290629/149080592-a043d132-bee3-4d51-b4d1-ff8edfa1806f.png width="50%" height="50%"/> &nbsp;&nbsp;&nbsp;&nbsp; <img src=https://user-images.githubusercontent.com/63290629/149080193-c9f0671f-4784-449a-9e28-8e5d4e948235.png width="40%" height="40%"/></p>

<br>

## **💙 구현**

<br>

- `@IBDesignable`, `@IBInspectable`을 이용해 동그란 버튼을 만들 수 있다.   
  → 🚨 위의 이미지와 같이 완전히 둥근 모양은 아니고 살짝 각져있다. *해결하기*  
  → (⏰ 2022.01.12) 버튼이 정사각형이 아니었다. (87, 88.5) 이런 식었다는 것을 발견하고 수정하기 위해 찾아보다가 vertical stackview와 horizontal stackview의 spacing이 다른 것을 확인하고 동일하게 바꿔주었더니 버튼이 가로 세로 길이가 동일한 정사각형이 되었다. 그러나 여전히 미묘하게 각져있다. *해결하기😱*

- `@IBDesignable` 오류로 스토리보드 상으로 RoundButton이 보이지 않을 때도 있다. 

- `StackView`를 사용해 버튼들을 묶어주었다. [AutoLayout]

- 최대 9자리까지만 나타나도록 하고, display UILabel 길이보다 더 길면 Shrink 되도록 Inspector에서 변경해줬다. (Autoshrink minimum size = 9) *(2022.05.15 수정)*

- MVC 디자인 패턴으로 변경 / Model(CalculatorBrain.swift 추가) *(2022.05.15 수정)*


<br>

## **💙 MVC(Model - View - Controller) 디자인 패턴으로 변경**
  

<br>

**Model = CalculatorBrain.swift** , 계산기의 계산하는 코드 구현

**View = Storyboard** 에 UI 객체들로 구현

**Controller = ViewController.swift** , UI에 따른 실행을 코드 구현. (Model-View 연결)

<br>

## **💙 기능**

<br>

- 숫자판을 누르면 원하는 값을 입력할 수 있다.
- `+, -, *, /` 를 누르면 해당 연산자로 값을 계산 할 수 있다.
- `AC`를 누르면 값을 초기화한다.
- `+/-` 를 누르면 부호 변환
- `%` 를 누르면 퍼센트 계산

<br>

## **💙 강의 외의 추가적인 구현**

<br>

- `+/-` 기능 구현 (부호 변환)
- `%` 기능 구현 (퍼센트 연산)
- MVC 디자인 패턴으로 변경 (+ 리팩토링)


<br>