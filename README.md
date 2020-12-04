# 更多定制功能页demo, 这是一个Swift 版本

> 项目集成了`Swiftlint`
>  - 安装`Swiftlint`
>  - 若不想安装, 可以在`build phases`注释掉执行脚本

## 包含功能

- [x] 已选、可选展示  
- [x] 已选区域编辑顺序  
- [x] 可选区域分组为空时隐藏该组  
- [x] 已选区组长按进入编辑状态
- [x] 添加功能时动画效果 (相邻调整为交换, 非相邻是插入)
- [x] 支持编辑状态重置
- [ ] 持久化, 编辑保存

## `Swift`知识点

- [x] `UICollectionView`和`UIScrollView`的使用, 包括: 自定义`SectionHeader/SectionFooter`, 自定义`UICollectionViewFlowLayout`, 自定义`UICollectionViewCell`
- [x] `Xib`和`Storyboard`的使用
- [x] 手势`UILongPressGestureRecognizer`
- [x] `Struct`, 关于`Struct`的使用感受, 也就是值类型和引用类型的区别, 想要体会的可以将模型切换为`class`再来感受一下
- [x] 核心动画, 添加时使用了阻尼动画`CASpringAnimation`
- [x] 多线程方案: `GCD`
- [x] 高阶函数, demo中使用了三方类库`Dollar`, 即便不用三方库, 使用`Swift`原生提供的高阶函数, 相对于我用`OC`基于`NSPredicate`实现的数据处理过程, 实现复杂度上简单的太多了, 实现代码可以忽略不计了
- [x] `JSON`->`Model`解析, demo中使用了三方库`SwiftyJSON`
- [x] 代码规范: `SwiftLint`, 相对于`OC`使用的`OCLint`灵活太多, 通过配置`.yml`来控制规则, 两种方案可选, 这里我没有使用`CocoaPods`也就意味着多人协作开发, 他人的本地环境必须要先安装`SwiftLint`, 这里相对于`OCLint`传统的持续集成流程上的区别是, 首先你必须要保证本地项目编辑可过才能提交远程仓库, 这样避免了仓库污染和不必要的提交, 想想以前的开发过程: `提交代码 -> Jenkins持续集成 -> OCLint检查 -> 构建失败 -> 本地修改 -> 提交代码 -> 构建成功交付`, 更早的将问题暴露, 省去了试错解错的过程, 提高了开发效率
- [x] 属性观察器 `willSet`和`didSet`

## 静态效果图

|   默认状态    |   编辑状态    |
|:------------:|:------------:|
| <img src="https://github.com/ShenYj/MoreFuncPageDemo/blob/main/screenshot/default.png?raw=true" width="390" height="844"/> | <img src="https://github.com/ShenYj/MoreFuncPageDemo/blob/main/screenshot/editing.png?raw=true" width="390" height="844"/> |
