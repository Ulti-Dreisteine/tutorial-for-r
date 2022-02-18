# tutorial-for-r
R入门练习

## R安装
MacOS:
1. 直接在VS Code上新建R文档, 会提示安装相关环境
2. 若安装包时报错: "无法载入共享目标对象‘...rJava.dll", 则
    * 确定JAVA的JRE路径(注意不是JDK路径)
    * 在R中设置JRE路径: Sys.setenv(JAVA_HOME='D:/jdk1.6.0_45/jre')
