
Pod::Spec.new do |s|
  s.name             = 'FlexiTooltipView'
  s.version          = '1.0.2'
  s.summary          = 'Package for custom tooltips in your application'
  s.homepage = "https://github.com/mark-kebo/FlexiTooltipView"
  s.license = { :type => "Apache License, Version 2.0", :file => "LICENSE" }
  s.authors = "Dmitry Vorozhbicki"
  s.ios.deployment_target = "12.0"
  s.source = { :git => "https://github.com/mark-kebo/FlexiTooltipView.git", :tag => "v#{s.version}" }
  s.swift_version = '5.7'
  s.cocoapods_version = '>= 1.5.0'
  s.source_files = 'Sources/FlexiTooltipView/**/*.swift'
end
