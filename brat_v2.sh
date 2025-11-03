#!/usr/bin/env bash
# brat_v2.sh — главный интерфейс Брат v2

# Цвета
_bold=$(tput bold 2>/dev/null || echo)
_reset=$(tput sgr0 2>/dev/null || echo)
_red=$(tput setaf 1 2>/dev/null || echo)
_green=$(tput setaf 2 2>/dev/null || echo)
_yellow=$(tput setaf 3 2>/dev/null || echo)
_blue=$(tput setaf 4 2>/dev/null || echo)
_magenta=$(tput setaf 5 2>/dev/null || echo)
_cyan=$(tput setaf 6 2>/dev/null || echo)
_white=$(tput setaf 7 2>/dev/null || echo)

DEFAULT_THEME="neon"
THEME_FILE="$HOME/.brat_theme"

pause(){ read -rp "Нажми Enter..." _; }

# --- Лого ---
show_logo(){
  clear
  cat <<'LOGO'
 ██████╗ ██████╗  █████╗ ████████╗
██╔════╝██╔═══██╗██╔══██╗╚══██╔══╝
██║     ██║   ██║███████║   ██║   
██║     ██║   ██║██╔══██║   ██║   
╚██████╗╚██████╔╝██║  ██║   ██║   
 ╚═════╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝   
LOGO
  echo "🧠 БРАТ v2 — ваш личный терминал"
  echo "────────────────────────────────"
}

# --- Темы ---
apply_theme(){
  local theme=$1
  case "$theme" in
    matrix) _A="${_green}" ;;
    neon) _A="${_cyan}" ;;
    red) _A="${_red}" ;;
    dark) _A="${_blue}" ;;
    *) _A="${_cyan}" ;;
  esac
}

load_theme(){
  if [ -f "$THEME_FILE" ]; then
    THEME=$(cat "$THEME_FILE")
  else
    THEME="$DEFAULT_THEME"
  fi
  apply_theme "$THEME"
}

save_theme(){
  echo "$1" > "$THEME_FILE"
  apply_theme "$1"
}

# --- Секретное меню ---
secret_menu(){
  echo
  echo "${_A}=== СЕКРЕТНОЕ МЕНЮ БРАТА ===${_reset}"
  echo "1) Просмотр логов"
  echo "2) Режим разработчика (fake)"
  echo "3) Очистить логи"
  echo "0) Назад"
  read -rp "Выбор: " s
  case $s in
    1) [ -f "$HOME/termox_brata_logs.log" ] && tail -n 100 "$HOME/termox_brata_logs.log" || echo "Логов нет"; pause ;;
    2) echo "Dev mode включен (фейк)"; pause ;;
    3) rm -f "$HOME/termox_brata_logs.log" && echo "Логи удалены"; pause ;;
    *) return ;;
  esac
}

# --- Анимация загрузки Android ---
android_boot_animation(){
  tput civis
  local height=$(tput lines)
  local width=$(tput cols)

  # Comporation снизу
  for i in $(seq $height -1 1); do
    clear
    tput cup $i $(( (width - 11)/2 ))
    echo "Comporation"
    sleep 0.03
  done

  # Android снизу
  for i in $(seq $height -1 1); do
    clear
    tput cup $i $(( (width - 7)/2 ))
    echo "Android"
    sleep 0.03
  done

  sleep 0.3
  clear

  # Install + файлы системы
  local files=(boot.img system.img data.img vendor.img cache.img init.rc build.prop services.jar framework.jar)
  tput cup 0 0
  echo -e "\033[1;33mInstall\033[0m"
  echo
  for f in "${files[@]}"; do
    echo "Processing: $f"
    sleep 0.1
  done

  echo
  echo "Installer Android"
  tput cnorm
  sleep 0.5
  clear
}

# --- Меню ---
main_menu(){
  load_theme
  android_boot_animation
  while true; do
    clear
    show_logo
    echo "${_A}1)${_reset} Консоль Shell        2) Информация о системе"
    echo "${_A}3)${_reset} Менеджер пакетов      4) Запуск Python"
    echo "${_A}5)${_reset} Темы интерфейса       6) Обновить брата"
    echo "${_A}7)${_reset} Выключить Termux      0) Выход"
    echo "────────────────────────────────"
    read -rp "Выбор: " choice

    case "$choice" in
      1) bash ;;
      2) uname -a; df -h; pause ;;
      3) read -rp "Введите команду pkg: " pcmd; [ -n "$pcmd" ] && pkg $pcmd || echo "Отмена"; pause ;;
      4) command -v python3 >/dev/null && python3 || python; pause ;;
      5) echo "Темы: 1) neon 2) matrix 3) dark 4) red"; read -rp "Выбор: " t; case $t in 1) save_theme neon ;;2) save_theme matrix ;;3) save_theme dark ;;4) save_theme red ;;*) echo "Отмена";; esac; pause ;;
      6) echo "Обновление (демо)"; sleep 1; pause ;;
      7) read -rp "Завершить Termux? (y/N): " ans; [[ $ans =~ [Yy] ]] && kill -TERM $PPID || pause ;;
      0) echo "Пока, брат!"; exit 0 ;;
      777) secret_menu ;;
      *) echo "Неверный выбор"; sleep 0.5 ;;
    esac
  done
}

# --- Запуск ---
main_menu
