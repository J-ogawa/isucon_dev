ssh_host1="isucon@59.106.217.62"
cwd=`dirname "${0}"`
expr "${0}" : "/.*" > /dev/null || cwd=`(cd "${cwd}" && pwd)`

rsync -av --exclude=".git/*" --exclude="ruby/.bundle/*" --exclude="ruby/vendor/bundle/**/*" -e ssh "${cwd}/" "${ssh_host1}:/home/isucon/"

ssh -t -t $ssh_host1 <<-EOS
echo "=========== ${ssh_host1} =========="
sudo sysctl -p
echo "-----------"
ulimit -a
cd /home/isucon/isubata/webapp/ruby
/home/isucon/local/ruby/bin/bundle install
sudo rm -f /var/log/nginx/access.log
sudo systemctl restart mysql.service
sudo systemctl restart nginx.service
sudo systemctl restart isubata.ruby.service
exit
echo "======================================================"
EOS

ssh_host2="isucon@163.43.29.251"
cwd=`dirname "${0}"`
expr "${0}" : "/.*" > /dev/null || cwd=`(cd "${cwd}" && pwd)`

rsync -av --exclude=".git/*" --exclude="ruby/.bundle/*" --exclude="ruby/vendor/bundle/**/*" -e ssh "${cwd}/" "${ssh_host2}:/home/isucon/"

ssh -t -t $ssh_host2 <<-EOS
echo "=========== ${ssh_host2} =========="
sudo sysctl -p
echo "-----------"
ulimit -a
cd /home/isucon/isubata/webapp/ruby
/home/isucon/local/ruby/bin/bundle install
sudo rm -f /var/log/nginx/access.log
sudo systemctl restart mysql.service
sudo systemctl restart nginx.service
sudo systemctl restart isubata.ruby.service
exit
echo "======================================================"
EOS

ssh_host3="isucon@59.106.213.87"
cwd=`dirname "${0}"`
expr "${0}" : "/.*" > /dev/null || cwd=`(cd "${cwd}" && pwd)`

rsync -av --exclude=".git/*" --exclude="ruby/.bundle/*" --exclude="ruby/vendor/bundle/**/*" -e ssh "${cwd}/" "${ssh_host3}:/home/isucon/"

ssh -t -t $ssh_host3 <<-EOS
echo "=========== ${ssh_host3} =========="
sudo sysctl -p
echo "-----------"
ulimit -a
cd /home/isucon/isubata/webapp/ruby
/home/isucon/local/ruby/bin/bundle install
sudo rm -f /var/log/mysql/mysql-slow.log
sudo systemctl restart mysql.service
sudo systemctl restart nginx.service
sudo systemctl restart isubata.ruby.service
exit
echo "======================================================"
EOS
