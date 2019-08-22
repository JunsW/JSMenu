# JSPopoverMenu
![Build Pass](https://img.shields.io/travis/rust-lang/rust.svg)
![Language](https://img.shields.io/badge/swift-4.0-orange.svg)

JSPopoverMenu is a popover tag manager view. Elegant edting mode, easy to use.  
Tap the __Edit__ button at the top right to start edit mode and then this button will change to __Done__.   
To move the cells, you just drag it. Moving a cell to Trashbin icon will put the cell to the end of the queue and turn the cell to gray.    
![Example1](https://github.com/DevNewbee/JSPopoverMenu/blob/master/Assets/Example1.png)  

Touch the done button at the top right to confirm deleting or those tail cells to put it back to where it was automatically. By touching the __reset__ button, you could undo all actions.

[中文](https://github.com/DevNewbee/JSPopoverMenu/blob/master/README_ch.md)  


## Demo

![Demo](https://github.com/DevNewbee/JSPopoverMenu/blob/master/Assets/Demo_en.gif)  
__Add New Tag__

![Demo](https://github.com/DevNewbee/JSPopoverMenu/blob/master/Assets/Add_en.gif)
## Installation
### [CocoaPods](http://cocoapods.org)

	source 'https://github.com/CocoaPods/Specs.git'
	platform :ios, '9.0'
	use_frameworks!

	target '<Your Target Name>' do
   		pod 'JSPopoverMenu', '~> 1.1' //
	end
	
### Manual
Download all files in _Source_ folder.
## Usage
1. Check the demo in _JSPopoverMenuDemo_. The demo is designed to show the menu view when the `titleView`, which is a `UIButton`, of the `NavigationBar` is tapped.     
2. `JSPopoverMenuViewDelegate` protocal is required to implement. 
3. `JSPopoverMenuView` is a subclass of `UIView`, so just use it like others.
### 1. Initialization 
The default width is the same as the screen. Simply use a `String` array to initialize, every single `String` represents a tag (a `Cell`) on the collection view. 

    popoverView = JSPopoverMenuView(tags: ["Sports", "Movies", "Food", "News", "Travel", "Books"]) 
 
 If you use any data model to manage tags, make your model confirm `JSTag` protocols and use the following initializer.
 
 
    let data: [JSTag] = ["Sports", "Movies", "Food", "News", "Travel", "Books"].enumerated().map(){ JSDefaultTag(id: $0, title: $1) })
    popoverView = JSPopoverMenuView(data: data) 

Check _section 4_ for more information.

### 2. Delegate
__1. Set delegate__

    popoverView.delegate = self 
    
`self` refers to a view controller in the demo. Any subclass of `UIView` is also fine.
        
__2. Set `baseView`. The entire `PopoverView` will be added to the `baseView`__

	 var baseView: UIView { return self.view } 

__3.1 Tag Tapped Event__

    func popoverMenu(_ popoverMenu: PopoverMenuView, didSelectedAt indexPath: IndexPath) 
__3.2 Edit Done Event__

    func popoverMenu(_ popoverMenu: PopoverMenuView, updatedData data: [JSTag])
    
__3.3 New Tag Inserted Event__

	func popoverMenu(_ popoverMenu: PopoverMenuView, newTag value: JSTag)
__Notice:__ This function will be invoked right after users added a new tag, which means the menu is still under the editing mode and the new tag could be delete immediately. Thus, it's better to get the final data after the editing b `func popoverMenu(_ popoverMenu: PopoverMenuView, updatedData data: [JSTag])`.

### 3. Show
There are two methods to show and dimiss the menu.  
__1. QuickSwitch.__  
Show the menu if the menu is not displayed, or dimiss it if the menu is displayed

        popoverView.quickSwitch()

__2.1 Show__

        popoverView.show() { print("I'm here") } 

__2.2 Dimiss__

        popoverView.dismiss() { print("See ya") } 
        
### 4. Data source type
A tag basically is a string, but an `id` is requried to make it unique.  
So, the PopoverMenu use a simple protocol to constraint the data model.
```
protocol JSTag {
    var title: String { get set }
    var id: Int { get set }
}
```
By default, PopoverMenu use `JSDefaultTag` as data source type.
However, if `id` means nothing to you, you can use the following initialization method to create an instance.
```
popoverView = JSPopoverMenuView(tags: ["Sports", "Movies", "Food", "News", "Travel", "Books"])
```
### 5. UI Customization
The height of `PopoverView` can be set via initilizer or `frame` property since the `PopoverView` itself is subclass of `UIView`.

```
/// Gap between header and the tag collection.
public var menuTopOffset: CGFloat = 5
/// Height of tag collection view.
public var menuHeight: CGFloat = 115
/// Height of the header tool bar.
public var headerHeight: CGFloat = 30
```

## TODO
 Convenient layout customization

