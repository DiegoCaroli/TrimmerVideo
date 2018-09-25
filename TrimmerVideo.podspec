Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '11.0'
s.name = "TrimmerVideo"
s.summary = "TrimmerVideo lets a user to select a portion a video."
s.requires_arc = true

# 2
s.version = "0.1.0"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Diego Caroli" => "diegocaroli+dtt@gmail.com" }

# 5 - Replace this URL with your own GitHub page's URL (from the address bar)
s.homepage = "https://github.com/DiegoCaroli/TrimmerVideo"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/DiegoCaroli/TrimmerVideo.git",
:tag => "#{s.version}" }

# 7
s.framework = "UIKit"
s.framework = "AVFoundation"

# 8
s.source_files = "TrimmerVideo/**/*.{swift}"

# 9
s.resources = "TrimmerVideo/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"

# 10
s.swift_version = "4.2"

end
