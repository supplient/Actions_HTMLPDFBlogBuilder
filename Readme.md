# BlogBuilder

自用Action，会做三件事情：

1. 拷贝所有文件到目标目录下
2. 为每个目录生成一个`index.md`，内容为到该目录下的`.html`文件和`.pdf`文件的索引项和到子目录的`index.md`的索引项


# Usage

``` yaml
- uses: supplient/Actions_HTMLPDFBlogBuilder@main
  with:
    # required 源目录，会处理该目录下的文件。注意index.md也会生成在该目录中
    root_dir: ./md
```

# Scenarios
假设有一个markdown的库，我们希望从它建立一个博客。假设它的目录结构为：

```
a.html
graph
  b.html
  bg.png
extra
  c.pdf
  cg.html
```

为其设立Workflow，其`main.yml`如下：

``` yaml
name: Build Page => gh_pages

# 设定为当main分支有新分支时被启动
on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:
  build:
    # 只能在linux系统的host runner上跑
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v3
        with:
          path: "${{ github.workspace }}"

      - name: Blog Builder
        uses: supplient/Actions_HTMLPDFBlogBuilder@main
        with:
          root_dir: "/github/workspace"
        
      - name: Deploy to gp-pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: "${{ github.workspace }}"
```

则每当main分支有新的commit被提交时，该workflow就会更新gh-pages分支。gh-pages分支下的目录结构将为：

```
index.md
a.html
graph
  index.md
  b.html
  bg.png
extra
  index.md
  c.pdf
  cg.html
```

如果启用github page，并将其源目录设为gh-page分支的根目录，则会因为gh-pages的变动而进一步触发github自动设立的pages-build-depolyment Workflow，从而更新github page。
