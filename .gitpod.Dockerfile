#Descarga la imagen base-devel
FROM archlinux:base-devel

#Crea el usuario
RUN useradd -l -u 33333 -md /home/gitpod -s /bin/bash gitpod && \
  passwd -d gitpod && \
  echo 'gitpod ALL=(ALL) ALL' > /etc/sudoers.d/gitpod && \
  sed -i "s/PS1='\[\\\u\@\\\h \\\W\]\\\\\\$ '//g" /home/gitpod/.bashrc && \
  { echo && echo "PS1='\[\e]0;\u \w\a\]\[\033[01;32m\]\u\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\] \\\$ '" ; } >> /home/gitpod/.bashrc

#Define el usuario del contenedor
USER gitpod

#Actualizando y borrando la caché incluyendo paquetes huérfanos
RUN sudo pacman --noconfirm -Syyu && \
  pacman -Qtdq | xargs -r sudo pacman --noconfirm -Rcns && \
  sudo pacman -Scc <<< Y <<< Y

#Instala el paquete docker
RUN sudo pacman -S docker docker-compose &&\
  sudo systemctl enable &&\
  sudo systemctl start docker 

#Instala yay
RUN sudo pacman --noconfirm -Syu git && \
  mkdir ~/build && \
  cd ~/build && \
  git clone --depth 1 "https://aur.archlinux.org/yay.git" && \
  cd yay && \
  makepkg --noconfirm -si && \
  rm -rf ~/.cache && \
  rm -rf ~/go && \
  rm -rf ~/build

#Instala dune con yay 
  #&& \
  #yay -S --noconfirm dune-common &&\
  #yay -Qtdq | xargs -r yay --noconfirm -Rcns && \
  #yay -Scc <<< Y <<< Y <<< Y