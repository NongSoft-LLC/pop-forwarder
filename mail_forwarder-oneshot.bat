@echo off
chcp 932 >nul
setlocal

REM POP3メール転送ツール - ワンショット実行バッチ
REM 一度だけメールをチェックして転送します

echo ======================================
echo POP3 Mail Forwarder - OneShot Mode
echo ======================================
echo.

REM スクリプトのディレクトリに移動
cd /d %~dp0

REM Python環境のチェック
python --version >nul 2>&1
if errorlevel 1 (
    echo エラー: Pythonが見つかりません
    echo Pythonをインストールしてください
    pause
    exit /b 1
)

REM 必要なパッケージのインストール確認
echo 依存パッケージを確認中...
python -c "import yaml, poplib, smtplib" >nul 2>&1
if errorlevel 1 (
    echo 必要なパッケージをインストールしています...
    python -m pip install -r requirements.txt
    if errorlevel 1 (
        echo エラー: パッケージのインストールに失敗しました
        pause
        exit /b 1
    )
)

REM 設定ファイルの確認
if not exist "config.yaml" (
    echo エラー: config.yamlが見つかりません
    echo config.yaml.exampleを参考に設定ファイルを作成してください
    pause
    exit /b 1
)

REM ワンショット実行(詳細モード）
echo.
echo メールをチェックして転送しています...
echo （詳細ログモード）
echo.
python mail_forwarder.py --verbose
set EXIT_CODE=%ERRORLEVEL%

echo.
if %EXIT_CODE% equ 0 (
    echo 処理が完了しました
) else (
    echo エラーが発生しました ^(終了コード: %EXIT_CODE%^)
)

echo.
pause
exit /b %EXIT_CODE%
