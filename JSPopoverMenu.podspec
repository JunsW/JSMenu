Pod::Spec.new do |s|

  s.name         = "JSMenu"
  s.version      = "1.0.2"
  s.summary      = "Popover Menu View"
  s.description  = "It's a popover view for managing tags."
  s.homepage     = "https://github.com/DevNewbee/JSPopoverMenu"
  s.license      = { :type => "MIT", :file => "LICENSE" }


  s.author             = { "DevNewbee" => "wjunshuo@qq.com" }
  
  s.ios.deployment_target = '8.0'
  s.source       = { :git => "https://github.com/DevNewbee/JSMenu.git", :tag => "1.0.2" }
  s.source_files  = "Source/*.swift"


  s.requires_arc = true
  s.framework  = "UIKit"

end
