# smartLamp

## schema
- User (사용자 스키마)
    |컬럼명|설명|
    |---|---|
    |userId|사용자 고유 아이디|
    |userPw|사용자 비밀번호|
    |userName|사용자 이름|
    |unitList|등록 디바이스 리스트|
    |groupList|디바이스 그룹 리스트|

- Unit (디바이스 유닛 스키마)
    |컬럼명|설명|
    |---|---|
    |unitCode|디바이스 고유 코드|
    |unitName|디바이스 이름|
    |distance|탐지 거리|
    |time|점등 시간|
    |groupCode|소속 그룹 코드|

- Group (디바이스 그룹 스키마)
    |컬럼명|설명|
    |---|---|
    |groupCode|그룹 고유 코드|
    |groupName|그룹 이름|
    |unitList|소속 디바이스 리스트|