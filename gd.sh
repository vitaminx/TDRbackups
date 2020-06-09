#!/bin/bash
echo -e "\033[1;32m《TD网盘防翻车一键转存备份脚本.一转存两备份》\033[0m [ \033[32mv3.0\033[0m by \033[1;35mcgkings & oneking\033[0m ]"
read -p """输入分享链接并按回车键
     请输入 =>:""" link
# 检查接受到的分享链接规范性，并读取分享文件夹ID和文件夹名
if [ -z "$link" ] ;then
    echo -e "\033[32m不允许输入为空\033[0m"
    exit
else
link=${link#*id=};
link=${link#*folders/};
link=${link#*d/};
link=${link%?usp*}
id=$link
j=$(gclone lsd remote:{$id} --dump bodies -vv 2>&1 | grep '^{"id"' | grep $id) rootName=$(echo $j | grep -Po '(?<="name":")[^"]*')
check_results=`gclone size remote:{"$link"} --fast-list --size-only --no-traverse 2>&1`
	if [[ $check_results =~ "Error 404" ]]
	then
    echo -e "\033[32m链接无效，检查是否有权限\033[0m" && exit
    else
    echo "分享链接的基本信息如下："
	echo -e "分享目录名：\033[32m"$rootName"\033[0m"
	echo -e "分享目录下文件数和总大小：\033[32m"$check_results"\033[0m"
    fi
fi

echo 
echo -e "\033[32m==<<TD网盘防翻车一键转存备份脚本.转存即将开始（转存一份、备份两份、共三份），可ctrl+c中途中断>>==\033[0m"
id=$Copyfolderid
j=$(gclone lsd remote:{$id} --config="$Road" --dump bodies -vv 2>&1 | grep '^{"id"' | grep $id) CopyfolderName=$(echo $j | grep -Po '(?<="name":")[^"]*')
echo "文件将转存入分类目录："$CopyfolderName/$rootName
echo '转存日志文件将保存在：/root/AutoRclone/LOG/'"$rootName"'.txt'
echo '查漏日志文件将保存在：/root/AutoRclone/LOG/'"$rootName"'_check.txt'
echo '去重日志文件将保存在：/root/AutoRclone/LOG/'"$rootName"'_dedupe.txt'
echo 【开始转存】......
gclone copy remote:{$link} "remote:{$Copyfolderid}/$rootName" --drive-server-side-across-configs -vvP --transfers=20 --config="$Road" --log-file=/root/AutoRclone/LOG/"$rootName"'.txt'
echo 【查缺补漏】......
gclone copy remote:{$link} "remote:{$Copyfolderid}/$rootName" --drive-server-side-across-configs -vvP --transfers=40 --config="$Road" --log-file=/root/AutoRclone/LOG/"$rootName"'_check.txt'
echo 【去重检查】......
gclone dedupe newest "remote:{$Copyfolderid}/$rootName" --drive-server-side-across-configs -vvP --config="$Road" --log-file=/root/AutoRclone/LOG/"$rootName"'_dedupe.txt'
echo -e

echo -e "\033[32m==<<TD网盘防翻车一键转存备份脚本.备份一即将开始建立（转存一份、备份两份、共三份），可ctrl+c中途中断>>==\033[0m"
if [[ ! -d "gclone lsd remote:{$Backupid1} --config="$Road"" ]]; then
	gclone mkdir "remote:{$Backupid1}/$CopyfolderName" --config="$Road"
else
	echo "$CopyfolderName"
fi
id=$Backupid1
j=$(gclone lsd remote:{$id} --config="$Road" --dump bodies -vv 2>&1 | grep '^{"id"' | grep $id) BackupCopyfolderName1=$(echo $j | grep -Po '(?<="name":")[^"]*')
echo "备份一将存入分类目录："$BackupCopyfolderName1/$CopyfolderName/$rootName
echo '备份一转存日志文件将保存在：/root/AutoRclone/LOG/'"$rootName"'_backup1.txt'
echo '备份一查漏日志文件将保存在：/root/AutoRclone/LOG/'"$rootName"'_check_backup1.txt'
echo '备份一去重日志文件将保存在：/root/AutoRclone/LOG/'"$rootName"'_dedupe_backup1.txt'
echo 【备份一开始建立】......
gclone copy remote:{$link} "remote:{$Backupid1}/$CopyfolderName/$rootName" --drive-server-side-across-configs -vvP --transfers=20 --config="$Road" --log-file=/root/AutoRclone/LOG/"$rootName"'_backup1.txt'
echo 【备份一查缺补漏】......
gclone copy remote:{$link} "remote:{$Backupid1}/$CopyfolderName/$rootName" --drive-server-side-across-configs -vvP --transfers=40 --config="$Road" --log-file=/root/AutoRclone/LOG/"$rootName"'_check_backup1.txt'
echo 【备份一去重检查】......
gclone dedupe newest "remote:{$Backupid1}/$CopyfolderName/$rootName" --drive-server-side-across-configs -vvP --config="$Road" --log-file=/root/AutoRclone/LOG/"$rootName"'_dedupe_backup1.txt'
echo -e

echo -e "\033[32m==<<TD网盘防翻车一键转存备份脚本.备份二即将开始建立（转存一份、备份两份、共三份），可ctrl+c中途中断>>==\033[0m"
if [[ ! -d "gclone lsd remote:{$Backupid2} --config="$Road"" ]]; then
	gclone mkdir "remote:{$Backupid2}/$CopyfolderName" --config="$Road"
else
	echo "$CopyfolderName"
fi
id=$Backupid2
j=$(gclone lsd remote:{$id} --config="$Road" --dump bodies -vv 2>&1 | grep '^{"id"' | grep $id) BackupCopyfolderName2=$(echo $j | grep -Po '(?<="name":")[^"]*')
echo "备份二将存入分类目录："$BackupCopyfolderName2/$CopyfolderName/$rootName
echo '备份二转存日志文件将保存在：/root/AutoRclone/LOG/'"$rootName"'_backup2.txt'
echo '备份二查漏日志文件将保存在：/root/AutoRclone/LOG/'"$rootName"'_check_backup2.txt'
echo '备份二去重日志文件将保存在：/root/AutoRclone/LOG/'"$rootName"'_dedupe_backup2.txt'
echo 【备份二开始建立】......
gclone copy remote:{$link} "remote:{$Backupid2}/$CopyfolderName/$rootName" --drive-server-side-across-configs -vvP --transfers=20 --config="$Road" --log-file=/root/AutoRclone/LOG/"$rootName"'_backup2.txt'
echo 【备份二查缺补漏】......
gclone copy remote:{$link} "remote:{$Backupid2}/$CopyfolderName/$rootName" --drive-server-side-across-configs -vvP --transfers=40 --config="$Road" --log-file=/root/AutoRclone/LOG/"$rootName"'_check_backup2.txt'
echo 【备份二去重检查】......
gclone dedupe newest "remote:{$Backupid2}/$CopyfolderName/$rootName" --drive-server-side-across-configs -vvP --config="$Road" --log-file=/root/AutoRclone/LOG/"$rootName"'_dedupe_backup2.txt'
