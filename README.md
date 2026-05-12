README
## Coding Style

- Text files are encoded in UTF-8
- Line endings are LF
- Formatting is enforced by `.editorconfig` and `.gitattributes`

  ---
## aws-study.yaml　SNS Email Notificationについて

CloudWatch Alarm の通知先として SNS Email 通知を利用する場合、通知先メールアドレス宛に AWS から確認メールが送信されます。

* 差出人例: [no-reply@sns.amazonaws.com](mailto:no-reply@sns.amazonaws.com)
* 件名例: AWS Notification - Subscription Confirmation

メール本文内の「Confirm subscription」リンクをクリックし、サブスクリプション承認を完了してください。

承認を実施しない場合、CloudWatch Alarm の通知メールは送信されません。

メールが届かない場合は、迷惑メールフォルダも確認してください。

## infrastructure.drawio.png

これはinfrastructure.drawioの簡単な説明です

### この構成図の目的
- 個人学習用のAWS基本構成

### 前提条件
- 東京リージョン
- プライベート/パブリックに分離

### 利用するAWSサービス一覧
- Amazon VPC
- Internet Gateway（IGW）
- NAT Gateway
- Elastic Load Balancing（ALB）
- Amazon EC2
- Amazon RDS
- Amazon S3
- AWS ACM
- AWS CloudTrail
- AWS Config
- AWS Systems Manager

### 各サブネットの役割
- サブネット名	: 役割
- raisetech-subnet-public-a : ALB / NAT Gateway 配置
- raisetech-subnet-public-c	: 冗長化用 Public サブネット
- raisetech-subnet-ap-a	: アプリケーション（EC2）
- raisetech-subnet-ap-c : 冗長化用 AP
- raisetech-subnet-db-a	: RDS（DB）
- raisetech-subnet-db-c	: 冗長化用 DB
 ※ Private サブネットは Internet Gateway への直接ルートを持たず、NAT Gateway 経由でのみ外部通信可能。

 ### 主な通信フロー
- from:to:ポート 
- User→ALB	80 / 443	
- ALB→EC2 (AP)	80 / 443	
- EC2 (AP)	→RDS (DB)	3306
- EC2 (AP)	→Internet	443

本図で使用しているアイコンは AWS公式アーキテクチャアイコン（AWS Architecture Icons）を使用しています。





