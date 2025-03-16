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

***

#### - SNS 회원가입 및 로그인  
  
##### 설명

클라이언트는 가입경로를 포함하여 요청하고 성공시 가입 이력이 있는 사용자라면 메인 페이지로 리다이렉트를 받고 만약 가입 이력이 없는 사용자일 경우 회원가입 페이지로 리다이렉트 됩니다. 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.    

- method : **GET**  
- URL : **sns/{registrationName}**  

##### Request

###### Path Variable

| name | type | description | required |
|---|:---:|:---:|:---:|
| registrationName | String | SNS 종류 (KAKAO, NAVER) | O |

###### Example

```bash
curl -v GET http://127.0.0.1:4000/api/v1/auth/sns/kakao
```

##### Response

###### Example

**응답 성공 (회원가입이 된 상태 일 때)**
```bash
HTTP/1.1 302 Found
Set-Cookie: accessToken=${accessToken}; Path=/;
Location: http://127.0.0.1:3000/main
```

**응답 성공 (회원가입이 안된 상태 일 때)**
```bash
HTTP/1.1 302 Found
Set-Cookie: accessToken=${accessToken}; Path=/;
Location: http://127.0.0.1:3000/auth/${registration}
```

**응답 : 실패 (OAuth 실패)**
```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth Fail."
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
  
<h2 style='background-color: rgba(55, 55, 55, 0.2); text-align: center'>User 모듈</h2>

Memories 서비스의 사용자 정보와 관련된 REST API 모듈입니다.  
로그인 사용자 정보 확인, 사용자 정보 수정 등의 API가 포함되어 있습니다.  
User 모듈은 모두 인증 후 요청할 수 있는 모듈입니다.    
  
- url : /api/v1/user  

***

#### - 로그인 사용자 정보 확인  
  
##### 설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하여 요청하고 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 네트워크 에러, 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.     

- method : **GET**  
- URL : **/sign-in**  

##### Request

###### Header

| name | description | required |
|---|:---:|:---:|
| Authorization | Bearer 토큰 인증 헤더 | O |

###### Example

```bash
curl -X GET "http://localhost:4000/api/v1/user/sign-in" \
 -h "Authorization=Bearer XXXX"
```

##### Response

###### Response Body

| name | type | description | required |
|---|:---:|:---:|:---:|
| code | String | 응답 결과 코드 | O |
| message | String | 응답 결과 코드에 대한 설명 | O |
| userId | String | 사용자 아이디 | O |
| name | String | 사용자 이름 | O |
| profileImage | String | 사용자 프로필 이미지 | X |
| address | String | 사용자 주소 | O |
| detailAddress | String | 사용자 주소 | O |
| gender | String | 사용자 성별 | X |
| age | Integer | 사용자 나이 | X |

###### Example

**응답 성공**
```bash
HTTP/1.1 200 OK

{
  "code": "SU",
  "message": "Success.",
  "userId": "qwer1234",
  "name": "이성계",
  "profileImage": "http://~",
  "address": "부산광역시 부산진구",
  "detailAddress": "402호",
  "gender": "남",
  "age": 62
}
```

**응답 : 실패 (인증 실패)**
```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
}
```

**응답 : 실패 (데이터베이스 에러)**
```bash
HTTP/1.1 500 Internal Server Error

{
  "code": "DBE",
  "message": "Database error."
}
```

***

#### - 사용자 정보 수정  
  
##### 설명

클라이언트는 요청 헤더에 Bearer 인증 토큰을 포함하여 사용자 이름을 입력하여 요청하고 회원가입이 성공적으로 이루어지면 성공에 대한 응답을 받습니다. 네트워크 에러, 서버 에러, 데이터베이스 에러가 발생할 수 있습니다.  

- method : **PATCH**  
- URL : **/**  

##### Request

###### Header

| name | description | required |
|---|:---:|:---:|
| Authorization | Bearer 토큰 인증 헤더 | O |

###### Request Body

| name | type | description | required |
|---|:---:|:---:|:---:|
| name | String | 사용자 이름 | O |
| profileImage | String | 사용자 프로필 이미지 | X |
| address | String | 사용자 주소 | O |
| detailAddress | String | 사용자 주소 | O |
| gender | String | 사용자 성별 | X |
| age | Integer | 사용자 나이 | X |

###### Example

```bash
curl -v -X PATCH "http://localhost:4000/api/v1/user" \
 -h "Authorization=Bearer XXXX" \
 -d "name=홍길동" \
 -d "profileImage=https://~~" \
 -d "address=부산광역시 중구" \
 -d "detailAddress=303호호"
 -d "gender=남" \
 -d "age=63"
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

**응답 : 실패 (인증 실패)**
```bash
HTTP/1.1 401 Unauthorized

{
  "code": "AF",
  "message": "Auth fail."
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
