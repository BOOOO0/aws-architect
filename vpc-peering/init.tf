provider "aws" {
  alias = "seoul"
  region = "ap-northeast-2"
}

# 복수의 리전을 사용하기 위해 복수의 provider를 선언
# 기본 리전 외의 다른 provider에는 alias를 주고 리소스에 명시
provider "aws" {
  alias = "tokyo"
  region = "ap-northeast-1"
}