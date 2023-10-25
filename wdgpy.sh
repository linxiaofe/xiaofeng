#!/bin/bash

# 设置要保存信号强度、电量、音量、屏幕亮度、关机时间、蓝牙状态和音频播放状态数据的文件路径
output_file="/sdcard/signal_energy_brightness_shutdown_data.log"

while true; do
    # 获取当前时间戳
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")

    # 使用iwconfig命令获取WiFi接口的信号强度，并提取信号强度值
    signal_strength=$(iwconfig wlan0 | grep "Signal level" | awk '{print $4}' | cut -d "=" -f 2)

    # 从/sys/class/power_supply目录中读取电量信息
    battery_capacity=$(cat /sys/class/power_supply/battery/capacity)
    battery_status=$(cat /sys/class/power_supply/battery/status)

    # 获取音量
    volume=$(amixer get Master | grep "Front Left:" | awk '{print $5}' | tr -d '[]%')

    # 获取屏幕亮度，可以使用命令查看屏幕路径cd/sys/class/backlight/backlight，ls
    brightness=$(cat /sys/class/backlight/acpi_video0/brightness)

    # 使用bluetoothctl命令行工具获取蓝牙状态
    bluetooth_status=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')

    # 使用pactl命令行工具检查系统是否正在播放音频，可以使用amixer scontrols命令查看音量控制器
    audio_status=$(pactl list sinks | grep "State: RUNNING" | awk '{print $2}')

    # 输出信号强度、电量、音量、屏幕亮度、关机时间、蓝牙状态和音频播放状态信息到文件
    echo "Signal Strength: $signal_strength dBm, Battery Capacity: $battery_capacity%, Battery Status: $battery_status, Volume: $volume%, Brightness: $brightness, Bluetooth Status: $bluetooth_status, Audio Status: $audio_status, Shutdown Time: $timestamp" >> "$output_file"

    # 输出信号强度、电量、音量和屏幕亮度信息到终端
    echo "当前信号强度: $signal_strength dBm"
    echo "当前电量信息: $battery_capacity%, $battery_status"
    echo "当前音量: $volume%"
    echo "当前屏幕亮度: $brightness"
    echo "当前蓝牙状态: $bluetooth_status"
    echo "当前音频状态: $audio_status"
    echo " "

    # 检查电量状态，如果电量低于某个阈值（根据需要自行更改阈值），执行关机操作
    #low_battery_threshold=0
    #if [ "$battery_status" == "Discharging" ] && [ "$battery_capacity" -lt "$low_battery_threshold" ]; then
    #    echo "电量过低，系统将在600秒后关机..."
    #    sleep 600
    #    shutdown -h now
    #fi

    # 等待30秒
    sleep 30
done