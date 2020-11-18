#!/bin/sh

set -eux

echo "HM4"
whoami
uname -a
hostname -f
ip addr show dev eth1

echo "Mount NFSv3 UDP"

echo "Test mount NFSv4"

#������� ����� ����������� �� ��� root
sudo -i
#������������� ����������� ������ �� ������
yum install -y nfs-utils
#�������� � ��������� firewalld
systemctl enable firewalld
systemctl start firewalld
#��������� ������ � fstab ��� ��������������� ������������
echo "192.168.10.10:/usr/shared /mnt nfs rw,vers=3,sync,proto=udp,rsize=32768,wsize=32768 0 0" >> /etc/fstab
#��������� ��������� � fstab ������� � /mnt
mount /mnt/
