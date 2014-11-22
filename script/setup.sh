xymon_version='4.3.17'

yum install -y make vim gcc pcre-devel rrdtool-devel libpng-devel openssl-devel openldap-devel wget fping httpd
if [ -f /usr/bin/fping ];then
    ln -s /usr/sbin/fping /usr/bin/fping
fi

grep '^xymon:' /etc/passwd
if [ $? -ne 0 ]; then
    useradd xymon
fi

cd /tmp
if [ ! -f /tmp/xymon-${xymon_version}.tar.gz ];then
    wget http://sourceforge.net/projects/xymon/files/Xymon/${xymon_version}/xymon-${xymon_version}.tar.gz
    tar zxvf xymon-${xymon_version}.tar.gz
    cd xymon-${xymon_version}
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

sed -e "s/DAEMON=\/usr\/lib\/xymon\/server\/bin\/xymon.sh/DAEMON=\/home\/xymon\/server\/bin\/xymon.sh/g" /tmp/xymon-${xymon_version}/rpm/xymon-init.d > /etc/init.d/xymon
chmod +x /etc/init.d/xymon

if [ ! -f /etc/logrotate.d/xymon ];then
    cp /tmp/xymon-${xymon_version}/rpm/xymon.logrotate /etc/logrotate.d/xymon
fi

chmod 701 /home/xymon
chkconfig xymon on
service xymon restart
