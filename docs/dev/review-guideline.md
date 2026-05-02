# PR レビューガイドライン

DevTools Extension のコードをレビューし、以下の観点で指摘してください。

  - `Effective Dart のベストプラクティス遵守`
  - `バグやクラッシュにつながる可能性`
  - `VM Service / DTD との通信パターンの正確性`
  - `非同期処理の危険パターン`
  - `アイソレート変化・ホットリロードへの対応`

特に **致命的バグパターン** の検出を最優先設定。DevTools 内でクラッシュ・フリーズ・データ化け・メモリリークを引き起こす可能性のある問題を重点的にチェックしてください。

## DevTools Extension 固有の前提知識

DevTools Extension は Flutter **Web** アプリとして iFrame 内で動作し、通常の Flutter アプリとは異なる制約があります。

  - **通信はすべて非同期 RPC**: Extension ↔ DevTools ↔ VM Service ↔ 対象アプリ
  - **ファイルシステムへの直接アクセス不可**: 必ず DTD (Dart Tooling Daemon) 経由
  - **アイソレートはホットリロードで変わる**: リスナーが古いアイソレートを参照し続けると不具合
  - **iFrame サンドボックス**: `postMessage` 以外の親ウィンドウへのアクセスは不可
  - **`requiresConnection`** が `true`（デフォルト）のとき、未接続状態で Extension は無効化される

---

## レビュー観点（致命的バグ検出重点）

### VM Service / DTD 通信

  - [ ] **サービス呼び出しのエラーハンドリング**
    - [ ] `serviceManager.callServiceExtension()` に `try-catch` / `.catchError()` があるか
    - [ ] 切断中・未接続時に呼び出しが発生しないよう `isServiceAvailable` を確認しているか
    - [ ] タイムアウトが設定されており、長時間ブロックしないか
  - [ ] **サービス拡張のレスポンス**
    - [ ] ハンドラが必ず `ServiceExtensionResponse.result()` または `.error()` を返すか
    - [ ] Future が複数回完了する（ホットリスタート時の二重完了）パターンがないか
    - [ ] パラメータの JSON デコードで例外が起きてもクラッシュしないか
  - [ ] **DTD 利用**
    - [ ] `dtdManager` が利用不可の場合に適切にフォールバックしているか
    - [ ] ファイル操作が DTD 経由になっているか（直接 `dart:io` は使えない）

### アイソレート変化・ホットリロード

  - [ ] **古いアイソレート参照**
    - [ ] アイソレート変化時にリスナーを再登録しているか
    - [ ] `selectedIsolate` の変化を `addListener` で監視し、処理を切り替えているか
  - [ ] **ストリームの再購読**
    - [ ] ホットリロード後にストリームが無効化されていないか
    - [ ] `initState` で購読し `dispose` でキャンセルしているか

### リスナー・サブスクリプションのリーク

  - [ ] **dispose 漏れ**
    - [ ] `serviceManager` / `extensionManager` / `dtdManager` へのリスナーが `dispose()` でキャンセルされているか
    - [ ] `StreamSubscription` が未キャンセルで放置されていないか
    - [ ] タイマー・ポーリングが Extension タブを閉じると停止するか

### 接続状態管理

  - [ ] **未接続時の動作**
    - [ ] `requiresConnection: true` の場合、未接続でサービス呼び出しを行っていないか
    - [ ] 接続・切断イベントで UI 状態が正しく更新されるか
  - [ ] **非同期処理中の切断**
    - [ ] 長時間の処理中に切断が発生した場合にハンドリングされているか

### 非同期処理の一般的な危険パターン

  - [ ] **unawaited Future**
    - [ ] `initState` や `afterBuild` で `await` 漏れがないか
    - [ ] 例外がサイレントに握りつぶされていないか
  - [ ] **並行処理の管理**
    - [ ] 複数の `callServiceExtension` を直列で呼ぶ必要があるとき、順序保証されているか
    - [ ] `Future.wait` で一件失敗時に残りの処理が中断されないか

---

### 一般的なコード品質

  - [ ] 可読性・保守性
  - [ ] 設計原理の遵守
  - [ ] **null 安全・型安全**
    - [ ] サービスレスポンスの JSON パースで null クラッシュがないか
    - [ ] `serviceManager` / `dtdManager` が null のまま使われていないか
  - [ ] テスト可能性
  - [ ] セキュリティ（サービス拡張のパラメータバリデーション）

### プロジェクト固有

  - [ ] 命名規則の統一
    - [ ] サービス拡張のメソッド名が `ext.<packageName>.<methodName>` 形式か
  - [ ] `config.yaml` に必須フィールド（`name`, `version`, `issueTracker`, `materialIconCodePoint`）があるか
  - [ ] `DevToolsExtension` ウィジェットがルートに配置されているか
  - [ ] 既存コードの整合性

---

## レビューで出力される内容

### 1. **致命的問題の指摘**

  - クラッシュ・フリーズ・メモリリークの可能性
  - VM Service / DTD の不正な使用
  - データ損失リスク（アイソレート変化時の状態喪失など）
  - セキュリティ上の問題

### 2. **致命的バグ・クラッシュの検出パターン**

  - **dispose 漏れ**: タブを閉じてもリスナーが残り続けメモリを消費
  - **二重完了 Future**: ホットリスタートでハンドラが二度呼ばれ例外
  - **古いアイソレート参照**: ホットリロード後に無効なアイソレートへアクセス
  - **切断中のサービス呼び出し**: 切断後に `callServiceExtension` してクラッシュ
  - **unawaited Future**: 例外が握りつぶされてサイレント失敗
  - **JSON パースクラッシュ**: 不正なパラメータで `jsonDecode` が例外

### 3. **改善提案**

  - より堅牢な実装方法
  - 適切な例外処理パターン
  - エラー回復戦略の提案

### 4. **具体的修正コード例**

  - 修正前後のコード比較
  - 推奨実装パターン

---

## レビュー実行時の必須チェックリスト

### Claude が最優先で確認すべき致命的なパターン

#### 1. **`dispose()` でのリスナークリーンアップ漏れ**

```dart
// 危険: タブを閉じてもリスナーが残り続ける
class _MyExtensionState extends State<MyExtension> {
  @override
  void initState() {
    serviceManager.onIsolateStopped.addListener(_onIsolateStopped);
  }
  // dispose() が未実装 → メモリリーク
}

// 安全
@override
void dispose() {
  serviceManager.onIsolateStopped.removeListener(_onIsolateStopped);
  _subscription?.cancel();
  super.dispose();
}
```

#### 2. **切断チェックなしのサービス呼び出し**

```dart
// 危険: 切断中に呼び出してクラッシュ
final result = await serviceManager.callServiceExtension('ext.myapp.getData');

// 安全
if (!serviceManager.isServiceAvailable) {
  return; // または UI でエラー表示
}
final result = await serviceManager.callServiceExtension('ext.myapp.getData');
```

#### 3. **ホットリロード後の古いアイソレート参照**

```dart
// 危険: アイソレート変化を検知していない
final isolate = serviceManager.isolateManager.selectedIsolate.value;
await heavyOperation(isolate); // アイソレートが切り替わると無効

// 安全
serviceManager.isolateManager.selectedIsolate.addListener(_onIsolateChanged);
// _onIsolateChanged で再初期化
```

#### 4. **サービス拡張ハンドラの二重完了**

```dart
// 危険: タイムアウト後もハンドラが完了しようとする
Future<ServiceExtensionResponse> handler(String method, Map<String, String> params) async {
  final result = await operation().timeout(const Duration(seconds: 5));
  return ServiceExtensionResponse.result(jsonEncode(result)); // timeout後も到達する可能性
}

// 安全: Completer で単一完了を保証
final completer = Completer<ServiceExtensionResponse>();
operation().timeout(const Duration(seconds: 5)).then(
  (r) { if (!completer.isCompleted) completer.complete(...); },
  onError: (e) { if (!completer.isCompleted) completer.completeError(e); },
);
return completer.future;
```

#### 5. **unawaited な非同期処理**

```dart
// 危険: 例外が握りつぶされる
@override
void initState() {
  super.initState();
  loadData(); // await なし
}

// 安全
@override
void initState() {
  super.initState();
  unawaited(loadData().catchError((e) {
    // エラーハンドリング
  }));
}
```

#### 6. **JSON パースの無防備な処理**

```dart
// 危険: 不正な JSON でクラッシュ
Future<ServiceExtensionResponse> handler(String method, Map<String, String> params) async {
  final data = jsonDecode(params['data']!); // null / 不正 JSON でクラッシュ

// 安全
  final rawData = params['data'];
  if (rawData == null) {
    return ServiceExtensionResponse.error(
      ServiceExtensionResponse.invalidParams,
      '"data" parameter is required',
    );
  }
  try {
    final data = jsonDecode(rawData);
    ...
  } on FormatException catch (e) {
    return ServiceExtensionResponse.error(
      ServiceExtensionResponse.invalidParams,
      'Invalid JSON: $e',
    );
  }
}
```

---

## オプション

  - `--pre-commit` : コミット前チェックモード（より厳密なレビュー）
  - `--focus=performance` : 特定の観点に絞ったレビュー
  - `--japanese` : 日本語でのレビュー結果出力
