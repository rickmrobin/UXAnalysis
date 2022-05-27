#
# Be sure to run `pod lib lint UXAnalysis.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UXAnalysis'
  s.version          = '0.0.7'
  s.summary          = 'A library to capture every user action and analyse the user experience of the app.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Capture every touch events and get user analysis report to track the user experience behaviour and get the system improved by results.'

  s.homepage         = 'https://github.com/rickmrobin/UXAnalysis'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'rickmrobin' => 'Maria.Robin' }
  s.source           = { :git => 'https://github.com/rickmrobin/UXAnalysis.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.swift_versions = '4.0'
  s.source_files = 'UXAnalysis/Classes/**/*'
  s.resources = 'UXAnalysis/Assets/**/*.{xcdatamodeld}'
  s.requires_arc = true
  s.frameworks = 'UIKit', 'CoreData'
  # s.resource_bundles = {
  #   'UXAnalysis' => ['UXAnalysis/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
