<h1 style='background-color: rgba(55, 55, 55, 0.4); text-align: center'>API 설계(명세)서 </h1>

해당 API 명세서는 '실버케어테크 인지치료 서비스 - Memories'의 REST API를 명세하고 있습니다.  

- Domain : http://127.0.0.1:4000    

***
  
<h2 style='background-color: rgba(55, 55, 55, 0.2); text-align: center'>Auth 모듈</h2>

Memories 서비스의 인증 및 인가와 관련된 REST API 모듈입니다.  
로그인, 회원가입, 아이디 중복 확인 등의 API가 포함되어 있습니다.  
Auth 모듈은 인증 없이 요청할 수 있는 모듈입니다.    
  
- url : /api/v1/auth  

***

#### - 로그인  
  
##### 설명

클라이언트는 사용자 아이디와 평문의 비밀번호를 포함하여 요청하고 아이디와 비밀번호가 일치한다면 인증에 사용될 token과 해당 token의 만료 기간을 응답 데이터로 전달받습니다. 만약 아이디 혹은 비밀번호가 하나라도 일치하지 않으면 로그인 불일치에 해당하는 응답을 받습니다. 서버 에러, 데이터베이스 에러, 유효성 검사 실패 에러가 발생할 수 있습니다.    

- method : **POST**  
- URL : **/sign-in**  

##### Request

###### Request Body

| name | type | description | required |
|---|:---:|:---:|:---:|
| userId | String | 사용자의 아이디 | O |
| userPassword | String | 사용자의 비밀번호 | O |

###### Example

```bash
curl -v -X POST "http://127.0.0.1:4000/api/v1/auth/sign-in" \
 -d "userId=qwer1234" \
 -d "userPassword=Qwer1234!"
```

##### Response

###### Response Body

| name | type | description | required |
|---|:---:|:---:|:---:|
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| accessToken | String | Bearer 인증 방식에 사용될 JWT | O |
| expiration | Integer | accessToken의 만료 기간 (초단위) | O |

###### Example

**응답 성공**
```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success.",
  "accessToken": "${ACCESS_TOKEN}",
  "expiration": 32400
}
```

**응답 : 실패 (데이터 유효성 검사 실패)**
```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

**응답 : 실패 (로그인 실패)**
```bash
HTTP/1.1 401 Unauthorized

{
  "code": "SF",
  "message": "Sign in Fail."
}
```

**응답 : 실패 (데이터베이스 에러)**
```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

***

#### - 아이디 중복 확인  
  
##### 설명

클라이언트는 사용할 아이디를 포함하여 요청하고 중복되지 않는 아이디라면 성공 응답을 받습니다. 만약 사용중인 아이디라면 아이디 중복에 해당하는 응답을 받습니다. 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.  

- method : **POST**  
- URL : **/id-check**  

##### Request

###### Request Body

| name | type | description | required |
|---|:---:|:---:|:---:|
| userId | String | 중복확인을 수행할 사용자 아이디 | O |

###### Example

```bash
curl -v -X POST "http://127.0.0.1:4000/api/v1/auth/id-check" \
 -d "userId=qwer1234"
```

##### Response

###### Response Body

| name | type | description | required |
|---|:---:|:---:|:---:|
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

###### Example

**응답 성공**
```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
}
```

**응답 : 실패 (데이터 유효성 검사 실패)**
```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

**응답 : 실패 (중복된 아이디)**
```bash
HTTP/1.1 400 Bad Request

{
  "code": "EU",
  "message": "Exist User."
}
```

**응답 : 실패 (데이터베이스 에러)**
```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```

***

#### - 회원가입  
  
##### 설명

클라이언트는 사용자 이름, 사용자 아이디, 주소, 상세주소, 가입경로를 포함하여 요청하고 회원가입이 성공적으로 이루어지면 성공에 해당하는 응답을 받습니다. 만약 존재한느 아이디일 경우 중복된 아이디에 대한 응답을 받습니다. 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.  

- method : **POST**  
- URL : **/sign-up**  

##### Request

###### Request Body

| name | type | description | required |
|---|:---:|:---:|:---:|
| userId | String | 사용자 아이디 (영문과 숫자로만 이루어진 6자 이상 20자 이하 문자열) | O |
| userPassword | String | 사용자 비밀번호 (영문 숫자 조합으로 이루어진 8자 이상 13자 이하 문자열) | O |
| name | String | 사용자 이름 (한글로만 이루어진 2자 이상 5자 이하 문자열) | O |
| address | String | 사용자 주소 | O |
| detailAddress | String | 사용자 상세 주소 | X |
| joinType | String | 가입 경로 (NORMAL: 일반, KAKAO: 카카오, NAVER: 네이버) | O |

###### Example

```bash
curl -v -X POST "http://127.0.0.1:4000/api/v1/auth/sign-up" \
 -d "userId=qwer1234" \
 -d "userPassword=qwer1234" \
 -d "name=이성계" \
 -d "address=부산광역시 부산진구 ..." \
 -d "detailAddress=402호" \
 -d "joinType=NORMAL"
```

##### Response

###### Response Body

| name | type | description | required |
|---|:---:|:---:|:---:|
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |

###### Example

**응답 성공**
```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success."
}
```

**응답 : 실패 (데이터 유효성 검사 실패)**
```bash
HTTP/1.1 400 Bad Request

{
  "code": "VF",
  "message": "Validation Fail."
}
```

**응답 : 실패 (중복된 아이디)**
```bash
HTTP/1.1 400 Bad Request

{
  "code": "EU",
  "message": "Exist User."
}
```

**응답 : 실패 (데이터베이스 에러)**
```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database Error."
}
```