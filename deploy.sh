ssh_host="isucon@59.106.217.62"
cwd=`dirname "${0}"`
expr "${0}" : "/.*" > /dev/null || cwd=`(cd "${cwd}" && pwd)`

rsync -av --exclude=".git/*" --exclude="ruby/.bundle/*" --exclude="ruby/vendor/bundle/**/*" -e ssh "${cwd}/" "${ssh_host}:/home/isucon/"

ssh -t -t $ssh_host <<-EOS
sudo sysctl -p
echo "======================================================"
ulimit -a
echo "======================================================"
cd /home/isucon/isubata/webapp/ruby
/home/isucon/local/ruby/bin/bundle install
sudo systemctl restart mysql.service
sudo systemctl restart nginx.service
sudo systemctl restart isubata.ruby.service
exit
EOS