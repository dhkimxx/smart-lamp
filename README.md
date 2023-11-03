# Smart Lamp
한국공학대학교 종합설계 졸업작품

## 프로젝트 소개
### 개발배경  
* 노인들에게 야뇨증 등의 이유로 어두운 밤에 화장실을 가는 도중 물건을 잘못 밟거나 걸려 넘어져 낙상사고가 다수 발생한다.  

* 노인은 작은 낙상사고로도 고관절이나 척추를 다칠 가능성이 크며 중상 이상에 이를 수 있으므로 각별한 주의가 필요하다.  

* 밤에 조명을 유지하는 것을 권유하지만 눈 부심때문에 조명을 켜고 잠자리에 드는 것을 선호하지 않는 경우가 있으며, 이동 시 마다 조명을 켜고 끄는 것이 번거로워 조명이 있음에도 잘 활용하지 않는 경우가 있다.   

### 개발목표 및 내용  
* 설정된 감지거리 이내에서 상시 사용자의 움직임을 감지하여 설정된 점등시간과 밝기로 동작  

* 사용자의 모바일 어플리케이션 상에서 다수의 디바이스를 등록 후 조작 및 개인화 설정 가능  

* 어플리케이션 회원등록을 통해 소유한 디바이스의 고유코드를 계정에 등록 후 서버를 통해 디바이스 정보를 등록, 수정, 조회, 삭제 가능  

### 기대효과 및 시장성

* 어두운 밤길로 인한 노인들의 낙상 사고를 방지할 수 있다. 이를 통해 노인들은 더 안전한 환경에서 생활할 수 있게 되며, 부상과 다발 상황의 위험을 줄일 수 있다.  

* 노인 인구가 전 세계적으로 증가하는 추세에 따라 이와 같은노인들을 위한 안전사고 예방 솔루션의 시장 수요가 증가할 것으로 예상된다.  


## 아키텍쳐

### 구성
* Backend : [Spring REST API Server](https://github.com/dhkimxx/smartLampServer)  
* Frontend : [Flutter  Application](./client/)
* Device : [Wemos D1 mini(Arduino)](./unit/smartLampUnit.ino)

### 다이어그램

![](https://github.com/dhkimxx/smartLamp/assets/79616878/95d699e5-c1e7-457a-8eb5-ffe34be5769e)

## 개발 환경

| Target        | Version     |
|---------------|-------------|
| Ubuntu(Cloud) | 20.04.6 LTS |
| MySQL(Cloud)  | 8.0.35      |
| Java          | openjdk 11  |
| Spring boot   | 2.7.10      |
| Dart          | 2.19.5      |
| Flutter       | 3.7.8       |
| mosquitto     | 1.6.9       |


## 개발 도구

![vscode](https://img.shields.io/badge/vscode-007ACC?style=for-the-badge&logo=visualstudiocode&logoColor=white)
![xcode](https://img.shields.io/badge/xcode-147EFB?style=for-the-badge&logo=xcode&logoColor=white)
![intellijidea](https://img.shields.io/badge/intellijidea-000000?style=for-the-badge&logo=intellijidea&logoColor=white)
![git](https://img.shields.io/badge/git-F05032?style=for-the-badge&logo=git&logoColor=white)
![github](https://img.shields.io/badge/github-181717?style=for-the-badge&logo=github&logoColor=white)

## 사용 기술

![ubuntu](https://img.shields.io/badge/ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![arduino](https://img.shields.io/badge/arduino-00979D?style=for-the-badge&logo=arduino&logoColor=white)
![springboot](https://img.shields.io/badge/springboot-6DB33F?style=for-the-badge&logo=springboot&logoColor=white)
![mqtt](https://img.shields.io/badge/mqtt-660066?style=for-the-badge&logo=mqtt&logoColor=white)
![mysql](https://img.shields.io/badge/mysql-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![flutter](https://img.shields.io/badge/flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)