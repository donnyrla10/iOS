//
//  ViewController.swift
//  GENERATESAYINGS
//
//  Created by 김영선 on 2022/01/03.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    var prev = 0 //이전 random 값 저장 프로퍼티
    
    //명언을 담은 배열 생성
    let sayings = [
        Saying(content: "“꿈을 이루고자 하는 용기만 있다면 모든 꿈을 이룰 수 있다.”", name: "월트 디즈니"),
        Saying(content: "“비록 해가 진다고 해도, 나에게는 전기불이 있다”", name: "로커 커트 코베인"),
        Saying(content: "“조금도 도전하지 않으려고 하는 것이 인생에서 가장 위험한 일이다”", name: "오프라 윈프리"),
        Saying(content: "“새로운 일에 도전하다 보면 가끔 실수를 저지를 수 있다. 자신의 실수를 빨리 인정하고 다른 시도에 집중하는 것이 최선이다.”", name: "스티브 잡스"),
        Saying(content: "“행동은 모든 성공의 가장 기초적인 핵심이다.”", name: "파블로 피카소"),
        Saying(content: "“용기란 죽을만큼 두려워도 무언가 해보는 것이다.”", name: "존 웨인"),
        Saying(content: "“무언가를 위해 죽을 각오가 없다면, 인생을 살게 해줄 무언가도 가질 수 없을 것이다.”", name: "체게바라"),
        Saying(content: "“승리는 가장 끈기 있는 사람에게 돌아간다.”", name: "보나바르트 나폴레옹"),
        Saying(content: "“노력하는 사람에게 불가능이란 없다.”", name: "알렉산더 대왕"),
        Saying(content: "“인생에서 실패한 사람의 대부분은 성공이 눈앞에 왔는데도 모르고 포기한 사람들이다.”", name: "토마스 에디슨"),
        Saying(content: "“오늘 나무 그늘에서 쉴 수 있는 이유는 예전에 나무를 심었기 때문이다.”", name: "워렌 버핏"),
        Saying(content: "“너는 머뭇거릴 수 있지만, 시간은 그렇지 않다.”", name: "벤자민 프랭클린"),
        Saying(content: "“가장 용감한 행동은 자신에 대해 생각하고 그것을 큰 소리로 외치는 일이다.”", name: "코코 샤넬"),
        Saying(content: "“네가 누구인지, 무엇인지 말해 줄 사람은 필요 없다. 너는 그냥 너 자신일 뿐이다.”", name: "존 레논"),
        Saying(content: "“성공의 비결은 모르겠다. 하지만 실패의 비결은 알고 있다. 모든 사람들을 기쁘게 하려는 것이다.”", name: "빌 코스비"),
        Saying(content: "“나약한 태도는 그 사람 자체도 나약하게 만든다.”", name: "알베트 아인슈타인"),
        Saying(content: "“태도는 사소한 것이지만 그것이 만드는 차이는 엄청나다.”", name: "윈스턴 처칠"),
        Saying(content: "“영원히 살 것처럼 꿈꾸고 오늘 죽을 것처럼 살아라”", name: "제임스 딘"),
        Saying(content: "“‘지금이 최악이야’라고 말할 수 있는 한 지금이 최악은 아니다.”", name: "윌리엄 셰익스피어"),
        Saying(content: "“옛 친구들은 사라지고 새로운 친구들이 생겨난다. 시간도 마찬가지다. 과거는 흘러가고 미래가 나타난다. 중요한 것은 의미를 만드는 것이다. 의미 있는 친구를 만들고 의미있는 시간을 만들어라.”", name: "달라이 라마"),
        Saying(content: "죽음을 두려워하는 나머지 삶을 시작조차 못하는 사람이 많다.", name: "벤다이크")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.generate()
    }
    
    
    @IBAction func tabGenerateButton(_ sender: UIButton) {
        self.generate()
    }
    
    func generate(){
        var r1 = Int(arc4random_uniform(21))      //임의 값 구하기
        
        //1. 중복값이 나오면 다음 값 출력
        //let random = (r1 == prev) ? prev+1 : r1   //전 임의값과 같다면(중복) + 1
        //prev = random
        //let saying = sayings[random]
        
        //================================================
        
        //2. 중복값이 나오면 다른 임의의 값 계산해서 출력
        while(r1 == prev){
            r1 = Int(arc4random_uniform(21))
        } //r1 != prev -> while break
        prev = r1
        let saying = sayings[r1]
        self.contentLabel.text = saying.content
        self.nameLabel.text = saying.name
    }
}

