# JSPopoverMenu
![Build Pass](https://img.shields.io/travis/rust-lang/rust.svg)
![Language](https://img.shields.io/badge/swift-4.0-orange.svg)

类似新浪微博首页话题管理的弹出式。 编辑更流畅。 几行代码简单易用。    
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
	platform :ios, '10.0'
	use_frameworks!

	target '<Your Target Name>' do
   		pod 'JSPopoverMenu', '~> 1.0.1' //
	end
	
### 手动
将_Source_文件夹下的两个`.swift`文件加入即可
## 使用
1.参考Demo中的`MainViewController`的调用。推荐点击`NavigationBar`的`titleView`响应    
2.需要实现`JSPopoverMenuViewDelegate`协议。获取编辑之后更新的数据以及`Cell`点击事件。
### 1. 初始化 
默认与屏幕同宽。传入的`data`是`[String]`类型，每个`String`代表着一个`Cell`。

    popoverView = PopoverMenuView(height: 120, data: defaultData) 
 
    
### 2. 委托代理
__1.设置代理__

    popoverView.delegate = self
    
    
__2.设置`baseView`。整个`PopoverView`将加载到`baseView`上__

	 var baseView: UIView { return self.view }


__3.1 获取点击事件__

    func popoverMenu(_ popoverMenu: PopoverMenuView, didSelectedAt indexPath: IndexPath) 
__3.2 获取编辑完成后的更新数据__

    func popoverMenu(_ popoverMenu: PopoverMenuView, updatedData data: [String])
    
__3.3 获取添加的新标签值__

	func popoverMenu(_ popoverMenu: PopoverMenuView, newTag value: String)
建议通过编辑完成后的数据获取，此处是编辑过程中添加完，并不是最终编辑完成数据

### 3. 显示
有两种显示方法——自动切换和手动的显示取消。
__1. 快速切换。显示的时候调用将取消，没有显示的时候调用将显示__

        popoverView.quickSwitch()

__2.1 手动显示__

        popoverView.show() { print("I'm coming") } 

__2.2 手动取消__

        popoverView.dismiss() { print("See ya") } 
### TODO
1. 除了UIKit组件自带的自定义设置，其它还不够完善
2. 使用AutoLayout
3. 添加新标签的`UITdextField`的字符限制功能还有待完善
### 使用JSPopoverView软件

![云洞](https://github.com/DevNewbee/JSPopoverMenu/blob/master/Assets/CloudHole2.png)
