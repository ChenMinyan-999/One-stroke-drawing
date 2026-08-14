import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:one_stroke_flower_field/app.dart';

void main() {
  testWidgets('主页面显示标题与开始按钮', (WidgetTester tester) async {
    await tester.pumpWidget(const FlowerFieldApp());

    expect(find.text('一笔花田'), findsOneWidget);
    expect(find.text('开始游戏'), findsOneWidget);
    expect(find.text('玩法说明'), findsOneWidget);
  });

  testWidgets('点击开始游戏进入选关页', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const FlowerFieldApp());
    await tester.tap(find.text('开始游戏'));
    await tester.pumpAndSettle();

    expect(find.text('选择关卡'), findsOneWidget);
    expect(find.text('第 1 关'), findsOneWidget);
  });
}