#!/bin/bash

# Install dependencies
command -v marked > /dev/null || npm install -g marked

cat README.md | marked -o body.html
cat <<-'EOF' > index.html
	<!DOCTYPE html><html><head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>Web Development Bookmarks by vbwx</title>
		<style>body{font:0.9em/1 "Helvetica Neue",Helvetica,Arial,sans-serif}p:last-of-type{font-size:0.7rem;margin:2rem}li{line-height:1.5}h2+ul,h3+ul{margin-top:-1.1ex}h2,h2+ul{margin-left:2rem}h3,h3+ul{margin-left:4rem}ul{list-style:none;padding-left:2rem}h1,h2,h3{font-weight:normal;cursor:pointer}h2:first-of-type{color:#666}a{outline:none;text-decoration:none}a:focus{text-decoration:underline}a:link,a:visited{color:#0261E5}a:active,a:focus,a:hover{color:#102EA1}.c+ul,.c+div{display:none}.c::before{content:'▸';position:absolute;margin-left:-1.8ex}.o::before{content:'▾';position:absolute;margin-left:-2ex}.o,.c{padding-left:2ex}hr{display:none}</style>
	</head><body>
EOF
sed -E 's/<!--([a-z0-9\/]+)-->/<\1>/g' body.html >> index.html
cat <<-'EOF' >> index.html
	<script>$=function(n,f){[].forEach.call(document.getElementsByTagName(n),f)};toggle=function(b){['h1','h2','h3'].forEach(function(h){$(h,function(t){t.className=b?'o':'c'})})};['h2','h3'].forEach(function(h){$(h,function(t){t.addEventListener('click',function(){this.className=this.className==='c'?'o':'c'})})});$('h1',function(t){t.addEventListener('click',function(){toggle(this.className==='c')})});$('a',function(t){if(t.getAttribute('href')[0]!=='#')t.target="_blank"});toggle(0)</script>
	</body></html>
EOF
rm -f body.html

if [ $(pwd) = "/Users/vbwx/Projects/Utilities/dev-bookmarks" ]; then
	git commit -a && git push
	git checkout gh-pages && git checkout --patch master index.html
	git commit -am "Publish" && git push && git checkout master
fi
