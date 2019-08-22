# JSPopoverMenu
![Build Pass](https://img.shields.io/travis/rust-lang/rust.svg)
![Language](https://img.shields.io/badge/swift-4.0-orange.svg)

PopoverMenu是可以快速集成运用的话题，Tag管理视图。    
点击`编辑`按钮，进入编辑模式，拖动排序，拖动到垃圾桶标志上自动将`Cell`放到队尾待删除区域，`Cell`会变成灰色。    
![Example1](https://github.com/DevNewbee/JSPopoverMenu/blob/master/Assets/Example1.png)    
点击待删除区域的某个`Cell`会将其放回原来的位置。
点击完成确认删除，或者点击复原撤销全部编辑。


## 示例

![Demo](https://github.com/DevNewbee/JSPopoverMenu/blob/master/Assets/Demo_ch.gif)  
__添加新标签__

![Demo](https://github.com/DevNewbee/JSPopoverMenu/blob/master/Assets/Add_ch.gif)
## 安装
### [CocoaPods](http://cocoapods.org)

	source 'https://github.com/CocoaPods/Specs.git'
	platform :ios, '9.0'
	use_frameworks!

	target '<Your Target Name>' do
   		pod 'JSPopoverMenu', '~> 1.0.1' //
	end
	
### 手动
将_Source_文件夹下的两个`.swift`文件加入即可
## 使用
1.参考Demo中的`MainViewController`的调用。推荐点击`NavigationBar`的`titleView`响应    
2.需要实现`JSPopoverMenuViewDelegate`协议。获取编辑之后更新的数据以及`Cell`点击事件
3. `JSPopoverMenuView` 继承于 `UIView`, 所以就像使用其它`UIView`一样来使用就可以了

### 1. 初始化 
默认与屏幕同宽。传入的`tags`是`[String]`类型，每个`String`代表着一个`Cell`。

    popoverView = PopoverMenuView(tags: defaultData) 
 
如果是用数据model来管理tag，只要让model遵守`JSTag`协议提供一个`title`和`id`并调用下例初始化方法即可。更多信息请参考第4节内容。

    let data: [JSTag] = ["Sports", "Movies", "Food", "News", "Travel", "Books"].enumerated().map(){ JSDefaultTag(id: $0, title: $1) })
    popoverView = JSPopoverMenuView(data: data) 


### 2. 委托代理
__1.设置代理__

    popoverView.delegate = self
    
    
__2.设置`baseView`。整个`PopoverView`将加载到`baseView`上__

	 var baseView: UIView { return self.view }


__3.1 获取点击事件__

    func popoverMenu(_ popoverMenu: PopoverMenuView, didSelectedAt indexPath: IndexPath) 
__3.2 获取编辑完成后的更新数据__

    func popoverMenu(_ popoverMenu: PopoverMenuView, updatedData data: [JSTag])
    
__3.3 获取添加的新标签值__

	func popoverMenu(_ popoverMenu: PopoverMenuView, newTag value: JSTag)
建议通过编辑完成后的数据获取，此处是编辑过程中添加完，并不是最终编辑完成数据

### 3. 显示
有两种显示方法——自动切换和手动的显示取消。
__1. 快速切换。显示的时候调用将取消，没有显示的时候调用将显示__

        popoverView.quickSwitch()

__2.1 手动显示__

        popoverView.show() { print("I'm coming") } 

__2.2 手动取消__

        popoverView.dismiss() { print("See ya") } 

### 4. 数据类型
Tag本身只需要一个字符串类型数据即可，但是为了保证唯一性，需要提供`id`参数。
所以 PopoverMenu 采用了一个协议来实现。
```
protocol JSTag {
var title: String { get set }
var id: Int { get set }
}
```
PopoverMenu 默认使用 `JSDefaultTag` 作为数据类型。
但是如果你不是需要 `id` 的话，直接使用下例简单的字符串数组初始化方法即可。
```
popoverView = JSPopoverMenuView(tags: ["Sports", "Movies", "Food", "News", "Travel", "Books"])
```
### 5. UI 自定义
PopoverView的高度可以通过初始化的时候传入`height`参数或者 `frame` 属性来修改，因为它自身是`UIView`的子类

```
/// header 和 tag collection 之间的距离
public var menuTopOffset: CGFloat = 5
/// Tag collection view 的高度
public var menuHeight: CGFloat = 115
/// Header tool bar 的高度
public var headerHeight: CGFloat = 30
```

## TODO
更便捷多功能的UI自定义

