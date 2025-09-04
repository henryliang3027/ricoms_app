# Ricoms App

## 概述
Ricoms App 是一個基於 Flutter 開發的網路設備管理應用程式，支援 ACI 設備管理，包含 1.8G/1.2G 放大器(AMP)、光節點(Node) 及 DSIM 等設備。應用程式提供設備狀態監控、歷史資料查詢、實時告警處理等功能。

## 項目架構

### 設計原則
採用 BLoC 架構從介面到資料存取的完整分層設計，確保了程式碼的可維護性和模組化。

**核心設計原則：**
- **分層架構**：展示層 (Page)、業務邏輯層 (BLoC) 和資料層 (Repository)
- **模組化設計**：按功能劃分為 Root、Dashboard、History、RealTimeAlarm、Advanced、Account 等模組
- **狀態管理**：使用 BLoC 進行狀態管理和事件處理
- **資料分離**：Repository 確保資料存取邏輯的獨立性

### 資料流
1. **用戶操作**：Page 接收用戶輸入
2. **事件處理**：BLoC 處理業務邏輯和狀態管理
3. **資料存取**：Repository (資料層) 負責資料的讀取、寫入
4. **狀態更新**：BLoC 將處理結果通知 Page 更新介面

### 模組間的協作關係
- 每個功能模組都有獨立的 Page、BLoC 和 Repository
- HomePage 作為中央協調器，管理模組間的導航和狀態
- Repository 可以在多個模組間共享，實現資料的統一管理

## 目錄結構

```
lib/
├── main.dart                       # 應用程式入口點
├── app.dart                        # 應用程式配置
├── home/                           # 主頁面和導航
│   └── view/
├── authentication/                 # 認證模組
│   └── bloc/
├── login/                         # 登入功能
│   ├── bloc/
│   ├── models/
│   └── view/
├── root/                          # 根節點設備管理
│   ├── bloc/
│   ├── models/
│   └── view/
├── dashboard/                     # 儀表板
│   ├── bloc/
│   └── view/
├── history/                       # 歷史資料查詢
│   ├── bloc/
│   ├── model/
│   └── view/
├── real_time_alarm/              # 實時告警
│   ├── bloc/
│   └── view/
├── advanced/                     # 進階設定
│   ├── bloc/
│   └── view/
├── account/                      # 帳戶管理
│   ├── bloc/
│   ├── model/
│   └── view/
├── system_log/                   # 系統日誌
│   ├── bloc/
│   ├── model/
│   └── view/
├── bookmarks/                    # 書籤功能
│   ├── bloc/
│   └── view/
├── change_password/              # 密碼變更
│   ├── bloc/
│   └── view/
├── repository/                   # 資料存取層
│   ├── account_repository/
│   ├── advanced_repository/
│   ├── authentication_repository/
│   ├── bookmarks_repository/
│   ├── dashboard_repository/
│   ├── history_repository/
│   ├── real_time_alarm_repository/
│   ├── root_repository/
│   └── system_log_repository/
├── utils/                        # 工具類
│   ├── common_style.dart
│   ├── custom_errmsg.dart
│   └── message_localization.dart
├── custom_icons/                 # 自定義圖標
└── l10n/                        # 國際化
```

## 開發規範

### 命名規範
- **BLoC**: `功能名稱_bloc.dart`、`功能名稱_event.dart`、`功能名稱_state.dart`
- **介面**: `功能名稱_page.dart`（頁面）、`功能名稱_form.dart`（表單）
- **Repository**: `功能名稱_repository.dart`
- **Model**: `功能名稱.dart`

### 模組結構
每個功能模組都遵循標準結構：
```
功能模組/
├── bloc/                         # 業務邏輯層
│   ├── 功能名稱_bloc.dart
│   ├── 功能名稱_event.dart
│   └── 功能名稱_state.dart
├── model/                        # 資料模型（如需要）
│   └── 功能名稱.dart
└── view/                         # 展示層
    ├── 功能名稱_page.dart
    └── 功能名稱_form.dart
```

## 系統架構圖

```mermaid
---
config:
  layout: elk
---
flowchart LR
    A["登入頁面"] --> A1["BLoC: AuthenticationBloc"]
    A1 --> B["Real-time Alarms<br>即時告警頁面"] & C["Root<br>設備樹狀結構頁面"] & D["Dashboard<br>儀表板"] & E["History<br>歷史記錄頁面"] & F["Bookmarks<br>設備書籤頁面"] & G["System Log<br>系統紀錄頁面"] & H["Account<br>帳戶設定頁面"] & I["Advanced<br>進階設定頁面"] & J["About<br>關於頁面"]
    B --> B1["Page: RealTimeAlarmPage"] & B2["BLoC: RealTimeAlarmBloc"] & B3["Repository: RealTimeAlarmRepository"]
    C --> C1["Page: RootPage"] & C2["BLoC: RootBloc"] & C3["Repository: RootRepository"] & C4["Repository: DeviceRepository"] & C5["Root子模組"]
    D --> D1["Page: DashboardPage"] & D2["BLoC: DashboardBloc"] & D3["Repository: DashboardRepository"]
    E --> E1["Page: HistoryPage"] & E2["BLoC: HistoryBloc"] & E3["Repository: HistoryRepository"] & E4["BLoC: SearchBloc"]
    F --> F1["Page: BookmarksPage"] & F2["BLoC: BookmarksBloc"] & F3["Repository: BookmarksRepository"]
    G --> G1["Page: SystemLogPage"] & G2["BLoC: SystemLogBloc"] & G3["Repository: SystemLogRepository"] & G4["SystemLog子模組"]
    H --> H1["Page: AccountPage"] & H2["BLoC: AccountBloc"] & H3["Repository: AccountRepository"] & H4["Account子模組"]
    I --> I1["Page: AdvancedPage"] & I2["Advanced子模組"]
    J --> J1["Page: AboutPage"] & J2["BLoC: 無專用 BLoC"] & J3["Repository: 無"]
     A:::rootNode
     A1:::blocNode
     B:::moduleNode
     C:::moduleNode
     D:::moduleNode
     E:::moduleNode
     F:::moduleNode
     G:::moduleNode
     H:::moduleNode
     I:::moduleNode
     J:::moduleNode
     B1:::pageNode
     B2:::blocNode
     B3:::repoNode
     C1:::pageNode
     C2:::blocNode
     C3:::repoNode
     C4:::repoNode
     C5:::subModuleNode
     D1:::pageNode
     D2:::blocNode
     D3:::repoNode
     E1:::pageNode
     E2:::blocNode
     E3:::repoNode
     E4:::blocNode
     F1:::pageNode
     F2:::blocNode
     F3:::repoNode
     G1:::pageNode
     G2:::blocNode
     G3:::repoNode
     G4:::subModuleNode
     H1:::pageNode
     H2:::blocNode
     H3:::repoNode
     H4:::subModuleNode
     I1:::pageNode
     I2:::subModuleNode
     J1:::pageNode
     J2:::blocNode
     J3:::repoNode
    classDef rootNode fill:#3498db,stroke:#2980b9,stroke-width:3px,color:#fff,font-size:14px,font-weight:bold
    classDef moduleNode fill:#e74c2c,stroke:#c0392b,stroke-width:2px,color:#fff,font-size:13px,font-weight:bold
    classDef subModuleNode fill:#f39c12,stroke:#d68910,stroke-width:2px,color:#fff,font-size:12px
    classDef pageNode fill:#e2f2fd,stroke:#2196f3,stroke-width:2px,font-size:12px
    classDef blocNode fill:#e8f5e8,stroke:#4caf50,stroke-width:2px,font-size:12px
    classDef repoNode fill:#fff3e0,stroke:#ff9800,stroke-width:2px,font-size:12px
```

## Root 設備管理模組架構圖

```mermaid
---
config:
  layout: elk
---
flowchart LR
    A["Root<br>設備樹狀結構頁面"] --> A1["Page: RootPage"] & A2["BLoC: RootBloc"] & A3["Repository: RootRepository"] & A4["Repository: DeviceRepository"]
    A --> B["設備編輯"] & C["群組編輯"] & D["設備歷史"] & E["監控圖表"] & F["設備搜尋"]
    
    B --> B1["Page: DeviceEditPage"] & B2["BLoC: EditDeviceBloc"] & B3["Repository: DeviceRepository"]
    C --> C1["Page: GroupEditPage"] & C2["BLoC: EditGroupBloc"] & C3["Repository: RootRepository"]
    D --> D1["Page: DeviceHistoryPage"] & D2["BLoC: DeviceHistoryBloc"] & D3["Repository: HistoryRepository"]
    E --> E1["Page: MonitoringChartPage"] & E2["BLoC: MonitoringChartBloc"] & E3["Repository: DeviceRepository"]
    F --> F1["Page: SearchPage"] & F2["BLoC: SearchBloc"] & F3["Repository: RootRepository"]
    
     A:::deviceNode
     A1:::pageNode
     A2:::blocNode
     A3:::repoNode
     A4:::repoNode
     B:::moduleNode
     C:::moduleNode
     D:::moduleNode
     E:::moduleNode
     F:::moduleNode
     B1:::pageNode
     B2:::blocNode
     B3:::repoNode
     C1:::pageNode
     C2:::blocNode
     C3:::repoNode
     D1:::pageNode
     D2:::blocNode
     D3:::repoNode
     E1:::pageNode
     E2:::blocNode
     E3:::repoNode
     F1:::pageNode
     F2:::blocNode
     F3:::repoNode
    classDef deviceNode fill:#e8f5e8,stroke:#388E3C,stroke-width:3px,color:#000,font-size:14px,font-weight:bold
    classDef moduleNode fill:#e74c2c,stroke:#c0392b,stroke-width:2px,color:#fff,font-size:13px,font-weight:bold
    classDef pageNode fill:#e2f2fd,stroke:#2196f3,stroke-width:2px,font-size:12px
    classDef blocNode fill:#e8f5e8,stroke:#4caf50,stroke-width:2px,font-size:12px
    classDef repoNode fill:#fff3e0,stroke:#ff9800,stroke-width:2px,font-size:12px
```

## SystemLog 系統日誌模組架構圖

```mermaid
---
config:
  layout: elk
---
flowchart LR
    A["System Log<br>系統紀錄頁面"] --> A1["Page: SystemLogPage"] & A2["BLoC: SystemLogBloc"] & A3["Repository: SystemLogRepository"]
    A --> B["日誌篩選"]
    
    B --> B1["Page: FilterPage"] & B2["BLoC: FilterBloc"] & B3["Repository: SystemLogRepository"]
    
     A:::logNode
     A1:::pageNode
     A2:::blocNode
     A3:::repoNode
     B:::moduleNode
     B1:::pageNode
     B2:::blocNode
     B3:::repoNode
    classDef logNode fill:#e3f2fd,stroke:#1976D2,stroke-width:3px,color:#000,font-size:14px,font-weight:bold
    classDef moduleNode fill:#e74c2c,stroke:#c0392b,stroke-width:2px,color:#fff,font-size:13px,font-weight:bold
    classDef pageNode fill:#e2f2fd,stroke:#2196f3,stroke-width:2px,font-size:12px
    classDef blocNode fill:#e8f5e8,stroke:#4caf50,stroke-width:2px,font-size:12px
    classDef repoNode fill:#fff3e0,stroke:#ff9800,stroke-width:2px,font-size:12px
```

## 進階設定模組架構圖

```mermaid
---
config:
  layout: elk
---
flowchart LR
    A["Advanced<br>進階設定頁面"] --> A1["Page: AdvancedPage"]
    A --> B["Batch Setting<br>批次設定"] & C["Default Setting<br>預設設定"] & D["Server IP Setting<br>伺服器IP設定"] & E["Trap Forward<br>Trap轉發"] & F["Trap Alarm<br>Trap警報"] & G["Device Working Cycle<br>設備工作週期"] & H["Log Record Setting<br>日誌記錄設定"]
    
    B --> B1["Page: SelectModulePage"] & B2["BLoC: SelectModuleBloc"] & B3["Repository: BatchSettingRepository"]
    B --> B4["Page: SelectDevicePage"] & B5["BLoC: SelectDeviceBloc"]
    B --> B6["Page: ConfigDevicePage"] & B7["BLoC: ConfigDeviceBloc"]
    B --> B8["Page: DeviceSettingResultPage"] & B9["BLoC: DeviceSettingResultBloc"]
    
    C --> C1["Page: DefaultSettingPage"] & C2["BLoC: DefaultSettingBloc"] & C3["Repository: DefaultSettingRepository"]
    
    D --> D1["Page: ServerIPSettingPage"] & D2["BLoC: ServerIPSettingBloc"] & D3["Repository: ServerIPSettingRepository"]
    
    E --> E1["Page: TrapForwardPage"] & E2["BLoC: TrapForwardBloc"] & E3["Repository: TrapForwardRepository"]
    E --> E4["Page: TrapForwardEditPage"] & E5["BLoC: EditTrapForwardBloc"]
    
    F --> F1["Page: TrapAlarmColorPage"] & F2["BLoC: TrapAlarmColorBloc"] & F3["Repository: TrapAlarmColorRepository"]
    F --> F4["Page: TrapAlarmSoundPage"] & F5["BLoC: TrapAlarmSoundBloc"] & F6["Repository: TrapAlarmSoundRepository"]
    
    G --> G1["Page: DeviceWorkingCyclePage"] & G2["BLoC: DeviceWorkingCycleBloc"] & G3["Repository: DeviceWorkingCycleRepository"]
    
    H --> H1["Page: LogRecordSettingPage"] & H2["BLoC: LogRecordSettingBloc"] & H3["Repository: LogRecordSettingRepository"]
    
     A:::advancedNode
     A1:::pageNode
     B:::moduleNode
     C:::moduleNode
     D:::moduleNode
     E:::moduleNode
     F:::moduleNode
     G:::moduleNode
     H:::moduleNode
     B1:::pageNode
     B2:::blocNode
     B3:::repoNode
     B4:::pageNode
     B5:::blocNode
     B6:::pageNode
     B7:::blocNode
     B8:::pageNode
     B9:::blocNode
     C1:::pageNode
     C2:::blocNode
     C3:::repoNode
     D1:::pageNode
     D2:::blocNode
     D3:::repoNode
     E1:::pageNode
     E2:::blocNode
     E3:::repoNode
     E4:::pageNode
     E5:::blocNode
     F1:::pageNode
     F2:::blocNode
     F3:::repoNode
     F4:::pageNode
     F5:::blocNode
     F6:::repoNode
     G1:::pageNode
     G2:::blocNode
     G3:::repoNode
     H1:::pageNode
     H2:::blocNode
     H3:::repoNode
    classDef advancedNode fill:#fff3e0,stroke:#FF6F00,stroke-width:3px,color:#000,font-size:14px,font-weight:bold
    classDef moduleNode fill:#e74c2c,stroke:#c0392b,stroke-width:2px,color:#fff,font-size:13px,font-weight:bold
    classDef pageNode fill:#e2f2fd,stroke:#2196f3,stroke-width:2px,font-size:12px
    classDef blocNode fill:#e8f5e8,stroke:#4caf50,stroke-width:2px,font-size:12px
    classDef repoNode fill:#fff3e0,stroke:#ff9800,stroke-width:2px,font-size:12px
```

## 核心功能模組

### Root 模組
設備管理核心模組，提供設備瀏覽、編輯、監控圖表等功能。

### Advanced 模組
進階設定模組，包含：
- 批次設定 (Batch Setting)
- 預設設定 (Default Setting)
- Trap 轉發設定 (Trap Forward)
- 告警聲音/顏色設定
- 伺服器 IP 設定
- 日誌記錄設定

### Dashboard 模組
提供設備狀態概覽和統計圖表。

### History 模組
歷史資料查詢和分析功能。

### Real-time Alarm 模組
實時告警監控和處理。

## 應用程式流程圖

```mermaid
---
config:
  layout: elk
---
flowchart TD
    A["應用程式啟動"] --> B["main.dart 進入點"]
    B --> C["Hive 資料庫初始化"]
    C --> D["App UI 建立"]
    D --> E{"身份驗證檢查"}
    E -- 未登入 --> F["登入頁面"]
    E -- 已登入 --> G["主頁面"]
    F --> H{"登入驗證"}
    H -- 失敗 --> I["顯示錯誤訊息"]
    I --> F
    H -- 成功 --> G
    G --> J["功能頁面組"]
    J --> K["Real-time Alarms<br>即時告警頁面"] & L["Root<br>設備樹狀結構頁面"] & M["Dashboard<br>儀表板"] & N["History<br>歷史紀錄頁面"] & O["Bookmarks<br>設備書籤頁面"] & P["System Log<br>系統紀錄頁面"] & Q["Account<br>帳戶設定頁面"] & R["Advanced<br>進階設定頁面"] & S["About<br>關於頁面"] & AA["登出"]
    L --> T["設備管理頁面"]
    O --> T
    K --> T
    N --> T
    R --> U["批次設定<br>頁面"] & V["裝置輪詢週期設定頁面"] & W["伺服器 IP 設定頁面"] & X["清除紀錄相關參數設定頁面"] & Y["告警轉發設定頁面"] & Z["告警警告聲設定頁面"]
    Q --> BB["修改密碼頁面"]
    BB --> CC{"密碼修改成功?"}
    CC -- 成功 --> DD["自動登出"]
    CC -- 失敗 --> EE["顯示錯誤訊息"]
    EE --> BB
    DD --> F
    AA --> GG{"確認登出?"}
    GG -- 取消 --> J
    GG -- 確認 --> F
     A:::startNode
     B:::processNode
     C:::processNode
     D:::processNode
     E:::decisionNode
     F:::processNode
     G:::processNode
     H:::decisionNode
     I:::processNode
     J:::processNode
     K:::alarmNode
     L:::deviceNode
     M:::dashboardNode
     N:::historyNode
     O:::bookmarkNode
     P:::logNode
     Q:::accountNode
     R:::advancedNode
     S:::processNode
     T:::deviceNode
     U:::advancedNode
     V:::advancedNode
     W:::advancedNode
     X:::advancedNode
     Y:::advancedNode
     Z:::advancedNode
     AA:::logoutNode
     BB:::accountNode
     CC:::decisionNode
     DD:::logoutNode
     EE:::processNode
     GG:::decisionNode
    classDef decisionNode fill:#f3e5f5,stroke:#7B1FA2,stroke-width:4px,color:#000,font-size:30px,font-weight:bold,min-width:300px,padding:12px
    classDef startNode fill:#e1f5fe,stroke:#0277BD,stroke-width:4px,color:#000,font-size:30px,font-weight:bold,min-width:300px,padding:12px
    classDef alarmNode fill:#fff3e0,stroke:#F57C00,stroke-width:4px,color:#000,font-size:30px,font-weight:bold,min-width:300px,padding:12px
    classDef deviceNode fill:#e8f5e8,stroke:#388E3C,stroke-width:4px,color:#000,font-size:30px,font-weight:bold,min-width:300px,padding:12px
    classDef dashboardNode fill:#fce4ec,stroke:#C2185B,stroke-width:4px,color:#000,font-size:30px,font-weight:bold,min-width:300px,padding:12px
    classDef historyNode fill:#f1f8e9,stroke:#689F38,stroke-width:4px,color:#000,font-size:30px,font-weight:bold,min-width:300px,padding:12px
    classDef bookmarkNode fill:#fff8e1,stroke:#FBC02D,stroke-width:4px,color:#000,font-size:30px,font-weight:bold,min-width:300px,padding:12px
    classDef logNode fill:#e3f2fd,stroke:#1976D2,stroke-width:4px,color:#000,font-size:30px,font-weight:bold,min-width:300px,padding:12px
    classDef accountNode fill:#fafafa,stroke:#616161,stroke-width:4px,color:#000,font-size:30px,font-weight:bold,min-width:300px,padding:12px
    classDef advancedNode fill:#fff3e0,stroke:#FF6F00,stroke-width:4px,color:#000,font-size:30px,font-weight:bold,min-width:300px,padding:12px
    classDef logoutNode fill:#ffebee,stroke:#D32F2F,stroke-width:4px,color:#000,font-size:30px,font-weight:bold,min-width:300px,padding:12px
    classDef processNode fill:#f0f0f0,stroke:#333,stroke-width:3px,color:#000,font-size:30px,min-width:300px,padding:10px
    linkStyle 4 font-size:20px,fill:none
    linkStyle 5 font-size:20px,fill:none
    linkStyle 7 font-size:20px,fill:none
    linkStyle 9 font-size:20px,fill:none
    linkStyle 18 font-size:20px,fill:none
    linkStyle 19 font-size:20px,fill:none
    linkStyle 22 font-size:20px,fill:none
    linkStyle 23 font-size:20px,fill:none
```

## 技術特點

- **框架**：Flutter 3.4.0+
- **狀態管理**：BLoC Pattern
- **資料持久化**：Hive
- **網路請求**：Dio
- **圖表元件**：FL Chart
- **國際化**：支援中英文
- **平台支援**：Android、iOS、macOS、Windows、Linux
