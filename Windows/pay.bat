@echo off
:: 设置命令行窗口为 UTF-8 编码
chcp 65001 >nul

echo 这是一个通过URL获取ROM分区镜像的工具，仅支持卡刷包URL链接
echo 由5ec1cff更改支持URL
echo 由山河尽赠佳人打包python项目并编写脚本

:: 获取用户输入分区
set /p partition=请输入你的分区（如：boot,init_boot,recovery，多分区请用逗号分隔）：

:: 检查分区输入是否为空
if "%partition%"=="" (
    echo 错误：分区不能为空，请重新运行脚本。
    pause
    exit /b
)

:: 获取用户输入URL
set /p url=请输入你的URL：

:: 检查URL输入是否为空
if "%url%"=="" (
    echo 错误：URL不能为空，请重新运行脚本。
    pause
    exit /b
)

:: 设置payload_dumper.exe的路径（注意加引号）
set exe_path="bin\payload_dumper.exe"

:: 设置输出目录为当前目录下的output文件夹
set output_dir="%cd%\output"

:: 检查输出目录是否存在，如果不存在则创建
if not exist %output_dir% (
    echo 目标目录不存在，正在创建目录...
    mkdir %output_dir%
)

:: 构建并执行命令（加引号防止路径中有空格等问题）
echo 执行命令：%exe_path% --partitions "%partition%" --out "%output_dir%" "%url%"
"%exe_path%" --partitions "%partition%" --out "%output_dir%" "%url%"

:: 检查命令是否执行成功
if errorlevel 1 (
    echo 错误：提取失败，请检查分区名称、URL 或工具路径。
    pause
    exit /b
)

echo 程序执行完毕，提取的文件保存在：%output_dir%
pause