#
# Be sure to run `pod lib lint PRXDownloader.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = "PRXDownloader"
s.version          = "0.0.5"
s.summary          = "A super simple thread safe downloaderydoo for iOS. MADE WITH LOVE AND PUPPIES AND MAGIC"
s.description      = <<-DESC
This project is an objc version of the downloader we use at Proxima. It's a huge work in progress. I am improving it when I can give it spare time, in the time honoured tradition of open source.


DESC
s.homepage         = "https://github.com/dannolan/PRXDownloader"
# s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
s.license          = 'MIT'
s.author           = { "Dan Nolan" => "dan@proxima.io" }
s.source           = { :git => "https://github.com/dannolan/PRXDownloader.git", :tag => s.version.to_s }
s.social_media_url = 'https://twitter.com/dannolan'

s.platform     = :ios, '8.0'
s.requires_arc = true

s.public_header_files = 'Pod/Classes/*.h'
s.source_files = 'Pod/Classes/*.{h,m}'
s.frameworks = 'Foundation', 'CoreFoundation'

end
