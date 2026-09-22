
platform :ios, '15.0'
use_modular_headers!
target 'mancry_Jan' do

pod 'Toast-Swift'
pod 'Alamofire'
pod 'KeyboardMan'
pod 'IQKeyboardManagerSwift'
pod 'SDWebImage'
pod 'PKHUD'
pod 'SnapKit'
pod 'SystemServices'
pod 'Adjust', '~> 5.4.4'
# 官方 HandyJSON 在 Xcode 15.3+/26 Archive 会触发 Swift 编译器崩溃
pod 'HandyJSON', :git => 'https://github.com/Miles-Matheson/HandyJSON.git'

end

# --- added by ios-ci-setup ---

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
      config.build_settings['PROVISIONING_PROFILE_SPECIFIER'] = ''
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      if target.name == 'HandyJSON'
        config.build_settings['SWIFT_COMPILATION_MODE'] = 'incremental'
        config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Onone'
      end
    end
  end
end
