# Protobuf 

## MacOS 安装 protobuf 编译器
brew install protobuf

## Xcode 添加 Protobuf 依赖库 
pod 'Protobuf', '~> 3.23.3'

## 编译 protobuf 文件
protoc xxx.proto --python_out=[outpath]

--objc_out          编译成 Objective-C 类
