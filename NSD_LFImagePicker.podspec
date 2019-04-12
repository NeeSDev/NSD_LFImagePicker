Pod::Spec.new do |s|
  s.name         = 'NSD_LFImagePicker'
  s.version      = '0.0.1'
  s.summary      = 'A clone of UIImagePickerController, support picking multiple photos、 video and edit photo'
  s.homepage     = 'https://github.com/NeeSDev/NSD_LFImagePicker'
  s.license      = 'MIT'
  s.author       = { 'NeeSDev' => 'niwei.develop@gmail.com' }
  s.platform     = :ios
  s.ios.deployment_target = '7.0'
  s.source       = { :git => 'https://github.com/NeeSDev/NSD_LFImagePicker.git', :tag => s.version, :submodules => true }
  s.requires_arc = true
  s.default_subspec = 'Core'

  s.subspec 'Core' do |ss|
    ss.resources    = 'LFImagePickerController/LFImagePickerController/class/*.bundle'
    ss.source_files = 'LFImagePickerController/LFImagePickerController/class/*.{h,m}','LFImagePickerController/LFImagePickerController/class/**/*.{h,m}'
    ss.public_header_files = 'LFImagePickerController/LFImagePickerController/class/*.h','LFImagePickerController/LFImagePickerController/class/manager/*.h','LFImagePickerController/LFImagePickerController/class/model/*.h','LFImagePickerController/LFImagePickerController/class/model/**/*.h','LFImagePickerController/LFImagePickerController/class/define/LFImagePickerPublicHeader.h'
    ss.dependency 'NSD_LFImagePicker/LFGifPlayer'
    ss.dependency 'NSD_LFImagePicker/LFToGIF'
  end

  # LFGifPlayer模块
  s.subspec 'LFGifPlayer' do |ss|
    ss.source_files = 'LFImagePickerController/LFImagePickerController/vendors/LFGifPlayer/*.{h,m}'
    ss.public_header_files = 'LFImagePickerController/LFImagePickerController/vendors/LFGifPlayer/LFGifPlayerManager.h'
  end

  # LFToGIF模块
  s.subspec 'LFToGIF' do |ss|
    ss.source_files = 'LFImagePickerController/LFImagePickerController/vendors/LFToGIF/*.{h,m}'
    ss.public_header_files = 'LFImagePickerController/LFImagePickerController/vendors/LFToGIF/LFToGIF.h'
  end

  # LFMediaEdit模块
  s.subspec 'LFMediaEdit' do |ss|
    ss.xcconfig = {
        'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) LF_MEDIAEDIT=1'
    }
    ss.dependency 'NSD_LFImagePicker/Core'
    ss.dependency 'LFMediaEditingController'
  end

end