#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint crane_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'crane_plugin'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter project.'
  s.description      = <<-DESC
A new Flutter project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.'}
  s.source_files = 'Classes/**/*'
  s.source = { :git => 'https://github.com/Unity-Technologies/unity-mediation-cocoapods-prod.git'}

#  source 'https://github.com/CocoaPods/Specs.git'
#  source 'https://github.com/Unity-Technologies/unity-mediation-cocoapods-prod.git'

  s.dependency 'Flutter'
  s.platform = :ios, '10.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  s.dependency 'UnityMediationSdk', '~> 1.0.1'
  s.dependency 'UnityMediationAdmobAdapter', '~> 1.0.0'
  s.dependency 'UnityMediationUnityAdapter', '~> 1.0.0'

  #s.dependency 'Google-Mobile-Ads-SDK'
  s.dependency 'Firebase/Analytics'

end

