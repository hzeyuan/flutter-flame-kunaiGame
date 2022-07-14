<p align="center">
   <a href="https://imgtu.com/i/jsAqL6"><img width="96"  src="https://s1.ax1x.com/2022/07/10/jsAqL6.png" alt="Kunai Game" /></a>
</p>





-----

> ## A simple Kunai game when i learn flame.

------

#### [中文说明](https://zhuanlan.zhihu.com/p/540391836)


## screen

<a href="https://imgtu.com/i/jfkxII"><img width="200px"  src="https://s1.ax1x.com/2022/07/14/jfkxII.png" alt="jfkxII.png" border="0"></a>
<a href="https://imgtu.com/i/jfASit"><img width="200px" src="https://s1.ax1x.com/2022/07/14/jfASit.png" alt="jfASit.png" border="0"></a>
<a href="https://imgtu.com/i/jfkvdA"><img width="200x"  src="https://s1.ax1x.com/2022/07/14/jfkvdA.png" alt="jfkvdA.png" border="0"></a>
<a href="https://imgtu.com/i/jfApJP"><img width="200px"  src="https://s1.ax1x.com/2022/07/14/jfApJP.png" alt="jfApJP.png" border="0"></a>



## The game is modified on the basis of this template. [flutter game template](https://github.com/flutter/samples/tree/3a0a652984e9b974342d172b9f0ffa161d0dcb2f/game_template)




## How to install

#### Android:

- [Download apk here](https://github.com/hzeyuan/flutter-flame-kunaiGame/releases/download/v0.0.1/v0.0.1.apk)

#### macos 

first you need to install appdmg

- npm install appdmg -g

then 


```
cd installer/mdg_creator
appdmg ./config.json ./Ninja_Kunai.dmg
```




## Game Rules

- shooting Kunai onto a timber，Failed to collide with Kunai.
- each level timber  will speed up


## Main logic

Main code of the game in  **lib/src/game.dart**


- panel has a background, restIcon,BackIcon,SoundIcon sprite.

- KunaispriteComponent has shooting animation, when it hit the timber, Replace with static Kunai spriteComponent.
- when gameover, a layer of image mask simulated timber broke，Kunai spriteComponent random direction drop animation
- use flame_bloc manager game state.





## Features
- support macos,andoird,ios
- sound
- music
- main menu screen
- settings
- ads (AdMob)

## todo

- game ranking
- i18


## todo

## Development

To run the app in debug mode:

```
flutter run
```

#### flutter doctor

```
] Flutter (Channel stable, 3.0.1, on macOS 12.2 21D49 darwin-arm, locale zh-Hans-CN)
[✓] Android toolchain - develop for Android devices (Android SDK version 32.1.0-rc1)
[✓] Xcode - develop for iOS and macOS (Xcode 13.3)
[✓] Chrome - develop for the web
[✓] Android Studio (version 2021.2)
[✓] VS Code (version 1.68.1)
[✓] Connected device (3 available)
```


### Screenshot 




## Thanks

- [flutter gamete mplate](https://github.com/flutter/samples/tree/3a0a652984e9b974342d172b9f0ffa161d0dcb2f/game_template)

- [flame](https://github.com/flame-engine/flame)
