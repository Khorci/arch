#!/bin/sh

ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systo

sed -i "s/^#pt_BR.UTF-8\ UTF-8/pt_BR.UTF-8\ UTF-8/" /etc/locale.gen
sed -i "s/^#en_US.UTF-8\ UTF-8/en_US.UTF-8\ UTF-8/" /etc/locale.gen
locale-gen

echo -e "LANG=pt_BR.UTF-8\nLANGUAGE=pt_BR:pt:en" >> /etc/locale.conf
echo "KEYMAP=br-abnt2" >> /etc/vconsole.conf
echo "arch" >> /etc/hostname
echo -e "\n127.0.0.1\tlocalhost\n::1\t\tlocalhost\n127.0.1.1\tarch.localdomain\tarch" >> /etc/hosts

pacman --noconfirm --needed -S networkmanager
systemctl enable NetworkManager
systemctl start NetworkManager

pacman --noconfirm --needed -S grub && grub-install --target=i386-pc /dev/sda && grub-mkconfig -o /boot/grub/grub.cfg

mkinitcpio -P

passwd