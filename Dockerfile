FROM quay.io/podman/stable:v4.3.1

RUN yum update \
&& yum install -y  \
        ca-certificates \
        curl \
        jq \
        git \
        iputils \
        curl-devel \
        # libicu60 \
        libunwind \
        netcat 

RUN yum install -y \
        apt-transport-https \
        zlib-devel \
        java-11-openjdk \
        zip \
        unzip 
        #gpg-agent \
        #software-properties-common 

RUN yum install wget -y

# install .net core sdk
RUN wget https://packages.microsoft.com/config/fedora/36/packages-microsoft-prod.rpm -O packages-microsoft-prod.rpm
RUN rpm -ivh packages-microsoft-prod.rpm
RUN yum install  dotnet-sdk-3.1 -y 


RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc
RUN dnf install -y https://packages.microsoft.com/config/rhel/8/packages-microsoft-prod.rpm
RUN echo -e "[azure-cli]   name=Azure CLI    baseurl=https://packages.microsoft.com/yumrepos/azure-cli    enabled=1    gpgcheck=1    gpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/azure-cli.repo
RUN dnf install azure-cli -y               
# install k8s cli
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl

RUN chmod +x ./kubectl

RUN mv ./kubectl /usr/local/bin/kubectl

# install node
#v12 not available. check impact
RUN dnf module install nodejs:14 -y

RUN npm i -g @angular/cli

# Install Sonar SAST  
RUN cat /etc/os-release  
RUN yum install libunwind icu -y
RUN export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=0

#During os upgrade identify the icu version with yum info icu and update the icu version
RUN export CLR_ICU_VERSION_OVERRIDE="71.1"; dotnet tool install --global dotnet-sonarscanner --version 5.9.0

# Install Helm 
RUN dnf install helm

RUN yum install -y wget \
    && wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm \
    && yum install ./google-chrome-stable_current_*.rpm -y  \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && yum update -y \
    && yum install ipa-gothic-fonts wqy-zenhei-fonts thai-scalable-tlwgtypo-fonts kacst-art-fonts -y


RUN export CHROME_BIN=/usr/bin/google-chrome

WORKDIR /azp
COPY ./start.sh .
RUN chmod +x start.sh

CMD ["./start.sh"]