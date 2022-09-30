# 이 프로젝트에 대해
<hr>

이 프로젝트는, Window 호스트에 nvm 또는 Node.js 런타임을 설치하지 않고
create-react-app 을 통한 CRA 템플릿 생성을 하고 싶다는 이상한 동기로부터 만들어졌습니다.

원리는 간단합니다. 컨테이너 안에서 `npx create-react-app` 을 실행하고 
그 결과물을 여러분이 .env 파일에 설정한 호스트 OS 상의 경로로 떨어뜨려 드립니다.

아울러 `CRA` 프로젝트 소스 외에도 추가로, 
`CRA` 프로젝트를 구동할 수 있는 개발환경 도커 파일 (`DockerfileDev`) 도 생성됩니다. 

# 실행 환경
<hr>

- `Windows`
- `WSL2`
- `Docker-Desktop`

# 무엇을 만드는가
<hr>

## 1. 특장점
### (1) docker-compose.yml 및 DockerfileDev 가 제공됩니다. 
   > 제공된 `docker-compose.yml` 설정 그대로 실행하면 
   > - HMR 개발 서버 
   > - 단위 테스트 서버  
   > 
   > 두 개의 컨테이너가 기동됩니다.
### (2) 개발서버는 HMR(Hot Module Replacement) 를 지원합니다.
   > `CMD react-scripts start` 커맨드를 컨테이너 내부에서 실행하면  
   > 호스트 측으로 포워딩 된 포트로 브라우저에서 접속했을 때 `ws` 통신이 되지 않아  
   > `HMR` 이 되지 않는 문제가 있습니다.  
   > 
   > `docker-compose.yml` + `DockerfileDev` 파일에 작성한 컨테이너는  
   > 이와 같은 문제가 해결된 컨테이너 환경을 제공합니다. 

   > **Warning**  어떻게 해결했는가?  
   > 이 문제를 해결하기 위해 컨테이너 환경 변수로 `WATCHPACK_POLLING` 설정이 주입되어 있습니다.   
   > 이는 `ws` 통신 불가 문제에 대한 실질적인 솔루션이 아닙니다.  
   > 대신 `Polling` 방식을 사용한 문제에 대한 우회적인 해결책입니다.  
   > 실제 `ws` 통신을 가능하게 하기 위해서는,   
   > `ws` 프로토콜을 컨테이너 측에서 받아들일 수 있도록 `NGINX` 컨테이너를 추가로 띄워야 합니다.

# 실행 방법
<hr>

## 1. 설정 파일 수정 

(1) .env \
파일에 기록된 OUTPUT_DIRECTORY 값을 당신이 원하는 값으로 설정하세요. 
호스트 OS 의 해당 위치에 저장됩니다.
```.dotenv
OUTPUT_DIRECTORY=./myCRA
```

## 2. Run
실행 환경에 따라 아래와 같이 다른 파일을 실행해야 합니다.

### 1. WSL
```shell
./createReactAppViaDocker.sh
```
### 2. CMD
```
wsl ./createReactAppViaDocker.sh
```
### 3. PowerShell
```
wsl ./createReactAppViaDocker.sh
```

# 개발에 사용하기
<hr>

`OUTPUT_DIRECTORY` 에 `CRA` 프로젝트 템플릿이 생성되어 있을 것입니다.  
아울러 해당 디렉토리 내에 함께 제공 드리는 `docker-compose.yml` 을 기동하시면
- ReactDevServer : React 개발 서버
- ReactTestExecutor : React 테스트 서버  

각각의 컨테이너 내부로 접근하여 React 개발에 활용해 주시면 됩니다. 
