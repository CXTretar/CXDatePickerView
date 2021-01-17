
Pod::Spec.new do |s|

s.name         = "CXDatePickerView"
s.version      = "0.2.5"
s.summary      = "CXDatePickerView"

s.description  = <<-DESC
This is a custom date picker view that provides a number of modifiable UI interfaces.
DESC

s.homepage     = "https://github.com/CXTretar/CXDatePickerView"
s.license      = "MIT"

s.author       = { "CXTretar" => "misscxuan@163.com" }

s.platform     = :ios, "8.0"

s.source       = { :git => "https://github.com/CXTretar/CXDatePickerView.git", :tag => s.version.to_s }

s.source_files  = "CXDatePickerView/CXDatePickerView/*.{h,m}"

s.requires_arc = true

end
