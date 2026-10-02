# مريم

تطبيق Flutter عربي لإدارة المهام اليومية والعبادات وحفظ الذكريات.

## المميزات

- شاشة بداية ورسالة هدية.
- واجهة عربية RTL مع وضع داكن وفاتح محفوظين على الجهاز.
- مهام يومية قابلة للإضافة والإنجاز والحذف، مع حفظ محلي.
- أقسام العبادات والأذكار والقرآن والتسبيح.
- ذكريات مع عنوان ووصف وتاريخ وصور.
- حفظ الذكريات في Firebase Firestore مع نسخة محلية عند انقطاع الإنترنت.
- مشاركة الذكرى كصورة.
- إحصائيات وإعدادات التطبيق.

## المتطلبات

- Flutter SDK متوافق مع Dart `^3.11.5`.
- Android Studio أو Xcode حسب المنصة.
- مشروع Firebase مضبوط على Android وiOS.

## التشغيل

```bash
flutter pub get
flutter run
```

## الاختبارات والتحليل

```bash
flutter analyze
flutter test
```

## Firebase

تم توليد `lib/firebase_options.dart` من FlutterFire. قبل النشر تأكد من:

1. إضافة `GoogleService-Info.plist` إلى `ios/Runner`.
2. ضبط Firestore Security Rules.
3. عدم استخدام Collection عامة للذكريات في تطبيق إنتاجي؛ يفضل ربطها بحساب المستخدم.
4. نقل الصور الكبيرة إلى Firebase Storage بدل تخزين Base64 داخل مستند Firestore.

## ملاحظات الإصدار

إعداد توقيع Release وPackage ID النهائي يجب ضبطهما قبل رفع التطبيق إلى Google Play أو App Store.
