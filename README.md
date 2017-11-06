# JSAlertLabel
![Build Pass](https://img.shields.io/travis/rust-lang/rust.svg)
![Language](https://img.shields.io/badge/swift-4.0-orange.svg)

如新浪微博首页话题管理的弹出式`CollectionView`。  
点击`编辑`按钮，进入编辑模式，拖动排序，拖动到垃圾桶标志上自动将`Cell`放到队尾待删除区域，点击完成确认删除，点击复原撤销编辑。
点击待删除区域的某个`Cell`会将其放回原来的位置。

## 示例

![Demo](https://github.com/DevNewbee/JSPopoverMenu/blob/master/Demo.gif)

## 使用
1.参考Demo中的`MainViewController`的调用。推荐点击`NavigationBar`的`titleView`响应
2.需要实现`JSPopoverMenuViewDelegate`协议。获取编辑之后更新的数据以及`Cell`点击事件。
### 1. 初始化 
默认与屏幕同宽。传入的`Data`是`[String]`类型，每个`String`代表着一个`Cell`。

    popoverView = PopoverMenuView(height: 120, data: defaultData) 
 
    
### 2. 委托代理
1.设置代理 

    popoverView.delegate = self
    
    
2.设置`baseView`。整个`PopoverView`将加载到`baseView`上

	 var baseView: UIView { return self.view }


3.1 获取点击事件

    func popoverMenu(_ popoverMenu: PopoverMenuView, didSelectedAt indexPath: IndexPath) 
3.2 获取编辑完成后的更新数据

    func popoverMenu(_ popoverMenu: PopoverMenuView, updatedData data: [String])
### 3. 显示
1. 快速切换。显示的时候调用将取消，没有显示的时候调用将显示

        popoverView.quickSwitch()

2. 手动显示

        public func show(completion closure: (()->Void)?)

3. 手动取消

        public func dismiss(completion closure: (()->Void)?) 
