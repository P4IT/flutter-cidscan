#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_cidscan.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_cidscan'
  s.version          = '0.0.1'
  s.summary          = 'Flutter Plugin for CaptureID Scanner Library'
  s.description      = <<-DESC
Flutter Plugin for CaptureID Scanner Library
                       DESC
  s.homepage         = 'http://captureid.de'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'P4IT GmbH & Co. KG' => 'captureid@p4it.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
  s.requires_arc = true
  s.ios.vendored_libraries = 'libCaptureIDLibrary.a'
  s.libraries = 'CaptureIDLibrary'
  s.xcconfig = { 'HEADER_SEARCH_PATHS' => "${PODS_ROOT}/#{s.name}/libs/**" }
end
