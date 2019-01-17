---
title: "如何使用 Enterprise Architect 画 UML"
layout: post
category: [Tools]
tags: [uml]
excerpt: "EA 的英文全称叫 Enterprise Architect，是由澳大利亚公司 Sparx Systems 开发的一款基于 OMG UML 的可视化模型与设计工具，提供了对软件系统的设计和构建、业务流程建模和基于领域建模的支持，被企业和组织不仅应用于对系统的建模，还用于推进模型在整个应用程序开发周期中实现。"
---

#如何使用 Enterprise Architect 画 UML

### 重识 EA (Enterprise Architect)
公司使用的 OMS 是从外面买过来后进行二次开发的，而对方给到的技术文档不够全面，有很大部分的业务细节需要自己看代码梳理。想起来之前 IBM Developer 看过一篇关于[ Tomcat 原理](https://www.ibm.com/developerworks/cn/java/j-lo-tomcat1/index.html)的文章，文章里面用到了很多建模语言（UML）去描述代码逻辑结构。这不仅看起来高大上而且逻辑清晰易懂，就想着将上学那会学的 UML 重新捡起来，学着用 UML 去梳理代码逻辑。

记得上学那会写 UML 的工具叫 EA ，这两天我就给扒拉出来重新装上又学了一遍。下面就讲下 EA 的使用

### EA 简介
EA 的英文全称叫 Enterprise Architect，是由澳大利亚公司 Sparx Systems 开发的一款基于 OMG UML 的可视化模型与设计工具，提供了对软件系统的设计和构建、业务流程建模和基于领域建模的支持，被企业和组织不仅应用于对系统的建模，还用于推进模型在整个应用程序开发周期中实现。不是我们玩游戏的那个 EA 哦！在官网的文档中还有看到 EA 可以跟 Eclipse 做无缝的对接，很可惜的是没有找到有跟 IDEA 相关的。

### EA 安装下载
安装 EA 其实很简单，Windows 系统在[官网下载](https://sparxsystems.com/products/ea/trial/request.html)下来后直接下一步下一步即可。但是 EA 是需要付费的，当然你也可以选择教学版的或者免费试用30天，这里我给大家提供一个密钥：
```
834735814236
```
这个 Key 目前本人在使用，我的 EA 版本是 14.0.1422。

我之前安装的时候被我不小心跳过了输入密钥的环节，因为英文不好后来找输入密钥的窗口找了很久，这里记录下方便遇到跟我一样问题的朋友参考。

点击左上角Start --> Help --> Register and Manage Your License Keys --> 在输入框中输入 key。
![](https://raw.githubusercontent.com/fantasylion/fantasylion.github.io/master/images/find_register_key_step1.jpg)

在弹出的输入框中输入key，我这里窗口 title 显示 Upgrade Key 应该是因为我已经注册过 key 的原因
![](https://raw.githubusercontent.com/fantasylion/fantasylion.github.io/master/images/find_register_key_step2.jpg)

### EA 的使用
既然 EA 是 UML 的可视化模型与设计工具，当然是支持 UML 常见的模型，但是目前我也是刚开始使用 UML 这里只记录下怎么画用例模型中的时序图。

常见 UML 模型

*	业务过程模型
*	用例模型
*	动态模型
*	逻辑模型
*	组件模型
*	物理模型

在 EA 安装完成后运行 EA，首先看到的应该是一张 Start Page。
![](https://raw.githubusercontent.com/fantasylion/fantasylion.github.io/master/images/EA_start_page.png)

如上图所示，正常打开后分这么几个区域，最上方显示的是各种功能选项下方一般有多个区域可以通过拖动自定义摆放位置。 图中最左边的 Toolbox 是模型的工具栏主要放置当前编辑模型的组件，中间大块的是编辑区以选项卡的方式呈现可以在最下方点击不同选项卡切换编辑区，右边数来第二个区域显示了三个模块 Diagram Properties 、 Resources 、 Project Browser 也是通过选项卡的方式呈现，最后一个 Portals 可以显示指南书、学习、状态查询......

#### 创建一个项目

点击编辑区 Start Page 选项卡中的 New File 选项，在选择项目目录输入文件名点击保存。或者在最上方区域的左上角点击 EA 图标后点击 New Project 创建一个新的项目。

在项目创建成功后开始创建 Model ，点击最上方区域右下角栅格式的图标 -> 点击 Add Model 后 -> 在编辑区选择 UML 并选择相应模型（这演示我选择的是时序图 Sequence Diagrams -> Starter Sequence Diagram） -> 点击 Create Pattern(s)

步骤如下图所示
![](https://raw.githubusercontent.com/fantasylion/fantasylion.github.io/master/images/create_model_step1.jpg)

下图为编辑区操作，这里 Create Pattern(s) 按钮在图的左下角忘记圈出来了
![](https://raw.githubusercontent.com/fantasylion/fantasylion.github.io/master/images/create_model_step2.jpg)

创建 Model 成功后在 Project Browser 中可以看到已经成功创建了一个 Model (Starter Sequence Diagram)，第三级的为当前包含的组件，点击下图中画红圈选项在编辑区中将会打开 Starter Sequence Diagram 开始编辑
![](https://raw.githubusercontent.com/fantasylion/fantasylion.github.io/master/images/edit_model_step1.jpg)

编辑区如下图所示
![](https://raw.githubusercontent.com/fantasylion/fantasylion.github.io/master/images/edit_model_step_2.jpg)


#### 如何编辑设计模型

将 ToolBox 中的相应的组件拖拽到编辑区中即可生成，在编辑区双击相应的主键将会弹出组件的属性框，在属性框可以修改组件名称、类型、结构等属性，这里就不做详细的记录。


#### 如何将编辑完的模型导出图片

点击最上方区域的 Publish 选项 -> Image -> Save to File 写好图片名和格式保存到相应目录中，或者选择 Save to clipboard 保存到粘贴板中。

如下图：
![](https://raw.githubusercontent.com/fantasylion/fantasylion.github.io/master/images/pubish_step1.jpg)

### 最后展示下最终的成果

![](https://raw.githubusercontent.com/fantasylion/fantasylion.github.io/master/images/publish_step2.png)

