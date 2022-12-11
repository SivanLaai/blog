#!/usr/bin/env sh

#git pull
#
#git add *
#
#git commit -m "add doc or update doc"
#
#git push
#rm -rf public
# 确保脚本抛出遇到的错误
set -e

# 生成静态文件
rm -rf public
#hugo
hugo --gc --minify --cleanDestinationDir
# 进入生成的文件夹
cd public

# deploy to github pages
echo 'www.sivanlaai.top' > CNAME
username="SivanLaai"
email="lyhhap@163.com"
git config --global user.name "$username"
git config --global user.email "$email"
if [ -z "$GITHUB_TOKEN" ]; then
  msg='deploy'
  githubUrl=git@github.com:SivanLaai/SivanLaai.github.io.git
else
  msg='来自github actions的自动部署'
  githubUrl=https://SivanLaai:${GITHUB_TOKEN}@github.com/SivanLaai/SivanLaai.github.io.git
fi

echo $githubUrl

git init
git add -A
git commit -m "${msg}"
# git push -f $githubUrl master:gh-pages # 推送到github gh-pages分支
git push -f $githubUrl master # 推送到github gh-pages分支

# deploy to coding pages
# echo 'www.xugaoyi.com\nxugaoyi.com' > CNAME  # 自定义域名
# echo 'google.com, pub-7828333725993554, DIRECT, f08c47fec0942fa0' > ads.txt # 谷歌广告相关文件

# if [ -z "$CODING_TOKEN" ]; then  # -z 字符串 长度为0则为true；$CODING_TOKEN来自于github仓库`Settings/Secrets`设置的私密环境变量
#   codingUrl=git@e.coding.net:xgy/xgy.git
# else
#   codingUrl=https://HmuzsGrGQX:${CODING_TOKEN}@e.coding.net/xgy/xgy.git
# fi
# git add -A
# git commit -m "${msg}"
# git push -f $codingUrl master # 推送到coding
