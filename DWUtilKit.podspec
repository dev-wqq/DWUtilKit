
Pod::Spec.new do |s|

  s.name         = "DWUtilKit"
  s.version      = "1.0.0"

  s.license      = "MIT"
  #s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.summary      = "A collection of iOS components."
  s.homepage     = "https://github.com/dev-wqq/DWUtilKit.git"
  s.author       = { "dev-wqq" => "992673618@qq.com" }
  s.source       = { :git => "https://github.com/dev-wqq/DWUtilKit.git", :tag => s.version.to_s }

  s.description  = "This library tool method to develop."

  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"

  s.requires_arc = true
  s.frameworks = "UIKit","Foundation"

  s.source_files  = "DWUtilKit/**/*.{h,m}"
  s.public_header_files = "DWUtilKit/**/*.{h}"


end
