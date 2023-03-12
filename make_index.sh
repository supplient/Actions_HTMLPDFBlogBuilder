# usage: bash make_index.sh ./md
# 它会递归遍历目录，为每个目录都创建一个index.md作为该目录的索引：
#	* 对于子目录，建立一个到子目录的index.md的索引项
#	* 对于.html和.pdf文件，建立一个到它自己的索引项
#
# e.g. 在index.md中
# 
# [并行问题_offset2index.html](并行问题_offset2index.html)
# [C++检查模板参数的成员函数是否具有指定签名.html](C++检查模板参数的成员函数是否具有指定签名.html)
# [CUDA中原子锁的实现.html](CUDA中原子锁的实现.html)
# [GPU数据结构设计模式.html](GPU数据结构设计模式.html)
# [Derivation.pdf](Derivation.pdf)
# [PD_reading](PD_reading/index.html)
# [XPBD_reading](XPBD_reading/index.html)


# 创建index文件
indexpath="$1/index.md"
cat /dev/null > $indexpath
# 遍历当前目录下的文件/子目录
for filepath in $1/*
do
	if [ -d $filepath ]
	then
		# 添加 到子目录index文件 的索引
		dirname=${filepath##*/}
		echo "[${dirname}](${dirname}/index.html)" >> $indexpath
		echo "" >> $indexpath
		# 对子目录进行递归操作
		sh $0 ${filepath}
	elif [[ ${filepath##*.} == "pdf" ]]
	then
		# 对每个.pdf文件建立 到它 的索引项
		filename=${filepath##*/}
		echo "[${filename}]($filename)" >> $indexpath
		echo "" >> $indexpath
	elif [[ ${filepath##*.} == "html" ]]
	then
		# 对每个.html文件建立 到它 的索引项
		filename=${filepath##*/}
		echo "[${filename}]($filename)" >> $indexpath
		echo "" >> $indexpath
	fi
done
