#
# Be sure to run `pod lib lint TTCSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'TTCPay'
s.version          = '0.0.3'
s.summary          = 'TTCPay'
s.homepage         = 'https://github.com/TTCECO'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'tataufo' => 'chenchao@tataufo.com' }
s.source           = { :git => 'https://github.com/TTCECO/TTCPay_iOS.git', :tag => s.version.to_s }

s.ios.deployment_target = '9.0'

s.swift_version    = "4.1"
s.platform         = :ios
s.ios.deployment_target = '9.0'
s.frameworks = "Foundation", 'UIKit'
s.vendored_frameworks = 'TTCPay/TTCPay.framework'

s.dependency 'SwiftProtobuf', '1.2.0'
s.dependency 'CryptoSwift', '0.10.0'
s.dependency 'SwiftyRSA'
s.dependency 'Alamofire'

end
