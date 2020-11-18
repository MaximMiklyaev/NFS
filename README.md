#скачиваем Vagrantfile

           'git clone https://github.com/MaximMiklyaev/NFS.git'

#переходим в директорию:

           'cd /NFS'

#запускаем образ

           'vagrant up'

#Vagrantfile поднимает 2 VM: сервер(nfsSerer) и клиент(nfsClient)

#на сервере расшаряется директория

#при старте клиент автоматически монтирует директорию с сервера

#при поднятие nfsSerer запускается скрипт server_script.sh
   
   инф. server_script.sh

                         #!/bin/sh
                         set -eux
                         echo "HM4"
                         whoami
                         uname -a
                         hostname -f
                         ip addr show dev eth1
                         echo "commands"
                         #переходим под root права
                         sudo -i
                         #устанавка утилит на сервер
                         yum install -y nfs-utils
                         #включаем сервисы nfs сервера
                         systemctl enable rpcbind
                         systemctl enable nfs-server
                         systemctl enable rpc-statd
                         systemctl enable nfs-idmapd
                         #запуск сервисов nfs сервера
                         systemctl start rpcbind
                         systemctl start nfs-server
                         systemctl start rpc-statd
                         systemctl start nfs-idmapd
                         #создание дирректории для общего доступа
                         mkdir -p /usr/shared/
                         #назначение прав данной дирректории
                         chmod 0777 /usr/shared/
                         #конфигурируем exports
                         cat << EOF | sudo tee /etc/exports
                         /usr/shared/ 192.168.10.0/24(rw,sync)
                         EOF
                         #применяем изменения
                         exportfs -ra
                         #включаем и запускаем firewalld
                         systemctl enable firewalld
                         systemctl start firewalld
                         #включаем сервисы
                         firewall-cmd --permanent --add-service=nfs3
                         firewall-cmd --permanent --add-service=mountd
                         firewall-cmd --permanent --add-service=rpc-bind
                         firewall-cmd --reload
                         #создаем папку uploads в расшареной дирректории
                         mkdir /usr/shared/uploads
 
#при поднятие nfsClient запускается скрипт client_script.sh

   инф. server_script.sh

                          #!/bin/sh
                          set -eux
                          echo "HM4"
                          whoami
                          uname -a
                          hostname -f
                          ip addr show dev eth1
                          echo "mount NFSv3 UDP"
                          echo "test mount NFSv4"
                          #переходим под root права
                          sudo -i
                          #устанавка утилит на клиенте
                          yum install -y nfs-utils
                          #включаем и запускаем firewalld
                          systemctl enable firewalld
                          systemctl start firewalld
                          #добавляем запись в fstab для автоматического монтирования
                          echo "192.168.10.10:/usr/shared /mnt nfs rw,vers=3,sync,proto=udp,rsize=32768,wsize=32768 0 0" >> /etc/fstab
                          #монтируем указанный в fstab каталог в /mnt
                          mount /mnt/

#проверка примонтированного диска на клиенте

#подключаемся к клиентской VM

    'vagrant ssh nfsClient'



    'lsblk'

    вывод:
          NAME   MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
          sda      8:0    0  40G  0 disk
          `-sda1   8:1    0  40G  0 part /



    'df -h'

    вывод:
          Filesystem                 Size  Used Avail Use% Mounted on
          devtmpfs                   111M     0  111M   0% /dev
          tmpfs                      118M     0  118M   0% /dev/shm
          tmpfs                      118M  8.5M  110M   8% /run
          tmpfs                      118M     0  118M   0% /sys/fs/cgroup
          /dev/sda1                   40G  3.1G   37G   8% /
          192.168.10.10:/usr/shared   40G  3.1G   37G   8% /mnt
          tmpfs                       24M     0   24M   0% /run/user/1000
