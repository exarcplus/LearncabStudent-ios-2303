# Uncomment the next line to define a global platform for your project
#platform :ios, '12.1'

target 'LearnCab' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for LearnCab

pod 'ActionSheetPicker-3.0'
pod 'IQKeyboardManager', '3.3.7'
pod 'LGSideMenuController', '~> 1.0.0'
pod 'ZRScrollableTabBar'
pod 'AFNetworking', '~> 3.0'
pod 'KKActionSheet'
pod 'Alamofire', '~> 4.5'
pod 'SVProgressHUD'
pod 'FBSDKCoreKit'
pod 'FBSDKLoginKit'
pod 'FBSDKShareKit'
pod 'GoogleSignIn'
pod 'Firebase/Core'
pod 'Firebase/Messaging'
pod 'Firebase/Crash'
pod 'KGModal', '~> 0.0.1'
pod 'SDWebImage', '~>3.8'
pod 'Graph', '~> 2.0'
pod 'GoneVisible'
pod 'SKPhotoBrowser'
pod 'razorpay-pod', '1.0.26'
pod 'YNExpandableCell'
pod 'FZAccordionTableView', '~> 0.2.2'
pod 'Pageboy', '~> 2.0'
pod 'DropDown'
pod 'ZoomImageView'
pod 'ScrollableGraphView', '~> 4.0.6'
pod 'WOWCardStackView'
pod 'Brightcove-Player-SDK-Player-UI/dynamic'
pod 'Fabric'
pod 'Crashlytics'
pod 'Siren'
end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end
