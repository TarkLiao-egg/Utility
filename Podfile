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
  pod 'Alamofire'
  pod 'GRDB.swift', '~> 5.26.0' 

#  pod 'Moya', '~> 15.0.0'
#  pod 'Moya/Combine', '~> 15.0.0'
#  pod 'Alamofire', '~> 5.0.0'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
    end
  end
end
