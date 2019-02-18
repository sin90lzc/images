#!/bin/bash -e

#path=$1

#gitpath=$2
#
#rename=$3
#
#mkdir -p $gitpath
#
#curl $path -o $gitpath/$rename
#
#git add -v .
#
#git commit -m 'add file $rename'
#
#git push
#
#echo "https://sin90lzc.github.io/images/$gitpath/$rename"

IMAGE_GIT_PATH=~/data/images

SEE_HELP=

#public function
. ~/.bash-functions

#here document
function help(){
	cat <<HERE_DOCUMENT
Description:
	脚本用于上传url文件或plantuml工具生成的图片上传至https://github.com/sin90lzc/images.git

Usage:
	upload.sh -u|-p|-l [-r rename] <dir in git repository> 

Options:
	-h,--help 显示帮助信息
	-u,--uml 指定plantuml的脚本位置，会使用plantuml.jar工具生成图片并上传
	-p,--path url路径
	-l,--locale 文件所在路径
	-r,--rename 把文件重命名
	<dir in git repository> git仓库下的目录名称

Example:
	uploadfile -p http://pic4.nipic.com/20091217/3885730_124701000519_2.jpg -r test.jpg test	#使用url上传，文件存放在git仓库的test目录下，并把文件重命名为test/test.jpg
	uploadfile -u classes.pu test	#使用plantuml生成图片，文件存放在git仓库的test目录下
	uploadfile -l my.png test	#上传my.png文件至git仓库的test目录下


Author: Tim Leung
contact: lzcgame@126.com

HERE_DOCUMENT
return 0
}

#解释指令参数
while [ $# -gt 0 ] ; do
	case $1 in
		-h|--help)
			help
			shift
			exit 0
			;;
		-u|--uml)
			shift
			PLANTUML=$1
			shift
			;;
		-p|--path)
			shift
			URLPATH=$1
			shift
			;;
		-l|--locale)
			shift
			LOCALEFILE=$1
			shift
			;;
		-r|--rename)
			shift
			RENAME=$1
			shift
			;;
		--)	##stop option
			shift;break
			;;
		-*)
			log -l 1 "unknown option:$1"
			;;
		*)
			DIR=$1
			shift
			if [ $# -gt 0 ];then
				log -l 1 "${SEE_HELP}"
			fi
		;;
	esac
done

if [ -z "${URLPATH}" -a -z "${PLANTUML}" -a -z "${LOCALEFILE}" ] ; then
	help
	exit 1
fi

if [ -z "${DIR}" ] ; then
	log -l 1 "请提供<dir in git repository>"
	exit 1
fi

GIT_PATH=${IMAGE_GIT_PATH}/${DIR}

mkdir -p $GIT_PATH

if [ -n "${URLPATH}" ] ; then
	if [ -n ${RENAME} ];then
		RENAME=${URLPATH##*/}
	fi
	curl ${URLPATH} -o ${GIT_PATH}/$RENAME
elif [ -n "${PLANTUML}" ];then
	if [ -z ${RENAME} ];then
		RENAME=${PLANTUML##*/}
		RENAME=${RENAME%.pu}.png
	fi
	java -jar ~/software/plantuml.jar ${PLANTUML} -o ${GIT_PATH}
elif [ -n "${LOCALEFILE}" ];then
	if [ -z ${RENAME} ];then
		RENAME=${LOCALEFILE##*/}
	fi
	cp ${LOCALEFILE} ${GIT_PATH}/$RENAME	
else
	help
	exit 1
fi

LASTDIR=$(pwd)

cd $IMAGE_GIT_PATH

git add -v ${DIR}

git commit -m "add file ${DIR}/$RENAME"

git push

echo "https://blog.lzc.space/images/${DIR}/${RENAME}"

cd $LASTDIR
#参数校验

exit 0
