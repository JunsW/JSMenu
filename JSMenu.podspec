Pod::Spec.new do |s|

  s.name                  = "JSMenu"
  s.version               = "1.1.1"
  s.summary               = "Popover Menu View"
  s.description           = "It's a popover view for managing tags."
  s.homepage              = "https://github.com/JunsW/JSMenu"
  s.license               = { :type => "MIT", :file => "LICENSE" }
  s.swift_version         = '4.0'

  s.author                = { "JunsW" => "wjunshuo@qq.com" }
  
  s.ios.deployment_target = '9.0'
  s.source                = { :git => "https://github.com/JunsW/JSMenu.git", :tag => "1.1.1" }
  s.source_files          = 'Source/**/*.swift','Source/Icons/*.png'


  s.requires_arc          = true
  s.framework             = "UIKit"

end
