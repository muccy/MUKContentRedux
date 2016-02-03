Pod::Spec.new do |s|
  s.name             = "MUKContentRedux"
  s.version          = "1.2.0"
  s.summary          = "A structure to store content data in an immutable way using input actions."
  s.description      = <<-DESC
                        A store for immutable data which can be updated only applying actions. Inspired by ReSwift but very very less ambitious.
                       DESC
  s.homepage         = "https://github.com/muccy/#{s.name}"
  s.license          = 'MIT'
  s.author           = { "Marco Muccinelli" => "muccymac@gmail.com" }
  s.source           = { :git => "https://github.com/muccy/#{s.name}.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/**/*.{h,m}'
end
