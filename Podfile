# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Utility' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Utility
  pod 'FMDB', '~> 2.7.5'
  pod 'SnapKit', '~> 5.0.0'
  pod 'lottie-ios'
  pod 'CryptoSwift'
  pod 'RxSwift', '~> 4'
  pod 'Moya/RxSwift', '~> 13.0'
  pod 'RxCocoa', '~> 4', :inhibit_warnings => true
  pod 'Alamofire', '~> 4.9.1'
  pod 'GRDB.swift'

#  pod 'Moya', '~> 15.0.0'
#  pod 'Moya/Combine', '~> 15.0.0'
#  pod 'Alamofire', '~> 5.0.0'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'RxCocoa'
      puts "Patching RxCocoa references to UIWebView"
      
      root = File.join(File.dirname(installer.pods_project.path), 'RxCocoa')
      `chflags -R nouchg #{root}`
      `grep --include=UIWebView+Rx.swift -rl '#{root}' -e "os\(iOS\)" | xargs sed -i '' 's/os(iOS)/false/'`
      `grep --include=RxWebViewDelegateProxy.swift -rl '#{root}' -e "os\(iOS\)" | xargs sed -i '' 's/os(iOS)/false/'`
      `grep --include=Deprecated.swift -rl '#{root}' -e "extension UIWebView" | xargs sed -i '' '/extension UIWebView/{N;N;N;N;N;d;}'`
    end
  end
end
