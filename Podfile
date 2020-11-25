# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'AfaqOnline' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for AfaqOnline
  pod 'SideMenu', '~> 5.0.3'
  pod 'SwiftMessages', '~> 6.0.2'
  pod 'ImageSlideshow', '~> 1.7.0'
  pod 'DLRadioButton', '~> 1.4.12'
  pod 'Parchment', '~> 2.0.1'
  pod 'Alamofire', '~> 4.8.2'
  pod 'SwiftyJSON', '~> 5.0.0'
  pod 'Kingfisher', '~> 5.4.0'
  pod 'IQKeyboardManagerSwift', '~> 6.3.0'
  pod 'SVProgressHUD', '~> 2.2.5'
  pod 'IQAudioRecorderController'
  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
  pod 'Gallery'
  pod 'FaveButton', '~> 3.2.1'
  pod 'Cosmos', '~> 21.0.0'
  pod 'RxDataSources', '~> 4.0'
  pod 'GoogleMaps', '~> 3.8.0'
  pod 'GooglePlaces', '~> 3.8.0'
  pod "FlexibleSteppedProgressBar"
  pod 'MOLH'
  pod 'DropDown', '~> 2.3.13'
  pod 'Firebase/Analytics'
  pod 'Firebase/Messaging'
  pod 'Firebase/Crashlytics'
  pod 'StepProgressBar'
  pod 'PusherSwift', '~> 8.0'
  pod 'FlagPhoneNumber'


  
  target 'AfaqOnlineTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxSwift', '~> 5'
    pod 'RxCocoa', '~> 5'
  end
  
  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings.delete('CODE_SIGNING_ALLOWED')
      config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
  end
end
