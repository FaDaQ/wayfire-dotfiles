#!/bin/bash
#    ____         __       ____               __     __
#   /  _/__  ___ / /____ _/ / / __ _____  ___/ /__ _/ /____ ___
#  _/ // _ \(_-</ __/ _ `/ / / / // / _ \/ _  / _ `/ __/ -_|_-<
# /___/_//_/___/\__/\_,_/_/_/  \_,_/ .__/\_,_/\_,_/\__/\__/___/
#                                 /_/
#

sleep 1
clear
install_platform="$(cat ~/.config/ml4w/settings/platform.sh)"
toilet -f mono9 "ОБНОВЛЕНИЕ" | lolcat
echo

# ------------------------------------------------------
# Confirm Start
# ------------------------------------------------------

if gum confirm "ХОТИТЕ НАЧАТЬ ОБНОВЛЕНИЕ ПРЯМО СЕЙЧАС?"; then
    echo
    echo ":: Начато обновление."
elif [ $? -eq 130 ]; then
    exit 130
else
    echo
    echo ":: Обновление отменено."
    exit
fi

_isInstalled() {
    package="$1"
    case $install_platform in
        arch)
            check="$($aur_helper -Qs --color always "${package}" | grep "local" | grep "${package} ")"
            ;;
        fedora)
            check="$(dnf repoquery --quiet --installed ""${package}*"")"
            ;;
        *) ;;
    esac

    if [ -n "${check}" ]; then
        echo 0 #'0' means 'true' in Bash
        return #true
    fi
    echo 1 #'1' means 'false' in Bash
    return #false
}

# Check if platform is supported
case $install_platform in
    arch)
        aur_helper="$(cat ~/.config/ml4w/settings/aur.sh)"

        if [[ $(_isInstalled "timeshift") == "0" ]]; then
            echo
            if gum confirm "ХОТИТЕ СОЗДАТЬ СНАПШОТ?"; then
                echo
                c=$(gum input --placeholder "Комментарий к снапшоту...")
                sudo timeshift --create --comments "$c"
                sudo timeshift --list
                sudo grub-mkconfig -o /boot/grub/grub.cfg
                echo ":: ЗАВЕРШЕНО. Снапшот $c создан!"
                echo
            elif [ $? -eq 130 ]; then
                echo ":: Снапшот пропущен."
                exit 130
            else
                echo ":: Снапшот пропущен."
            fi
            echo
        fi

        $aur_helper

        if [[ $(_isInstalled "flatpak") == "0" ]]; then
            flatpak upgrade
        fi
        ;;
    fedora)
        sudo dnf upgrade
        if [[ $(_isInstalled "flatpak") == "0" ]]; then
            flatpak upgrade
        fi
        ;;
    *)
        echo ":: ERROR - Платформа не поддерживается"
        echo "Нажмите [ENTER] чтобы закрыть."
        read
        ;;
esac

notify-send "Обновление завершено"
echo
echo ":: Обновление завершено"
echo
echo

echo "Нажмите [ENTER] чтобы закрыть."
read
