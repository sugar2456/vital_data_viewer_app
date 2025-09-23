# vital_data_viewer_app

MVVM + repositoryを採用する

fitbitで記録したデータをweb api経由で取得するアプリ

mac os/ windowsアプリで動作する

認証はImplicit Grantを採用

## リリースタグのプッシュ
github actionsにタグをプッシュするとリリースノート生成する処理があるので、機能やバグ対応が発生したら以下のコマンドでタグを作成してプッシュすること
```
git tag vx.x.x
git push origin vx.x.x
```

# アプリの利用方法

ビルドしたアプリの準備やログイン方法についてはwikiに記載

https://github.com/sugar2456/vital_data_viewer_app/wiki
