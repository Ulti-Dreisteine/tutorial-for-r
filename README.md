# tutorial-for-r
R入门练习

## R安装

---

**Windows系统**:
(略)

---

**MacOS系统**:
1. 直接在VS Code上新建R文档, 会提示安装相关环境
2. 若安装包时报错: "无法载入共享目标对象‘...rJava.dll", 则
    * 确定JAVA的JRE路径(注意不是JDK路径)
    * 在R中设置JRE路径: 
        ```
        Sys.setenv(JAVA_HOME='D:/jdk1.6.0_45/jre')
        ```

---

## Java安装和卸载
R中包的安装还需要Java, 所以下面列出Java的安装和卸载方法.

---

**MacOS系统**:

Java卸载:
1. 来自StackOverflow (https://blog.csdn.net/weixin_39864261/article/details/114201149):
    ```
    sudo rm -rf /Library/Java/JavaVirtualMachines/jdk
    sudo rm -rf /Library/PreferencePanes/JavaControlPanel.prefPane
    sudo rm -rf /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin
    sudo rm -rf /Library/LaunchAgents/com.oracle.java.Java-Updater.plist
    sudo rm -rf /Library/PrivilegedHelperTools/com.oracle.java.JavaUpdateHelper
    sudo rm -rf /Library/LaunchDaemons/com.oracle.java.Helper-Tool.plist
    ```

2. 来自Java官网:

    ```
    sudo rm -fr /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin
    sudo rm -fr /Library/PreferencesPanes/JavaControlPanel.prefPane
    sudo rm -fr ~/Library/Application\ Support/Oracle/Java
    ```

Java安装:
1. 教程: https://www.cnblogs.com/dch0/p/13339132.html
2. 在Java官网上下载SDK文件并安装
3. **配置环境变量**:
    1. 打开bash文件:
    ```
    vi  ~/.bash_profile
    ```

    2. 按下"i"进入编辑模式, 写入环境变量:
    ```
    JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_144.jdk/Contents/Home
    PATH=$JAVA_HOME/bin:$PATH:.
    CLASSPATH=$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar:.
    export JAVA_HOME
    export PATH
    export CLASSPATH
    ```

    3. 刷新bash配置文件, 使环境变量生效:
    ```
    source ~/.bash_profile
    ```

    4. 查看Java安装结果:
    ```
    java -version
    ```

---
