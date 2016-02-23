#
#  CDAKit
#
#  CDAKit for iOS, the Open Source Clinical Document Architecture Library with HealthKit Connectivity
#

Pod::Spec.new do |s|
  s.name         = "CDAKit"
  s.version      = "1.0"
  s.summary      = "CDAKit for iOS, the Open Source Clinical Document Architecture Library with HealthKit Connectivity."
  s.description  = <<-DESC
    Swift framework port of the the Ruby Health-Data-Standards GEM's C32 and C-CDA import and export functionality. Allows for bridging between CDA and HealthKit so you can integrate with an Electronic Medical Records system.
  DESC

  s.homepage     = "https://github.com/ewhitley/CDAKit"
  s.license      = 'Apache 2'
  s.authors      = { "Eric Whitley" => "cdakit@gmail.com" }
  s.source       = { :git => "https://github.com/ewhitley/CDAKit/cdakit.git", :tag => s.version.to_s }
  s.documentation_url = "http://ewhitley.github.io/CDAKit"

  s.platform     = :ios, '8.0'
  s.ios.deployment_target = "8.0"
  s.requires_arc = true

  s.source_files = 'CDAKit/**/*.swift'
  s.resource_bundles = {
    'CDAKit' => [
      'CDAKit/**/*.mustache',
      'CDAKit/**/CDAKitDefaultHealthKitTermMap.plist',
      'CDAKit/**/CDAKitDefaultSampleTypeIdentifierSettings.plist'
    ]
  }
  s.frameworks = 'HealthKit'
  s.dependency 'GRMustache.swift', '~> 0.11.0'
  s.dependency 'Fuzi', '0.3.0'
  s.dependency 'Try', '~> 1.0.0'
end
