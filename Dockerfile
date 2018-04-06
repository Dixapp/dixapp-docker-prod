FROM centos:latest as cent
RUN curl --silent --location https://rpm.nodesource.com/setup_9.x | bash -

RUN yum -y install git
RUN yum -y install nodejs
RUN yum -y install epel-release
RUN yum -y install nginx
RUN yum -y install supervisor
RUN npm install pm2 -g
RUN npm install @angular/cli -g --unsafe

WORKDIR /dixapp
RUN git clone https://github.com/VashingMachine/dixapp-ui.git
RUN git clone https://github.com/VashingMachine/dixapp-api.git

WORKDIR /dixapp/dixapp-ui
COPY environment.prod.ts /dixapp/dixapp-ui/src/environments/
RUN npm install
RUN ng build --prod

WORKDIR /dixapp/dixapp-api
RUN npm install

COPY --from=cent /dixapp/dixapp-ui/dist/ /usr/share/nginx/html
COPY ./nginx-custom.conf /etc/nginx/conf.d/dixapp.ui.conf

ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]

EXPOSE 22 80 8080
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD supervisord.conf /etc/

WORKDIR /dixapp

ENTRYPOINT ["/usr/bin/supervisord", "-n"]
