# JSPopoverMenu
![Build Pass](https://img.shields.io/travis/rust-lang/rust.svg)
![Language](https://img.shields.io/badge/swift-4.0-orange.svg)

JSPopoverMenu is a popover tag manager view. Elegant edting mode, easy to use.  
Tap the __Edit__ button at the top right to start edit mode and then this button will change to __Done__.   
To move the cells, you just drag it. Moving a cell to Trashbin icon will put the cell to the end of the queue and turn the cell to gray. 
![Example1](https://github.com/DevNewbee/JSPopoverMenu/blob/master/assets/Example1.png)  

Touch the done button at the top right to confirm deleting or those tail cells to put it back to where it was automatically. By touching the __reset__ button, you could undo all actions.

[中文](https://github.com/DevNewbee/JSPopoverMenu/blob/master/README_ch.png)  


## Demo

![Demo](https://github.com/DevNewbee/JSPopoverMenu/blob/master/assets/Demo_en.gif)  
__Add New Tag__

![Demo](https://github.com/DevNewbee/JSPopoverMenu/blob/master/assets/Add_en.gif)
## Installation
### [CocoaPods](http://cocoapods.org)

	source 'https://github.com/CocoaPods/Specs.git'
	platform :ios, '10.0'
	use_frameworks!

	target '<Your Target Name>' do
   		pod 'JSPopoverMenu', '~> 1.0' //
	end
	
### Manual
Download two `.swift` files in _Source_.
## Usage
1. Check the demo in _JSPopoverMenuDemo_. The demo is designed to show the menu view when the `titleView`, which is a `UIButton`, of the `NavigationBar` is tapped.     
2. `JSPopoverMenuViewDelegate` protocal is required to implement.
3. 
### 1. Initialization 
The default width is the same as the screen. So you just need to set the `height` of the menu view.
`data` is `[String]` type，every single `String` represents a tag (a `Cell`) on the collection view.

    popoverView = PopoverMenuView(height: 120, data: defaultData) 
 
    
### 2. Delegate
__1. Set delegate__

    popoverView.delegate = self
    
    
__2. Set `baseView`. The entire `PopoverView` will be added to the `baseView`__

	 var baseView: UIView { return self.view }


__3.1 Tag Tapped Event__

    func popoverMenu(_ popoverMenu: PopoverMenuView, didSelectedAt indexPath: IndexPath) 
__3.2 Edit Done Event__

    func popoverMenu(_ popoverMenu: PopoverMenuView, updatedData data: [String])
    
__3.3 New Tag Inserted Event__

	func popoverMenu(_ popoverMenu: PopoverMenuView, newTag value: String)
__Notice:__ This function will be invoked right after users added a new tag, which means the menu is still under the editing mode and the new tag could be delete immediately. Thus, it's better to get the final data after the editing by `func popoverMenu(_ popoverMenu: PopoverMenuView, updatedData data: [String])`.

### 3. Show
There are two methods to show and dimiss the menu.  
__1. QuickSwitch.__  
Show the menu if the menu is not displayed, or dimiss it if the menu is displayed

        popoverView.quickSwitch()

__2.1 Show__

        popoverView.show() { print("I'm here") } 

__2.2 Dimiss__

        popoverView.dismiss() { print("See ya") } 
### TODO
1. Using AutoLayout
2. The character validation of the `UITdextField` is too simple.  

### 使用JSPopoverView软件

![云洞](https://github.com/DevNewbee/JSPopoverMenu/blob/master/assets/CloudHole2.png)
