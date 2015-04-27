pod 'AFNetworking'
pod 'SDWebImage'
pod 'Realm'
pod 'M13Checkbox'
pod 'ActionSheetPicker-3.0'
pod 'MBProgressHUD'
pod 'PPRevealSideViewController'
pod 'SWRevealViewController'
pod 'SplunkMint-iOS'
pod 'SVPullToRefresh'
pod 'ZBarSDK', '~> 1.3'

post_install do |installer_representation|
    installer_representation.project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        end
    end
end