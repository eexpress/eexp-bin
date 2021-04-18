#!/bin/bash

# yad版本。切换json代理和pac设置。
# 使用v2ray来统管shadowsocks+v2ray的json

cd $(dirname $0)
configpath="$(pwd)/Json"
#~ configfile="*.pac *.json"
v2raycmd="$(pwd)/v2ray"
#~ running=`pgrep -af 'v2ray -config'|awk '{print $NF}'`
#~ running=`pgrep -af 'v2ray -config'|sed 's/.*config\ //'`
running=`pgrep -af "$v2raycmd -config"|cut -d' ' -f 4`
lastjson=`head -n 1 "$configpath/lastjson"`
socksport=1088
httpport=8888

off(){
	gsettings set org.gnome.system.proxy mode 'none'
	pkill -9 -x ${v2raycmd##*/}
	}

on(){
	gsettings set org.gnome.system.proxy mode 'manual'
	gsettings set org.gnome.system.proxy.http port $httpport
	gsettings set org.gnome.system.proxy.https port $httpport
	gsettings set org.gnome.system.proxy.ftp port $httpport
	gsettings set org.gnome.system.proxy.socks port $socksport
	gsettings set org.gnome.system.proxy.http host '127.0.0.1'
	gsettings set org.gnome.system.proxy.https host '127.0.0.1'
	gsettings set org.gnome.system.proxy.ftp host '127.0.0.1'
	gsettings set org.gnome.system.proxy.socks host '127.0.0.1'
	#~ ⭕ gsettings list-recursively org.gnome.system.proxy
	}

cd $configpath
list=( "<span background='#DB4C44' foreground='#fff'><b> shutdown </b></span>" "关闭全局代理／停止后台" )

	#~ echo $lastjson
for file in *.json; do
#~	echo "$file"
	protocol=""; color="#fff"
	grep 'vmess' "$file" 1>/dev/null && protocol="vmess" && color="#3465a4"
	grep 'shadowsocks' "$file" 1>/dev/null && protocol="shadowsocks" && color="#288722"
	list+=( "<span background='$color' foreground='#fff'><b> $protocol </b></span>" )
	#~ 正在运行的显示绿色，最后运行的显示灰色。
	[ "$running" == "$file" ] && file="<span background='#4DDB44' foreground='#fff'><b> $file </b></span>"
	[ "$lastjson" == "$file" ] && file="<span background='#A7A7A7' foreground='#fff'><b> $file </b></span>"
	#~ 如果文件已经在运行，lastjson不会再次叠加颜色。
	#~ [ "$running" == "$file" ] && file="+$file"
	list+=( "$file" )
#~ 数组带空格，需要加“”
done

#~ [ -n "$running" ] && m="已运行-$running" || m="v2ray没有运行"
#~ key=`zenity --window-icon=web --width=400 --height=500 --list --column="$m" --text=选择代理设置 "${list[@]}"`
key=`yad --geometry=600x800+100+100 --close-on-unfocus \
--list --column="protocol" --column="file" --search-column=2 --regex-search \
--title=选择代理设置 --window-icon=network-vpn "${list[@]}"`
#~ echo "$key"
key=`echo "$key"|cut -d\| -f 2|perl -pe 's/<.*?>//g; s/^\s+|\s+$//g;'`
# $running 和 $lastjson 条目，会附带pango代码和空格。
#-----------------------------
case "$key" in
	关闭*)
		echo "$key"
		off
		;;
	*.json)
		echo "--------------------------------"
		echo "切换到代理: $key"
		pkill -9 -x ${v2raycmd##*/}
		echo "--------------------------------"
		if [ -x $v2raycmd ]; then
			echo "$key" > "$configpath/lastjson"
			$v2raycmd -config "$key" &
			port=(`netstat -tpan 2>/dev/null|awk '/tcp.*LISTEN.*v2ray/{gsub(/:/,"",$4);print $4}'`);
			if [ -n ${p[1]} ]; then
				httpport=${port[1]}; socksport=${port[0]}
			elif [ -n ${p[0]} ]; then
				httpport=${port[0]}; socksport="0"
			else
				echo "没有打开的端口。"; exit
			fi
			echo "--------------------------------"
			echo $httpport"<->"$socksport
			gsettings list-recursively org.gnome.system.proxy
			echo "--------------------------------"
			on
		else
			echo "没安装命令行的v2ray软件。"; exit
		fi
		;;
esac
