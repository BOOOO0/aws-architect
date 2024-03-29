# 오브젝트 스토리지 보안

- 오브젝트 스토리지 기반 링크의 유효기간의 설정이 가능하다.

## Azure Blob Storage

- 스토리지 계정의 생성이 필요하다.

- 스토리지 계정 하에 컨테이너라는 이름으로 S3버킷과 같은 오브젝트 스토리지가 있다.

- 컨테이너는 기본값이 프라이빗이며 업로드된 오브젝트에 대해 SAS 생성(공유 액세스 서명 생성)을 통해 각 객체에 만료기한을 주고 퍼블릭 액세스를 허용할 수 있다.

- 이때는 source IP도 설정할 수 있다.

- **_일단 당연하게도 S3랑 생성방법이나 옵션이 비슷한데 지금 수업의 중점이 오브젝트 스토리지의 접근에 대한 퍼블릭, 프라이빗 엑세스, 키 기반 암호화 등의 내용이므로 오브젝트 스토리지의 기본적인 보안 사항에 대해 따로 정리가 나을 것 같다._**

## AWS S3

# IPsec VPN

- AWS <-> Openstack

- 하이브리드 클라우드 구축을 위해 AWS S2S를 사용해 사설망 내에서 안전하게 통신하도록 한다.

- VPN은 패킷의 암호화가 반영되지 않지만 IPsec VPN은 헤더에 AH(Authentication Header), ESP(Encapsulating Security Payload)를 추가하여 암호화된 안전한 VPN에서의 통신을 가능하게 한다.

- ipsec vpn을 구현할때 항상 left는 우리가 가진 데이터 센터이고 right는 원격으로 접근할 퍼블릭 클라우드가 될 수 있다.

- AWS S2S를 사용하는데 On-prem쪽 게이트웨이와 AWS VPC쪽 게이트웨이를 생성하고 서로 연결하는 것이다.

- VPC 대시보드에서 고객 게이트웨이를 먼저 생성한다.

- 고객 게이트웨이는 LEFT인 우리 데이터 센터의 라우터의 퍼블릭 IP를 명시해서 생성한다.

- 그다음 가상 프라이빗 게이트웨이를 생성한다. 이 게이트웨이가 RIGHT가 된다.

- 생성한 다음 작업 -> vpc연결을 통해 게이트웨이를 VPC에 연결한다.

- S2S VPN 연결 생성을 통해 두 게이트웨이를 연결한다.

- 두 게이트웨이를 명시하고 정적 라우팅을 선택한 다음 고정 IP 접두사 항목에 로컬 데이터 센터 측의 서브넷을 명시한다.

- 선택사항은 일단 default로 둔다. 터널 옵션 선택사항은 생성할 vpn 터널에서 사용할 키를 직접 생성했다면 명시할 수 있다.

- 연결이 생성되면 구성 다운로드를 한다. 이때 공급 업체(실제 vpn 장비 벤더사)는 Openswan을 선택한다. libreswan을 사용할 것이기 때문이다.

- IKE 버전은 Openswan은 v1만 지원하므로 v1을 선택한다.

## libreswan

- VPN 오픈소스로 키 교환을 통해 데이터를 안전하게 주고 받는다. 양쪽의 보안 게이트웨이가 서로를 키로 인증하는 방식이다.

- 오픈스택이 설치된 VM에 libreswan을 설치한다.

- libreswan의 서비스 명은 ipsec이다. ipsec의 설정을 해주고 S2S에서 구성 다운로드를 통해 받은 내용을 `/etc/ipsec.d/aws.conf`에 터널 구성 내용 모두를 `/etc/ipsec.d/aws.secret`에 키 내용 모두를 명시하고 ipsec을 재시작한다.

- AWS S2S 항목에서 터널 세부 정보의 각 터널의 상태가 Up이면 연결이 된 것이다.

- 연결이 되었다면 통신할 AWS VPC 서브넷의 라우팅 테이블에 데이터 센터 쪽의 서브넷 대역과 생성한 가상 프라이빗 게이트웨이를 선택해서 라우팅 규칙을 추가한다.

- 오픈 스택의 라우터에도 정적 경로로 VPC의 대역을 입력하고 next hop은 VPN이 연결된 오픈스택 VM의 IP를 입력한다.

- 그래도 되지 않는 경우 오픈 스택 VM에서 iptable 서비스를 재시작하고 `iptables -F` 명령어를 사용하면 오픈스택의 인스턴스와 AWS의 인스턴스가 서로 통신이 가능한 것을 확인할 수 있다.

- 연결이 된 상태라면 오픈스택에서 인스턴스에 RDS DB접속과 연결이 가능하고 EFS를 마운트할 수 있다.

# Web 방화벽

- AWS WAF로 sql 인젝션을 막을 수 있다. 직접 시도해본 다음 막고 WAF 대시보드에서 막힌 것을 확인할 수도 있다.

- wordpress로 실습했는데 SSL 플러그인 설치하고 HTTPS로 접속하면 자체적으로도 차단이 된다.

# NAT 인스턴스

- 소스/대상 확인 옵션은 NAT 인스턴스는 트래픽을 보내줘야 하지만 경유하는 트래픽을 차단하게 한다. 그래서 중지하는 것
