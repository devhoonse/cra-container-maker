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
   > 
   > 그러나 이는 호스트와 컨테이너 간 `ws` 통신 불가 문제에 대한 실질적인 솔루션이 아닙니다.  
   > 다만 `Polling` 방식을 사용한 문제에 대한 우회적인 해결책에 지나지 않습니다.
   > 
   > 실제 호스트와 컨테이너 간 `ws` 통신을 가능하게 하기 위해서는,   
   > `ws` 프로토콜을 컨테이너 측에서 받아들일 수 있도록 `NGINX` 컨테이너를 추가로 띄우거나,  
   > 혹은 `NGINX` 없이 하려면 아래에 기술할 `template.json` 파일을 수정해야 합니다.  
   > 이에 관해서는 아래 링크의 `WDS_SOCKET_*` 변수 항목을 참고해 주세요.  
   > > https://create-react-app.dev/docs/advanced-configuration

# 실행 방법
<hr>

## 1. 설정 파일 수정 

### (1) .env
파일에 기록된 OUTPUT_DIRECTORY 값을 당신이 원하는 값으로 설정하세요. 
호스트 OS 의 해당 위치에 저장됩니다.
```.dotenv
OUTPUT_DIRECTORY=./myCRA
```

### (2) template (`./cra-template-custom`)
생성된 `CRA` 프로젝트 템플릿에 적용할 설정을 지정합니다.  
1. 이 템플릿은 `create-react-app@4.0.3` 의 기본 템플릿을 커스텀한 것입니다.  
   원본 템플릿에 대해서는 아래 문서를 참고해주세요.
   > https://github.com/facebook/create-react-app/tree/v4.0.3/packages/cra-template-typescript
2. 템플릿의 자세한 커스텀 방법에 대해서는 아래 문서를 참고해주세요.  
   > https://create-react-app.dev/docs/custom-templates

> **Note**  
> `cra-template-custom/template.json` 의 dependencies 항목에 react 패키지의 버전을 `17.0.2` 로 지정하였습니다.  
> 
> 이는 최근 `create-react-app>=5.0.0` 실행 시 별도로 지정된 템플릿이 없을 경우  
> React 버전이 기본적으로 `^18.*.*` 로 설치되는데   
> 아직은 다른 라이브러리와 병용이 힘들기 때문에 이를 피하기 위함입니다.
> 
> 대표적으로, 아직 `Material-UI` 패키지가 React 18 환경과 제대로 호환되지 못합니다.
> 
> 현재로서는 `^18.*.*` 환경에서 `Material-UI` 추가 시,  
> `ERESOLVE` 문제로 `npm install` 시 `--legacy-peer-deps` 옵션을 강제할 수밖에 없는데,  
> 향후 `^18.*.*` 버전과의 의존성 문제가 해결되고 `--legacy-peerd-deps` 가 필요 없어지면   
> dependencies 항목에 react 패키지 버전 제한을 제거할 예정입니다.
> 
```json
{
   "package": {
      "dependencies": {
         "@testing-library/jest-dom": "^5.11.4",
         "@testing-library/react": "^11.1.0",
         "@testing-library/user-event": "^12.1.10",
         "@types/node": "^12.0.0",
         "@types/react": "^17.0.0",
         "@types/react-dom": "^17.0.0",
         "@types/jest": "^26.0.15",
         "typescript": "^4.1.2",
         "web-vitals": "^1.0.1"
      },
      "eslintConfig": {
         "extends": ["react-app", "react-app/jest"]
      }
   }
}

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

## 1. WebStorm
> https://www.jetbrains.com/help/webstorm/node-with-docker.html
