cd /d %~dp0
mkdir out
cp src/www/* out/
coffee -o out/scripts -c src/scripts