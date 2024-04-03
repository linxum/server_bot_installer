#!/bin/bash

show_progress() {
    local pid=$1
    local delay=0.75
    local spin='-\|/'

    while ps -p $pid &>/dev/null; do
        printf "%c\r" "${spin:i++%${#spin}:1}"
        sleep $delay
    done
    printf "\r\n"  # Добавляем новую строку после завершения анимации
}


# Функция для установки Node.js через APT
install_node_via_apt() {
    if command -v node &>/dev/null && command -v npm &>/dev/null; then
        echo "Node.js и npm уже установлены."
    else
        echo "Node.js и npm не установлены. Выполняем установку "
        sudo apt update >/dev/null 2>&1
        sudo apt install -y nodejs npm >/dev/null 2>&1
        show_progress $! &
    fi
}

# Функция для установки Node.js через YUM
install_node_via_yum() {
    if command -v node &>/dev/null && command -v npm &>/dev/null; then
        echo "Node.js и npm уже установлены."
    else
        echo "Node.js и npm не установлены. Выполняем установку "
        sudo yum install -y nodejs npm >/dev/null 2>&1
        show_progress $! &
    fi
}

# Функция для установки Node.js через Zypper
install_node_via_zypper() {
    if command -v node &>/dev/null && command -v npm &>/dev/null; then
        echo "Node.js и npm уже установлены."
    else
        echo "Node.js и npm не установлены. Выполняем установку "
        sudo zypper install -y nodejs npm >/dev/null 2>&1
        show_progress $! &
    fi 
}

# Функция для установки Python3 через APT
install_python3_via_apt() {
    if command -v python3 &>/dev/null; then
        echo "Python3 уже установлен."
    else
        echo "Python3 не установлен. Выполняем установку "
        sudo apt update >/dev/null 2>&1
        sudo apt install -y python3 >/dev/null 2>&1
        show_progress $! &
    fi
}

# Функция для установки Python3 через YUM
install_python3_via_yum() {
    if command -v python3 &>/dev/null; then
        echo "Python3 уже установлен."
    else
        echo "Python3 не установлен. Выполняем установку "
        sudo yum install -y python3 >/dev/null 2>&1
        show_progress $! &
    fi
}

# Функция для установки Python3 через Zypper
install_python3_via_zypper() {
    if command -v python3 &>/dev/null; then
        echo "Python3 уже установлен."
    else
        echo "Python3 не установлен. Выполняем установку "
        sudo zypper install -y python3 >/dev/null 2>&1
        show_progress $! &
    fi
}

# Проверка, установлен ли pm2 через npm
check_pm2_installed() {
    if npm list -g pm2 &>/dev/null; then
        echo "pm2 уже установлен. Пропуск установки."
    else
        echo "pm2 не установлен. Установка "
        npm install pm2 -g >/dev/null 2>&1
        show_progress $! &
    fi
}

echo
echo
echo "Данный скрипт установит необходимые компоненты и пакеты для работы сервера бота, написаного на Python"
echo
echo
read -p "Напиши путь до файла main.py: " main_path
echo
read -p "Напиши путь до файла requirements.txt (если не нужно - нажми Enter): " requirements_path
echo
echo

# Проверяем доступность менеджера пакетов и вызываем соответствующие функции установки Node.js, npm и Python3
if command -v apt &> /dev/null; then
    install_node_via_apt
    echo
    echo
    install_python3_via_apt
    echo
    echo
elif command -v yum &> /dev/null; then
    install_node_via_yum
    echo
    echo
    install_python3_via_yum
    echo
    echo
elif command -v zypper &> /dev/null; then
    install_node_via_zypper
    echo
    echo
    install_python3_via_zypper
    echo
    echo
else
    echo "Не удалось определить доступный менеджер пакетов на вашей системе."
    exit 1
fi

check_pm2_installed
echo
echo

if [ -n "$requirements_path" ]; then
    echo "Установка зависимостей pip "
    pip3 install -r "$requirements_path" >/dev/null 2>&1
    show_progress $! &
    echo
    echo
fi


echo "Все необходимые компоненты и пакеты установлены."
echo
read -p "Желаете запустить бота? (y/n): " answer

if [ "$answer" == "y" ]; then
    pm2 start -f "$main_path" --interpreter python3 --name bot
elif [ "$answer" == "n" ]; then
    echo "Выход из программы."
    exit 0
else
    echo "Некорректный ответ. Выход из программы."
    exit 0
fi


