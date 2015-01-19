Pod::Spec.new do |s|
  s.name         = "ReactiveCocoa"
  s.version      = "3.0.0.alpha.1"
  s.summary      = "A framework for composing and transforming streams of values."
  s.homepage     = "https://github.com/ReactiveCocoa/ReactiveCocoa"
  s.author       = { "Josh Abernathy" => "josh@github.com" }
  s.source       = { :git => "https://github.com/fl3xman/ReactiveCocoa.git", :branch => "swift-development" }
  s.license      = 'MIT'
  s.description  = "ReactiveCocoa (RAC) is an Objective-C framework for Functional Reactive Programming. It provides APIs for composing and transforming streams of values."
  s.dependency 'LlamaKit', '~> 0.1.1'
 
  s.requires_arc = true
  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.9'
  s.compiler_flags = '-DOS_OBJECT_USE_OBJC=0'
  s.default_subspecs = 'UI'
  s.prepare_command = <<-'END'
    find . \( -regex '.*EXT.*\.[mh]$' -o -regex '.*metamacros\.[mh]$' \) -execdir mv {} RAC{} \;
    find . -regex '.*\.[hm]' -exec sed -i '' -E 's@"(EXT.*|metamacros)\.h"@"RAC\1.h"@' {} \;
    find . -regex '.*\.[hm]' -exec sed -i '' -E 's@<ReactiveCocoa/(EXT.*)\.h>@<ReactiveCocoa/RAC\1.h>@' {} \;
  END

  s.subspec 'no-arc' do |sp|
    sp.source_files = 'ReactiveCocoaFramework/ReactiveCocoa/RACObjCRuntime.{h,m}'
    sp.framework = 'Foundation'
    sp.requires_arc = false
  end

  s.subspec 'Core' do |sp|
    sp.dependency 'ReactiveCocoa/no-arc'
    sp.source_files = 'ReactiveCocoaFramework/ReactiveCocoa/**/*.{d,h,m,swift}'
    sp.private_header_files = '**/*Private.h', '**/*EXTRuntimeExtensions.h'
    sp.exclude_files = 'ReactiveCocoaFramework/ReactiveCocoa/RACObjCRuntime.{h,m}'
    sp.ios.exclude_files = '**/*{AppKit,NSControl,NSText}*'
    sp.osx.exclude_files = '**/*{UIActionSheet,UIAlertView,UIBarButtonItem,UIButton,UICollectionReusableView,UIControl,UIDatePicker,UIGestureRecognizer,UIRefreshControl,UISegmentedControl,UISlider,UIStepper,UISwitch,UITableViewCell,UITableViewHeaderFooterView,UIText}*'
    sp.header_dir = 'ReactiveCocoa'
    sp.framework = 'Foundation'
  end

  s.subspec 'UI' do |sp|
    sp.dependency 'ReactiveCocoa/Core'
    sp.framework = 'Foundation'
    sp.ios.source_files = '**/ReactiveCocoa.h','ReactiveCocoa/**/*{UIActionSheet,UIAlertView,UIBarButtonItem,UIButton,UICollectionReusableView,UIControl,UIDatePicker,UIGestureRecognizer,UIImagePicker,UIRefreshControl,UISegmentedControl,UISlider,UIStepper,UISwitch,UITableViewCell,UITableViewHeaderFooterView,UIText}*'
    sp.osx.source_files = '**/ReactiveCocoa.h','ReactiveCocoa/**/*{AppKit,NSControl,NSText,NSTable}*'
    sp.ios.framework = 'UIKit'
    sp.osx.framework = 'AppKit'
  end
end