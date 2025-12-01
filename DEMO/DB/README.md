# 在 Docker 中還原 AdventureWorks 備份

以下步驟示範如何將 `AdventureWorks2022.bak` 與 `QueryStoreDemo.bak`（可依需求替換成任意兩個 `.bak` 檔）還原到 SQL Server 2022 Docker 容器中。若僅需還原其中一個資料庫，執行相對應的指令即可。

## 1. 先決條件

- Windows 或 WSL2 環境中的 Docker Desktop（已啟動 Linux container 模式）。
- 這個專案資料夾已 clone 並可在本機讀寫，例如：`C:\Users\tzyu\Source\Repos\DP-300`。
- Docker 指令列與 `sqlcmd`（已隨容器映像提供，也可在主機安裝 SQLCMD/ Azure Data Studio）。

## 2. 下載並啟動 SQL Server 2022 容器

```powershell
# 取得最新版 SQL Server 2022 容器映像
 docker pull mcr.microsoft.com/mssql/server:2022-latest

# 啟動容器（先不掛載路徑，稍後用 docker cp 複製備份）
 docker run --name mssql2022 \ 
    -e "ACCEPT_EULA=Y" \ 
    -e "MSSQL_SA_PASSWORD=P@ssw0rd" \ 
    -p 1433:1433 \ 
    -d mcr.microsoft.com/mssql/server:2022-latest
```

> **提示**：若你使用 Git Bash／WSL，Windows 路徑需改寫成 `//c/Users/...`。

確認容器運行：

```powershell
docker ps -f name=mssql2022
```

## 3. 將 BAK 複製進容器

容器啟動後，在容器內建立備份資料夾並複製 `.bak`：

```powershell
# 建立容器內的備份資料夾
docker exec mssql2022 mkdir -p /var/opt/mssql/backup

# 複製 AdventureWorks2022.bak
docker cp "C:\\Users\\tzyu\\Source\\Repos\\DP-300\\DEMO\\DB\\AdventureWorks2022.bak" mssql2022:/var/opt/mssql/backup/

# 複製 QueryStoreDemo.bak
docker cp "C:\\Users\\tzyu\\Source\\Repos\\DP-300\\DEMO\\DB\\QueryStoreDemo.bak" mssql2022:/var/opt/mssql/backup/
```

> 如需複製更多備份檔，重複 `docker cp` 指令即可。

確認檔案存在：

```powershell
docker exec mssql2022 ls -lh /var/opt/mssql/backup
```

## 4. 連線到容器

容器內已安裝 `sqlcmd`，可直接在主機端執行：

```powershell
docker exec -it mssql2022 /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P P@ssw0rd
```

或在主機安裝的 SSMS / Azure Data Studio 以 `localhost,1433` 連線。

## 5. 查詢備份檔內容

在還原前，先取得 `.bak` 中的邏輯檔名（稍後 `MOVE` 參數會用到）：

```powershell
docker exec -it mssql2022 /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P P@ssw0rd \
  -Q "RESTORE FILELISTONLY FROM DISK = '/var/opt/mssql/backup/AdventureWorks2022.bak';"
```

記下結果中的 **LogicalName**（例如 `AdventureWorks2022` 與 `AdventureWorks2022_log`）。對第二個備份檔也做一次 `RESTORE FILELISTONLY`。

## 6. 還原 AdventureWorks2022 範例

```powershell
docker exec -it mssql2022 /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P P@ssw0rd \
  -Q "RESTORE DATABASE AdventureWorks2022 \
      FROM DISK = '/var/opt/mssql/backup/AdventureWorks2022.bak' \
      WITH MOVE 'AdventureWorks2022' TO '/var/opt/mssql/data/AdventureWorks2022.mdf', \
           MOVE 'AdventureWorks2022_log' TO '/var/opt/mssql/data/AdventureWorks2022_log.ldf', \
           REPLACE;"
```

- 將 `MOVE` 後的路徑替換成你希望在容器內儲存資料檔的位置（預設 `/var/opt/mssql/data/`）。
- 如果 `RESTORE FILELISTONLY` 顯示的邏輯名稱不同，請一併替換。

## 7. 還原 QueryStoreDemo 範例

```powershell
docker exec -it mssql2022 /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P P@ssw0rd \
  -Q "RESTORE DATABASE QueryStoreDemo \
      FROM DISK = '/var/opt/mssql/backup/QueryStoreDemo.bak' \
      WITH MOVE 'QueryStoreDemo' TO '/var/opt/mssql/data/QueryStoreDemo.mdf', \
           MOVE 'QueryStoreDemo_log' TO '/var/opt/mssql/data/QueryStoreDemo_log.ldf', \
           REPLACE;"
```

同樣根據 `RESTORE FILELISTONLY` 的邏輯檔名調整 `MOVE` 參數。

## 8. 驗證

```powershell
docker exec -it mssql2022 /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P P@ssw0rd \
  -Q "SELECT name, state_desc FROM sys.databases WHERE name IN ('AdventureWorks2022','QueryStoreDemo');"
```

## 9. 常見問題

- **資料庫鎖定或還原失敗**：加入 `WITH REPLACE` 會覆蓋同名資料庫；若仍失敗，確認沒有使用者連線，可以先 `ALTER DATABASE ... SET SINGLE_USER WITH ROLLBACK IMMEDIATE`。
- **備份檔權限不足**：確保 Docker volume 中的 `.bak` 檔對容器內的 `mssql` 使用者可讀（Windows 預設沒問題）。
- **密碼不符合複雜度**：`sa` 密碼必須至少 8 字元並包含大小寫、數字與符號。

完成後即可在 SSMS/Azure Data Studio 連線 `localhost,1433`，使用 `sa` / `P@ssw0rd` 操作這兩個 DEMO 資料庫。
