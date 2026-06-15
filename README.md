# AWS Infrastructure — Terraform IaC Project

## Overview

個人学習として、**本番環境を想定したAWSインフラをTerraformで構築**したプロジェクトです。
CloudFormationで設計した構成をTerraformへ移植することで、IaCツールの違いと使い分けを実践的に学習しました。

> **実際に `terraform apply` でAWSへデプロイ済み**の環境コードです。

---

## Architecture

![Infrastructure Diagram](./infrastructure.png)

### 構成の概要

| レイヤー | サービス | 設計意図 |
|----------|----------|----------|
| ネットワーク | VPC / IGW / NAT Gateway | パブリック/プライベートを分離しアクセス制御 |
| ロードバランサー | ALB | 複数AZへの振り分けで可用性を確保 |
| コンピュート | EC2 | プライベートサブネットに配置しセキュリティ強化 |
| データベース | RDS | 機密データを扱うためプライベートサブネットに隔離 |
| ストレージ | S3 | 静的アセット・ログ保管 |
| セキュリティ | AWS WAF / ACM / Systems Manager | WAFで不正アクセス遮断、SSMでEC2への安全なアクセス |
| 監視・通知 | CloudWatch / SNS | アラームと通知を連携し運用監視を自動化 |
| ガバナンス | CloudTrail / AWS Config | 操作ログ・構成変更を継続的に記録 |

---

## Subnet Design

```
VPC (10.0.0.0/16)
├── Public
│   ├── raisetech-subnet-public-a   ALB / NAT Gateway
│   └── raisetech-subnet-public-c   冗長化用
├── Application (Private)
│   ├── raisetech-subnet-ap-a       EC2 (アプリケーション)
│   └── raisetech-subnet-ap-c       冗長化用
└── Database (Private)
    ├── raisetech-subnet-db-a       RDS
    └── raisetech-subnet-db-c       冗長化用
```

Private サブネットはIGWへの直接ルートを持たず、NAT Gateway経由でのみ外部通信が可能です。

---

## Why Terraform?

当初はCloudFormationで構成を設計しましたが、以下の理由からTerraformへ移植しました。

- **マルチクラウド対応**: Terraformは将来的にAzure/GCPへも応用可能
- **state管理**: 構成変更の差分（plan）を事前確認できる安全な運用フロー
- **コードの可読性**: HCLはYAMLより直感的でモジュール化しやすい

---

## Monitoring & Alerting Design

MSP運用を意識し、**障害を早期検知する仕組み**を構成に組み込みました。

![Monitoring Diagram](./monitoring.png)

- CloudWatch Alarm → SNS → Email通知 の連携
- EC2・RDS のメトリクス監視（CPU使用率など）
- CloudTrail で全APIコールを記録（セキュリティ監査対応）
- AWS Config で構成変更を継続的に追跡

---

## What I Struggled With (実践で詰まったこと)

### Spring Boot の接続エラー
- **問題**: 設定ファイルのスペルミスと手順ミスで接続できない状態が続いた
- **解決**: エラーメッセージを分解し、設定値を1つずつ照合して原因を特定

### WAF・SNS の連携設定
- **問題**: AWSサービス間の連携設定（ARN参照・ポリシー設定）でエラーが頻発
- **解決**: AWSドキュメントとTerraformドキュメントを並行して読み、設定値の意味を理解してから修正

### 英語ドキュメントの読み方
- **問題**: エラーメッセージや公式ドキュメントが英語で、どこを見るべきか判断できなかった
- **対処**: AIを活用してエラーを翻訳・解釈しながら、ドキュメントの読み方自体を習得中

---

## Tech Stack

- **IaC**: Terraform (HCL)
- **Cloud**: AWS (Tokyo Region)
- **Monitoring**: Amazon CloudWatch / AWS CloudTrail / AWS Config
- **Security**: AWS WAF / AWS ACM / AWS Systems Manager
- **Diagram**: draw.io

---

## Repository Structure

```
.
├── terraform/          # Terraformコード一式
├── infrastructure.png  # アーキテクチャ図
├── infrastructure.drawio  # draw.ioソースファイル
└── README.md
```

---

## 今後の追加予定

- [ ] Terraformテスト（`.tftest.hcl`）の追加
- [ ] GitHub Actions による `terraform plan` の自動実行（CI）
- [ ] モジュール化によるコードの再利用性向上
