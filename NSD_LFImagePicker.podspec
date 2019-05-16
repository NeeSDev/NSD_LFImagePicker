Pod::Spec.new do |s|
  s.name         = 'NSD_LFImagePicker'
  s.version      = '0.0.2'
  s.summary      = 'A clone of UIImagePickerController, support picking multiple photos、 video and edit photo'
  s.homepage     = 'https://github.com/NeeSDev/NSD_LFImagePicker'
  s.license      = 'MIT'
  s.author       = { 'NeeSDev' => 'niwei.develop@gmail.com' }
  s.platform     = :ios
  s.ios.deployment_target = '7.0'
  s.source       = { :git => 'https://github.com/NeeSDev/NSD_LFImagePicker.git', :tag => s.version, :submodules => true }
  s.requires_arc = true
  s.default_subspec = 'LFImagePickerController'

  s.subspec 'LFImagePickerController' do |ss|
    ss.resources    = 'LFImagePickerController/LFImagePickerController/class/*.bundle'
    ss.source_files = 'LFImagePickerController/LFImagePickerController/class/*.{h,m}','LFImagePickerController/LFImagePickerController/class/**/*.{h,m}'
    ss.public_header_files = 'LFImagePickerController/LFImagePickerController/class/*.h','LFImagePickerController/LFImagePickerController/class/**/*.h'
    ss.dependency 'NSD_LFImagePicker/LFGifPlayer'
    ss.dependency 'NSD_LFImagePicker/LFToGIF'
  end

  # LFGifPlayer模块
  s.subspec 'LFGifPlayer' do |ss|
    ss.source_files = 'LFImagePickerController/LFImagePickerController/vendors/LFGifPlayer/*.{h,m}'
    ss.public_header_files = 'LFImagePickerController/LFImagePickerController/vendors/LFGifPlayer/*.h'
  end

  # LFToGIF模块
  s.subspec 'LFToGIF' do |ss|
    ss.source_files = 'LFImagePickerController/LFImagePickerController/vendors/LFToGIF/*.{h,m}'
    ss.public_header_files = 'LFImagePickerController/LFImagePickerController/vendors/LFToGIF/*.h'
  end

  s.subspec 'LFMediaEditingController' do |ss|
    # LFPhotoEditingController模块
    ss.subspec 'LFPhotoEditingController' do |sss|
      sss.resources    = 'LFMediaEditingController/class/common/*.bundle'
      sss.source_files = 'LFMediaEditingController/class/*.{h,m}','LFMediaEditingController/class/LFPhotoEditingController/**/*.{h,m}','LFMediaEditingController/class/common/**/*.{h,m}'
      sss.public_header_files = 'LFMediaEditingController/class/*.h','LFMediaEditingController/class/LFPhotoEditingController/**/*.h','LFMediaEditingController/class/common/**/*.h'
      sss.dependency 'NSD_LFImagePicker/JRPickColorView'
      sss.dependency 'NSD_LFImagePicker/JRFilterBar'
      sss.dependency 'NSD_LFImagePicker/LFColorMatrix'
      sss.dependency 'NSD_LFImagePicker/LFFilterSuite'
    end

    # LFVideoEditingController模块
    ss.subspec 'LFVideoEditingController' do |sss|
      sss.resources    = 'LFMediaEditingController/class/common/*.bundle'
      sss.source_files = 'LFMediaEditingController/class/*.{h,m}','LFMediaEditingController/class/LFVideoEditingController/**/*.{h,m}','LFMediaEditingController/class/common/**/*.{h,m}','LFMediaEditingController/class/LFPhotoEditingController/view/model/*.{h,m}','LFMediaEditingController/class/LFPhotoEditingController/view/other/**/*.{h,m}','LFMediaEditingController/class/LFPhotoEditingController/view/subView/*.{h,m}','LFMediaEditingController/class/LFPhotoEditingController/view/toolBar/*.{h,m}'
      sss.public_header_files = 'LFMediaEditingController/class/*.h','LFMediaEditingController/class/LFVideoEditingController/**/*.h','LFMediaEditingController/class/common/**/*.h','LFMediaEditingController/class/LFPhotoEditingController/view/model/*.h','LFMediaEditingController/class/LFPhotoEditingController/view/other/**/*.h','LFMediaEditingController/class/LFPhotoEditingController/view/subView/*.h','LFMediaEditingController/class/LFPhotoEditingController/view/toolBar/*.h'
      sss.dependency 'NSD_LFImagePicker/JRPickColorView'
      sss.dependency 'NSD_LFImagePicker/JRFilterBar'
      sss.dependency 'NSD_LFImagePicker/LFColorMatrix'
      sss.dependency 'NSD_LFImagePicker/LFFilterSuite'
    end
  end

  # JRPickColorView模块
  s.subspec 'JRPickColorView' do |ss|
    ss.source_files = 'LFMediaEditingController/class/vendors/JRPickColorView/*.{h,m}'
    ss.public_header_files = 'LFMediaEditingController/class/vendors/JRPickColorView/*.h'
  end

  # JRFilterBar模块
  s.subspec 'JRFilterBar' do |ss|
    ss.source_files = 'LFMediaEditingController/class/vendors/JRFilterBar/*.{h,m}','LFMediaEditingController/class/vendors/JRFilterBar/**/*.{h,m}'
    ss.public_header_files = 'LFMediaEditingController/class/vendors/JRFilterBar/*.h','LFMediaEditingController/class/vendors/JRFilterBar/**/*.h'
  end

  # LFColorMatrix模块
  s.subspec 'LFColorMatrix' do |ss|
    ss.source_files = 'LFMediaEditingController/class/vendors/ColorMatrix/*.{h,m}'
    ss.public_header_files = 'LFMediaEditingController/class/vendors/ColorMatrix/*.h'
  end

  # LFFilterSuite模块
  s.subspec 'LFFilterSuite' do |ss|
    ss.source_files = 'LFMediaEditingController/class/vendors/LFFilterSuite/*.{h,m}','LFMediaEditingController/class/vendors/LFFilterSuite/**/*.{h,m}'
    ss.public_header_files = 'LFMediaEditingController/class/vendors/LFFilterSuite/*.h','LFMediaEditingController/class/vendors/LFFilterSuite/**/*.h'
  end

  # LFMediaEdit模块
  s.subspec 'LFMediaPickerAndEdit' do |ss|
    ss.xcconfig = {
        'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) LF_MEDIAEDIT=1'
    }
    ss.dependency 'NSD_LFImagePicker/LFImagePickerController'
    ss.dependency 'NSD_LFImagePicker/LFMediaEditingController'
  end


end