# OR+ Porting ROM 移植方案关键文件 SHA-256 哈希对照表

## 一、仓库用途

本仓库收录 **OR+ Porting ROM 移植项目私有移植方案所涉及关键文件的 SHA-256 哈希值对照表**。

该对照表的存在目的仅有一项：**存证与查重**。当出现个别人员通过解包本团队产出的 ROM 移植包，窃取移植方案、移植用文件（配置、策略、私有二进制等）并据为己有的纠纷时，本表用于对以下两类文件进行哈希比对：

1. 我方存档的原生文件（以本表记录的哈希值为准）；
2. 疑似抄袭、复制、二次分发作品中提取出的同名或同源文件。

若比对结果一致，即可证明二者**二进制内容完全相同**，为纠纷中的技术举证提供客观依据。

本仓库**不包含任何方案文件本体**。此外，各类别目录下的文件清单 `nameList.txt` 本身即移植方案的组成部分（文件名、目录组织及文件大小均属方案内容），故其**不随本仓库分发**：该文件已记入 `.gitignore`，文件本体由本团队另设私有仓库管理，本仓库仅公开其对应的 SHA-256 校验文件 `nameList.txt.sha256`，用于证明清单文件在存档时点的内容完整性。

## 二、关于 SHA-256

### 2.1 算法性质

SHA-256（Secure Hash Algorithm 256-bit）属于 SHA-2 族密码散列函数，由美国国家标准与技术研究院（NIST）于 2001 年发布，现行标准为 FIPS PUB 180-4。其核心性质如下：

- **输出定长**：任意长度输入，输出恒为 256 位（64 个十六进制字符）摘要。
- **确定性**：同一输入在任何平台、任何时间、任何实现下计算，所得摘要恒定相同。这是哈希比对成立的前提。
- **雪崩效应**：输入内容哪怕只改变 1 个比特，输出摘要也会发生剧烈且不可预测的变化，与原摘要几乎完全不同。
- **抗碰撞性**：目前不存在已知的有效方法找到两个不同输入具有相同 SHA-256 摘要。其生日攻击界为 2^128，构造碰撞在计算上不可行。
- **单向性（抗原像）**：无法由摘要反推出原始输入内容。

### 2.2 为什么可用于文件比对与查重

基于上述性质，SHA-256 摘要可以作为文件内容的"指纹"：

- 两文件 SHA-256 值**相同**，则二者内容逐字节一致的概率在工程与司法意义上等同于必然（差异而不碰撞需要打破 2^128 量级的安全性边界，现实中不可实现）；
- 两文件 SHA-256 值**不同**，则二者内容必然不同（确定性保证：内容相同则摘要必相同，逆否命题成立）。

因此，将疑似抄袭文件计算 SHA-256 后与本表记录值比对：

- **命中**：该文件与我方存档文件内容完全一致，可证明其直接复制自我方产出；
- **未命中**：该文件与我方对应存档文件内容不一致（或已被修改）。注意：未命中仅说明内容不一致，不能单独作为反向结论的依据。

### 2.3 权威信源

- NIST FIPS PUB 180-4《Secure Hash Standard》（官方标准原文）：
  https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.180-4.pdf
- NIST CSRC — Hash Functions 项目页：
  https://csrc.nist.gov/projects/hash-functions
- IETF RFC 6234（SHA-2 算法的 Internet 标准化描述）：
  https://datatracker.ietf.org/doc/html/rfc6234
- 维基百科 SHA-2 词条：
  https://zh.wikipedia.org/wiki/SHA-2
  https://en.wikipedia.org/wiki/SHA-2

## 三、仓库结构

```
Archives/
└── 21027/                      # 设备内部项目号（prjname），对应特定型号设备
    ├── Codec2/                 # 媒体编解码配置
    │   ├── shaList.txt
    │   └── nameList.txt.sha256
    ├── Note/                   # 便签应用私有原生库
    │   ├── shaList.txt
    │   └── nameList.txt.sha256
    ├── odmHal/                 # ODM 层 HAL 服务与配置文件
    │   ├── shaList.txt
    │   └── nameList.txt.sha256
    ├── selinux/                # SELinux 策略文件
    │   ├── shaList.txt
    │   └── nameList.txt.sha256
    ├── sysConfig/
    │   ├── ext/                # 扩展分区系统配置
    │   │   ├── shaList.txt
    │   │   └── nameList.txt.sha256
    │   ├── pro/                # 产品分区系统配置
    │   │   ├── shaList.txt
    │   │   └── nameList.txt.sha256
    │   └── sys/                # 系统分区兼容性配置
    │       ├── shaList.txt
    │       └── nameList.txt.sha256
    └── vendorConfig/           # vendor 层配置
        ├── shaList.txt
        └── nameList.txt.sha256
scripts/
├── HASHOUT.sh                  # 对照表生成脚本（Android 设备端执行）
└── HASHNAMELIST.sh             # nameList.txt 哈希校验文件生成脚本
```

目录编号说明：`Archives/` 下类似 `21027` 的编号为**对应型号设备的内部项目号（prjname）**，同一编号下的全部条目均属该设备项目。

各叶子目录下的文件说明：

- `shaList.txt`：文件内容的 SHA-256 摘要列表，每行一个，共 64 位十六进制小写字符；
- `nameList.txt.sha256`：对应 `nameList.txt` 的完整性校验文件，采用 `sha256sum` 标准校验格式（`摘要  文件名`），可用 `sha256sum -c` 直接验证。

`nameList.txt`（文件名与文件大小清单，制表符分隔，格式为 `文件名\t字节数`）因涉及方案内容**不在本仓库中**，由团队私有仓库管理。在私有仓库侧，`shaList.txt` 第 N 行的哈希值对应 `nameList.txt` 第 N 行所列文件，即两表行号一一对应。

## 四、对照表生成方式

对照表由 `scripts/HASHOUT.sh` 在 Android 设备端（`/system/bin/sh`）执行生成。脚本遍历其所在目录下的全部普通文件，逐个计算 SHA-256 与文件大小，分别追加至 `shaList.txt` 与 `nameList.txt`。脚本自身与两份输出文件不参与计算。

在设备端于目标文件所在目录执行：

```sh
sh HASHOUT.sh
```

`nameList.txt.sha256` 校验文件由 `scripts/HASHNAMELIST.sh` 生成。该脚本遍历 `Archives/` 下全部 `nameList.txt`，逐个计算 SHA-256 并在同名目录下写入 `nameList.txt.sha256`。在任意具备 POSIX shell 环境的主机（Git Bash、WSL、Linux 等）于仓库根目录执行：

```sh
sh scripts/HASHNAMELIST.sh
```

## 五、验证方法

### 5.1 手工验证单个文件

Linux / macOS / Android（Termux、adb shell）：

```sh
sha256sum /path/to/suspect_file
```

Windows PowerShell：

```powershell
Get-FileHash -Algorithm SHA256 "C:\path\to\suspect_file"
```

将输出值（大小写不敏感）与本表对应条目比对。

### 5.2 nameList.txt 完整性验证

在对文件名清单进行比对前，可先验证所持 `nameList.txt` 与本仓库存档版本一致。在清单所在目录执行：

```sh
sha256sum -c nameList.txt.sha256
```

Windows PowerShell 亦可手工比对：

```powershell
Get-FileHash -Algorithm SHA256 .\nameList.txt
```

输出值与 `nameList.txt.sha256` 中记录的摘要一致，即证明该清单文件与本团队私有仓库中的存档版本内容完全相同。

### 5.3 批量比对

对疑似作品中提取出的一批文件，逐个计算 SHA-256 后与本仓库对应类别目录下的 `shaList.txt` 求交集；命中即证明该文件与我方存档内容一致。

## 六、证据效力与使用限制

1. 本表记录的是**存档时点**的文件内容快照。若我方后续更新文件，本表相应条目同步更新，并以最新版本为准；历史版本可通过 Git 提交记录追溯。
2. 哈希一致证明的是**内容同一性**，即在字节层面完全相同。在解释性陈述中应表述为"内容完全一致"，是否构成抄袭还需结合文件来源、获取途径、上下文等其他证据综合判断，本表作为其中的关键技术证据。
3. 哈希不一致仅表明内容与本表存档版本不同，可能源于文件被修改、重打包或版本差异，不能单独据此得出任何结论。
4. 本表不包含文件本体，不构成对方案内容本身的披露。

## 七、许可与声明

本仓库内容（哈希对照表）仅供 OR+ Porting ROM 项目团队在权属纠纷中用于验证与查重，未经许可不得用于其他目的。
