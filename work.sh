root_dir="$1"

echo "root_dir: ${root_dir}"

# 生成目录文件
echo "Generating index.md ......"
sh /make_index.sh ${root_dir}
