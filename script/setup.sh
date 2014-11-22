yum install -y make vim gcc pcre-devel rrdtool-devel libpng-devel openssl-devel openldap-devel wget fping httpd
if [ -f /usr/bin/fping ];then
    ln -s /usr/sbin/fping /usr/bin/fping
fi

grep '^xymon:' /etc/passwd
if [ $? -ne 0 ]; then
    useradd xymon
fi

cd /tmp
if [ ! -f /tmp/xymon-4.3.17.tar.gz ];then
    wget http://sourceforge.net/projects/xymon/files/Xymon/4.3.17/xymon-4.3.17.tar.gz
    tar zxvf xymon-4.3.17.tar.gz
    cd xymon-4.3.17
    ./configure
    make
    make install
fi

chkconfig httpd on
service httpd start

if [ ! -f /etc/httpd/conf.d/xymon.conf ];then
    cp /home/xymon/server/etc/xymon-apache.conf /etc/httpd/conf.d/xymon.conf
    service httpd reload
fi

sed -e "s/DAEMON=\/usr\/lib\/xymon\/server\/bin\/xymon.sh/DAEMON=\/home\/xymon\/server\/bin\/xymon.sh/g" /tmp/xymon-4.3.17/rpm/xymon-init.d > /etc/init.d/xymon
chmod +x /etc/init.d/xymon

if [ ! -f /etc/logrotate.d/xymon ];then
    cp /tmp/xymon-4.3.17/rpm/xymon.logrotate /etc/logrotate.d/xymon
fi

chmod 701 /home/xymon
chkconfig xymon on
service xymon restart
