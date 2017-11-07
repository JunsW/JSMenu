Pod::Spec.new do |s|

  s.name         = "JSPopoverMenu"
  s.version      = "0.1.1"
  s.summary      = "A short description of JSPopoverMenu."
  s.description  = <<-DESC 
  Popover MenuView Menu
                   DESC
  s.homepage     = "https://github.com/DevNewbee/JSPopoverMenu"
  s.license      = { :type => "MIT", :file => "LICENSE" }


  s.author             = { "DevNewbee" => "wjunshuo@qq.com" }
  
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/DevNewbee/JSPopoverMenu.git", :tag => "0.1.1" }
  s.source_files  = "{swift}"


  s.requires_arc = true
end
