#!/bin/bash
rm -rf gd.sh
wget https://raw.githubusercontent.com/vitaminx/TDRbackups/master/gd.sh
echo "TD网盘防翻车一键转存脚本(一转存两备份)安装配置"
read -p "请输入配置Rclone的名称后按回车键:" rclone
sed -i "s/remote/$rclone/g" gd.sh
read -p "请输入需要转存到的固定地址ID（以后每次都固定转存到该ID路径）后按回车键:" id
sed -i "s/Copyfolderid/$id/g" gd.sh
read -p "请输入备份路径1的地址ID（建议是不同域的TD盘）后按回车键:" id1
sed -i "s/Backupid1/$id1/g" gd.sh
read -p "请输入备份路径2的地址ID（建议是不同域的TD盘）后按回车键:" id2
sed -i "s/Backupid2/$id2/g" gd.sh
mkdir -p ~/AutoRclone/LOG/
chmod +x gd.sh
echo "请输入 ./gd.sh 使用脚本"