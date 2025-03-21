#!/bin/bash

sudo pacman -Sy git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..

yay -S wayfire lolcat gum toilet waybar checkupdates-with-aur swaync ttf-jetbrains-mono rofi ninja meson wlroots wayfire-plugins-extra wcm kitty wlogout slurp grim wl-clipboard polkit-gnome ripgrep xdg-desktop-portal-gtk xdg-desktop-portal-wlr blueman bluez-utils pavucontrol pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber
# firefox nautilus nautilus-open-any-terminal

#wf-info
git clone https://github.com/soreau/wf-info
cd wf-info

# Попробуем выполнить сборку без изменения PKG_CONFIG_PATH
meson build --prefix=/usr
ninja -C build

# Проверим, возникла ли ошибка при сборке
if [ $? -ne 0 ]; then
    echo "Ошибка сборки. Попробуем использовать нестандартный путь для wlroots."
    export PKG_CONFIG_PATH=/usr/lib/wlroots0.17/pkgconfig:$PKG_CONFIG_PATH

    # Повторим сборку после изменения PKG_CONFIG_PATH
    meson build --prefix=/usr
    ninja -C build
fi

# Устанавливаем
sudo ninja -C build install

cd ..
mkdir ~/.config/wayfire
cp -rf waybar/ ~/.config/wayfire/waybar/
cp -f wayfire.ini ~/.config/wayfire/wayfire.ini/

# создание символических ссылок
ln -s ~/.config/wayfire/waybar/ ~/.config/waybar
ln -s ~/.config/wayfire/wayfire.ini ~/.config/wayfire.ini
