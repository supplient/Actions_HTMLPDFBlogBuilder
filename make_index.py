import os

def make_md_index(parent_dir: str):
	# Collect subdirs and files under this dir
	dirs = []
	files = []
	for entry in os.listdir(parent_dir):
		if os.path.isdir(os.path.join(parent_dir, entry)):
			# Bypass the folder start with "_" and "."
			if entry.startswith("_") or entry.startswith("."):
				continue
			dirs.append(entry)
		else:
			# Bypass 404.html
			if entry == "404.html":
				continue
			files.append(entry)
	
	# Make entry for each subdir and file
	out = ""
	def make_entry(text:str, url:str):
		return f"* [{text}]({url})\n"

	for dir in dirs:
		# Subdir: point to index.html in it.
		p = os.path.join(".", dir)
		p = os.path.join(p, "index.html")
		out += make_entry(dir, p)
	for file in files:
		ori_file = file
		filename, ext = os.path.splitext(file)
		if ext == ".html" or ext == ".pdf":
			# Html or PDF: point to itself
			pass
		# elif ext == ".md" and filename != "index":
			# # Markdown: point to its converted .html file
			# file = filename + ".html"
		else:
			# Other: no entry
			file = None

		if file == None:
			continue
		p = os.path.join(".", file)
		out += make_entry(ori_file, p)
	return out

def iterate_make_md_index(root_path: str):
	for parent_dir, _, _ in os.walk(root_path):
		# Bypass the folder start with "_" and "."
		entry = os.path.basename(parent_dir)
		if entry.startswith("_") or entry.startswith("."):
			continue

		# Make index.md for the folder
		content = make_md_index(parent_dir)
		index_file = os.path.join(parent_dir, "index.md")
		with open(index_file, mode="w", encoding="utf8") as f:
			f.write(content)


if __name__ == "__main__":
	import argparse
	parser = argparse.ArgumentParser(
		prog="MakeIndex",
		description="Iterate root folder to make index.md with entries pointing to .pdf and .html",
	)
	parser.add_argument("rootdir")
	args = parser.parse_args()
	print("Make index for " + args.rootdir)
	iterate_make_md_index(args.rootdir)
	print("Make index fininshed.")
