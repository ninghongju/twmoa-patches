# twmoa-patches

乌龟服客户端增强补丁，整理者：乌龟/水豚-G服战士Rina(已删号)。

这三个 DLL 和 VanillaFixes 不是我们写的。解压到已经有 `WoW.exe` 的客户端根目录后，运行 `VanillaFixes.exe` 即可。游戏本体、角色存档和 `twloader.dll` 不在这个包里。

## 怎么用

1. 下载仓库的 zip，解压。
2. 把解压出来的这些内容放到 `WoW.exe` 同一层，让下面的文件和文件夹直接挨着 `WoW.exe`：

   - `VanillaFixes.exe`
   - `VfPatcher.dll`
   - `dlls.txt`
   - `DLL`
   - `Interface`

   GitHub 的 zip 外面多包了一层目录，要进去把里面的文件拿出来，不要整层套在客户端上。
3. 运行 `VanillaFixes.exe`，不要直接开 `WoW.exe`。它会先打上修复，再启动游戏，并按 `dlls.txt` 加载这三个 DLL：

   ```
   DLL\nampower.dll
   DLL\SuperWoWhook.dll
   DLL\UnitXP_SP3.dll
   ```

## 内容

| 文件 | 日期 | 作用 | 原作者 |
|---|---|---|---|
| `VanillaFixes.exe` | 2024-09-13 | 启动器。给客户端打修复后再进游戏 | VanillaFixes |
| `VfPatcher.dll` | 2024-09-13 | VanillaFixes 用来打补丁的库，必须和 exe 放在一起 | VanillaFixes |
| `DLL/nampower.dll` | 2026-06-15 | 法术队列、施法手感，以及给插件用的施法事件 | Nampower |
| `DLL/SuperWoWhook.dll` | 2026-07-16 | 给插件提供 GUID、鼠标指向等接口 | balake |
| `DLL/UnitXP_SP3.dll` | 2026-03-29 | 姓名板距离、镜头、选中最近的敌人 | allfox |

配套设置插件：

| 文件夹 | 怎么开 |
|---|---|
| `Interface/AddOns/NampowerSettings` | 检测到 Nampower 后才出现。可调排队法术图标和网络相关参数 |
| `Interface/AddOns/SuperAPI` | 右键小地图上的书本图标。作者 balake |
| `Interface/AddOns/UnitXP_SP3_Addon` | `/unitxp` 或小地图按钮。作者 allfox |

SuperWoW 的发布页写在它自己的代码里：<https://github.com/balakethelock/SuperWoW/releases/tag/Release>

自写界面插件在另一个仓库：[twmoa-addons](https://github.com/ninghongju/twmoa-addons)。要一起用的话，把那个仓库里的插件文件夹也放进 `Interface/AddOns`。
