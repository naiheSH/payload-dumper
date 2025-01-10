@echo off
:: 设置命令行窗口为 UTF-8 编码
chcp 65001 >nul

echo 这是一个通过URL获取ROM分区镜像的工具，仅支持卡刷包URL链接
echo 由5ec1cff更改支持URL
echo 由山河尽赠佳人打包python项目并编写脚本

:menu
echo 请选择操作：

echo 1 URL获取payload.bin镜像

echo 2 执行payload.bin提取

set /p choice=请输入你的选择（1或2）：

if "%choice%"=="1" goto input_partition
if "%choice%"=="2" goto execute_payload_bin
echo 错误：无效的选择，请重新输入。
goto menu

:input_partition
:: 获取用户输入分区
set /p partition=请输入你的分区（如：boot,init_boot,recovery，多分区请用逗号分隔）：

:: 检查分区输入是否为空
if "%partition%"=="" (
    echo 错误：分区不能为空，请重新输入。
    goto input_partition
)

:input_url
:: 获取用户输入URL
set /p url=请输入你的URL：

:: 检查URL输入是否为空
if "%url%"=="" (
    echo 错误：URL不能为空，请重新输入。
    goto input_url
)

set exe_path="bin\payload_dumper.exe"
:: 设置输出目录为当前目录下的output文件夹
set output_dir="%cd%\output"

:: 检查输出目录是否存在并创建
if not exist %output_dir% (
    echo 目标目录不存在，正在创建目录...
    mkdir %output_dir% 2>nul
    if errorlevel 1 (
        echo 错误：创建目录失败，请检查权限。
        exit /b 1
    )
)

:: 构建并执行命令（加引号防止路径中有空格等问题）
"%exe_path%" --partitions "%partition%" --out "%output_dir%" "%url%"
if errorlevel 1 (
    echo 错误：提取失败，请检查分区名称、URL或工具路径。
    exit /b 1
)

echo 程序执行完毕，提取的文件保存在：%output_dir%
pause
exit /b 0

:execute_payload_bin
:: 设置payload_dumper.exe的路径（注意加引号）
set exe_path="bin\payload_dumper.exe"

:: 列出payload.bin中的分区
echo 列出payload.bin中的分区：
"%exe_path%" --list payload.bin 
if errorlevel 1 (
    echo 错误：列出分区失败，请检查工具路径或payload.bin文件。
    exit /b 1
)


:input_partition
:: 获取用户输入分区
set /p partition=请输入你的分区（如：boot,init_boot,recovery，多分区请用逗号分隔）：

:: 检查分区输入是否为空
if "%partition%"=="" (
    echo 错误：分区不能为空，请重新输入。
    goto input_partition
)

:: 设置输出目录为当前目录下的output文件夹
set output_dir="%cd%\output"

:: 检查输出目录是否存在并创建
if not exist %output_dir% (
    echo 目标目录不存在，正在创建目录...
    mkdir %output_dir% 2>nul
    if errorlevel 1 (
        echo 错误：创建目录失败，请检查权限。
        exit /b 1
    )
)

:: 执行payload_dumper --partitions提取指定分区
echo 正在提取分区：%partition%
"%exe_path%" --partitions "%partition%" --out "%output_dir%" payload.bin
if errorlevel 1 (
    echo 错误：提取失败，请检查分区名称或工具路径。
    exit /b 1
)
echo
echo partitions_info.json是一个记录分区内容文件
:delete_partitions_info
:: 提示用户是否删除partitions_info.json文件
set /p delete_info_choice=是否删除output文件夹中的partitions_info.json文件？（y/n）：
if /i "%delete_info_choice%"=="y" (
    if exist "%output_dir%\partitions_info.json" (
        del "%output_dir%\partitions_info.json"
        echo partitions_info.json文件已删除。
    ) else (
        echo partitions_info.json文件不存在。
    )
) else (
    echo partitions_info.json文件保留。
)

echo
:delete_payload_bin
:: 提示用户是否删除payload.bin文件
set /p delete_choice=是否删除payload.bin文件？（y/n）：
if /i "%delete_choice%"=="y" (
    if exist payload.bin (
        del payload.bin
        echo payload.bin文件已删除。
    ) else (
        echo payload.bin文件不存在。
    )
) else (
    echo payload.bin文件保留。
)
echo 程序执行完毕，提取的文件保存在：%output_dir%
pause
exit /b 0