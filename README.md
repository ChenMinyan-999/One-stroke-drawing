# 一笔花田

一款面向全年龄的一笔画变种解谜游戏。屏幕上是散落的花朵，用手指一笔连起所有**同色**花朵，并把最后的花连回起点形成闭环（首尾相连），连线不能交叉、不能重复经过同一朵花；连完所有颜色即可过关。

- 双端：Android / iOS（基于 Flutter）
- 纯 2D，无第三方游戏引擎，使用 `CustomPainter` 自绘
- 关卡用纯数组存储，核心判定基于简单图论（线段相交判定 + 非交叉哈密顿路径）

## 目录结构

```
lib/
  main.dart                    # 入口
  app.dart                     # MaterialApp、主题、路由
  theme/palette.dart           # 花朵颜色池与全局配色
  models/
    level.dart                 # Level / FlowerGroup 数据模型
    game_state.dart            # 一局游戏的运行时状态（一笔推进/撤销/判定）
  data/
    levels.dart                # 关卡数据（数组）
  services/
    geometry.dart              # 线段交叉判定 + 非交叉路径求解器
    progress.dart              # 关卡进度持久化（shared_preferences）
  screens/
    home_screen.dart           # 主页面
    level_select_screen.dart   # 选关页
    game_screen.dart           # 游戏页（含过关弹窗、提示/撤销/重来）
  widgets/
    flower_board.dart          # 画板：绘制 + 拖拽吸附手势
test/
  geometry_test.dart           # 几何算法单测
  levels_test.dart             # 关卡可解性校验
```

## 运行

> 本仓库当前**只包含 Dart 源码**，`android/`、`ios/` 等平台目录需要由 Flutter 生成。

前置条件：安装 Flutter SDK（3.27 及以上，Dart 3.6+），并在 Android Studio 中安装 Flutter 与 Dart 插件。

```bash
# 1. 在项目根目录生成平台工程（不会覆盖已存在的 lib/、pubspec.yaml）
flutter create --org com.example --project-name one_stroke_flower_field --platforms android,ios .

# 2. 拉取依赖
flutter pub get

# 3. 跑单测（校验关卡可解性）
flutter test

# 4. 运行到设备 / 模拟器
flutter run
```

也可以直接用 Android Studio 打开本目录，等它识别为 Flutter 项目后点 `Get dependencies`，再点运行。

> iOS 打包需要在 macOS 上执行 `flutter build ios`；代码本身双端通用，在 Windows 上可直接跑 Android。

## 玩法与交互

1. 从任意一朵未完成颜色的花开始，手指拖到**同色**的下一朵，花朵会吸附并连出一条线段。
2. 一次手势只能连同一颜色；抬手指后可换颜色继续。
3. 接续某颜色时，需从该颜色当前路径的“头部”（发光的那朵）开始。
4. 连完该颜色所有花后，需再拖回**起点那朵花**，把首尾连起来才算完成该颜色。
5. 连线一旦与已有线段交叉，本次吸附会被拒绝。
6. 顶部色块显示每组颜色的完成进度；连完所有颜色过关。

按钮：`提示`（显示虚线解）、`撤销`（退回上一步）、`重来`（重置本关）。

## 关卡数据格式

`lib/data/levels.dart` 中的每个关卡是：

```dart
Level(
  id: 1,
  name: '三角初绽',
  groups: [
    FlowerGroup(0, [          // 0 = 颜色索引，对应 Palette.flowers
      Offset(0.50, 0.30),     // 归一化坐标，0..1
      Offset(0.28, 0.72),
      Offset(0.72, 0.72),
    ]),
  ],
)
```

设计约束：单色关的花朵处于凸位置（沿外圈连线再回到起点即解），多色关各组位于互不相交区域或严格嵌套，从而保证每个颜色都存在不交叉的首尾相连闭环解。新增关卡后，`test/levels_test.dart` 会自动校验可解性。

## 核心算法

- **线段相交**：`segmentsCross` 用方向判定（`_orient` 叉积符号）判断跨立，共线重叠视为相交，共享端点不算相交。
- **可解性求解**：`solveNonCrossingCycle` 对 ≤ 8 个点暴力枚举全排列，返回第一条不交叉的哈密顿回路（首尾相连），用于“提示”与关卡校验。