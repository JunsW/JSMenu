Pod::Spec.new do |s|

  s.name         = "JSPopoverMenu"
  s.version      = "1.0.0"
  s.summary      = "Popover MenuView Menu"
  s.description  = "It's a popover view for managing tags."
  s.homepage     = "https://github.com/DevNewbee/JSPopoverMenu"
  s.license      = { :type => "MIT", :file => "LICENSE" }


  s.author             = { "DevNewbee" => "wjunshuo@qq.com" }
  
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/DevNewbee/JSPopoverMenu.git", :tag => "1.0.0" }
  s.source_files  = "Source/*.swift"


  s.requires_arc = true

end
