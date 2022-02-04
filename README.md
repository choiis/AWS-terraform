# AWS Terraform

## Infrastructure as Code

### 실행

* aws-provider.tf 파일을 열어 AWS계정의 access_key와 secret_key를 입력합니다
* instance.tf 파일의 key_name에는 AWS에서 사용하는 ssh key 이름을 입력해 주세요
* init 명령어로 terraform 준비합니다

```bash
terraform init
```

* apply 명령어로 코드로 작성한 AWS 인프라와 인스턴스를 만들어 줍니다

```bash
terraform apply
```

### 종료

* terraform으로 만든 AWS 자원들을 한 번에 삭제할 수 있습니다

```bash
terraform destroy
```