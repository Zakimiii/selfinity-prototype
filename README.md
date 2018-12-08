# Selfinity

[![Language](https://img.shields.io/badge/language-swift-orange.svg?style=flat)](https://developer.apple.com/swift)
[![Swift](https://img.shields.io/badge/Swift-4.0-orange.svg)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-10.0-blue.svg)](https://developer.apple.com/xcode)
[![Platform](https://img.shields.io/cocoapods/p/TabPageViewController.svg?style=flat)](http://cocoapods.org/pods/TabPageViewController)

## Environment
|項目|設定|
|----|----|
|対応OS ver.|iOS 10.0〜|
|対応端末| SE, 6s, 7, 7s, 8, X |
|言語|Swift 4.0|
|バックエンド|FireBase| 
|デバイス|iPhone|
|アーキテクチャ|Clean Architecture|
|UI設計|Storyboard|


## Set up

### CocoaPods

CocoaPodsは端末にインストールされている前提で進めます。
インストールがまだの方は[こちら](http://qiita.com/satoken0417/items/479bcdf91cff2634ffb1)からインストールしてください<br>


```
$ cd /path/to/project

$ pod install
```

<br>

### R.swift

ビルドして下記のパスにあるR.generated.swiftを追加してください。
/Users/＊＊＊/appName/R.generated.swift

<br>

### Firebase

自身のgoogleアカウントでFirebaseに登録し、projectを作成しそのprojectにこのiosアプリを導入してください。
Firebase連携がまだの方は[こちら](https://firebase.google.com/docs/ios/setup?hl=ja)から試してください<br>

また**GoogleService-Staging-Info.plist**と命名して、Firebase連携させればStagingスキーマも起動しますのでお試してくださいませ。


### Locale

 以下のパスにあるStrings Fileを使用してください。
 
 /Users/＊＊＊/appName/selfinity/Util/en.lproj/Localizable.strings
 
 <br>

/Users/＊＊＊/appName/selfinity/Util/ja.lproj/Localizable.strings


<br>


文字列をUIに出力する際はLocalizable.stringsにkey-valueを追加してあることを確認して以下のコマンドで出力してください。


```
R.string.localizable."\(key)"
```


<br>


対応できる言語の数はDjango APIの対応言語数に準拠します。理由としては言語の因果関係抽出をDjango APIが行うため、非対応の言語が来ることはDjango APIが対応していないためです。


## Arichtecture and Coding Rules

### Clean Architecture + MVVC + RxSwift

**今回のProjectではMVVC + Clean Architecture を採用しています**。RxSwiftに関しては非同期処理やその他イベントのObserve Pattern に一部導入していますので、基本的にはProtocolによる実装が中心です。
役割を Class と Protocol で明確に分けることで、 Class と Protocol をコンポーネント指向とプロトコル指向による再利用を可能にしています。

![](https://camo.qiitausercontent.com/d42637dd903e451f6eedd267dd19ab21ee442324/68747470733a2f2f71696974612d696d6167652d73746f72652e73332e616d617a6f6e6177732e636f6d2f302f3133373132362f66623631393232622d613363392d303233392d643933612d3631313731376163616462662e6a706567)


### Component Orientation in UI

UIはStoryBoardで組み立てています。**しかし、中心となるのはUITableView,UICollectionViewです。主にこの２つのみでUIを作成することで、メモリの最小化を心がけています。また部分ごとにCustom View, Custom Cellをnibでコンポーネント的に作成し使い回すことで、UIをコンポーネント指向で作成しています。こうすることでUIの一貫性と再現性を図っています。**


### Don't use magic number and string

**このアプリでは安定的な動作を保つために不安定なコードを書くことを原則として禁止とします**。
文字列などはR.generate.swiftに定義されるものを使う、それ以外の場合はConstant StructにModule化して使用してください。

またMagic number防止のためenumを多用して、Magic numberに常に意味のあるkeyをセットしてください。

### Enum for UITableView and UICollectionView

**このアプリではenumによるUITableViewとUICollectionViewを安全にcodingすることを原則とします**。enumとUITableView,UICollectionViewは非常に相性もよく安全性が高くなる、かつReadable Source Codeに近づけるため、enumによるUITableViewとUICollectionViewのCodingを中心としたUI作成に励んでくださいませ。



<br>


またUIにはRxSwiftによるObserve Pattern を使用することを避けています。理由としては、RxSwiftはライブラリー依存性が高いため、UIの自由度を妨げる可能性があると考えたためです。Protocol-Delegate Pattern が多用されていますが、安全性を優先しましょう。Observe PatternはData, Domain層で使用しています。理由としては、Firebase がObserve Patternであるため相性が良いと考えたためです。しかし、Data-Domain-UIへの接続はProtocol-Delegate Patternで行っております。**またDataの処理をObserve Patternで管理することで、適切かつ安全なタイミングでAPIへのRequestを行い、iOSアプリとは非同期でFireBaseとAPIの通信を行うことができるため、Data処理は非同期的Observe Patternを使用しましょう。**
