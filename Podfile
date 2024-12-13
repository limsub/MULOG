# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
            end
        end
    end
end
# 출처: https://thoonk.tistory.com/103 [thoonk's record:티스토리]


target 'MyMusicDiary' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MyMusicDiary
  pod 'FSPagerView'

end
