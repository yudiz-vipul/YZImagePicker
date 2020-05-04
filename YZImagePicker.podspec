Pod::Spec.new do |s|
  s.name                    = 'YZImagePicker'
  s.version                 = '0.1.1'
  s.summary                 = 'YZImagePicker is design and developed for Yudiz Solutions Pvt. Ltd.'
  s.description             = <<-DESC
  "YZImagePicker is useful for Junior iOS developer and trainee, so it easy can be easy to develop application and reduce code lines."
                       DESC
  s.homepage                = 'https://github.com/yudiz-vipul/YZImagePicker'
  s.license                 = { :type => 'MIT', :file => 'LICENSE' }
  s.author                  = { 'Vipul Patel' => 'vipul.p@yudiz.in' }
  s.source                  = { :git => 'https://github.com/yudiz-vipul/YZImagePicker.git', :tag => s.version.to_s }
  s.swift_version           = '5.0'
  s.ios.deployment_target   = '12.0'
  s.source_files            = 'Sources/**/*.swift'
  s.dependency 'RSKImageCropper'
end
