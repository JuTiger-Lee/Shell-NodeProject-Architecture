# Shell-NodeProject-Architecture

## 설명

- express 같은 경우에는 unopinionated Framework 이기 때문에 폴더구조가 사람마다 제 각각이며 또는 사용하는 모듈도 많이 다르다.
- 나 또한 마찬가지이고 똑같은 폴더구조를 새로운 프로젝트마다 만드는게 귀찮아 자동으로 만들어주는 Sheel Script 를 만들었다.

### Process

- 기본적이 프로세스는 이러하다.

1. 프로젝트를 만들 폴더 경로 설정
2. git이 필요한 경우 git 설정
3. api 문서가 필요한 경우 swagger 설정
4. 프로젝트 필요한 기본 모듈 설치
5. 기본적으로 들어가는 코드 입력
6. git이 설정되었다면 git repo에 push 후 종료

#### ts_express_init_prj

- typescript + express를 이용한 프로젝트를 할시에 사용되는 Sheel Script 이다.
