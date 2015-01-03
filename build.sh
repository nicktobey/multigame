cd $(dirname $0)
mkdir out
cp src/www/* out/
coffee -o out/scripts -c src/scripts