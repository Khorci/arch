#!/bin/sh

TZ="America/Sao_Paulo"
HN="arch"
USER="matheus"

ln -sf /usr/share/zoneinfo/$TZ /etc/localtime
hwclock --systo --utc

sed -i "s/^#pt_BR.UTF-8\ UTF-8/pt_BR.UTF-8\ UTF-8/" /etc/locale.gen
sed -i "s/^#en_US.UTF-8\ UTF-8/en_US.UTF-8\ UTF-8/" /etc/locale.gen
locale-gen

echo -e "LANG=pt_BR.UTF-8\nLANGUAGE=pt_BR:pt:en\nLC_MESSAGES=pt_BR.UTF-8" >> /etc/locale.conf
echo "KEYMAP=br-abnt2" >> /etc/vconsole.conf
echo "$HN" >> /etc/hostname
echo -e "\n127.0.0.1\tlocalhost\n::1\t\tlocalhost\n127.0.1.1\t$HN.localdomain\t$HN" >> /etc/hosts

grep -q "^Color" /etc/pacman.conf || sed -i "s/^#Color$/Color/" /etc/pacman.conf
grep -q "ILoveCandy" /etc/pacman.conf || sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf

sed -i "s/#\ %wheel\ ALL=(ALL)\ ALL/%wheel\ ALL=(ALL)\ ALL/" /etc/sudoers

useradd -mg wheel -G storage,power,audio,video,optical -s /bin/zsh $USER
chown -R $USER:wheel /home/$USER

pacman --noconfirm --needed -S networkmanager
systemctl enable NetworkManager
systemctl start NetworkManager

pacman --noconfirm --needed -S grub && grub-install --target=i386-pc /dev/sda && grub-mkconfig -o /boot/grub/grub.cfg

mkinitcpio -P

passwd
passwd $USER
