# Ghostty Terminal Configuration

Настройки GPU-ускоренного терминала Ghostty под macOS.

---

## Особенности
* Цветовая палитра Catppuccin Mocha.
* Поддержка прозрачности под фон рабочего стола.
* Оптимизированные отступы и поддержка Nerd Font для иконок статус-лайнов и дерева файлов.

---

## Установка на новом Mac

### 1. Установка Ghostty и шрифта
```bash
brew install --cask ghostty font-jetbrains-mono-nerd-font
```

### 2. Клонирование конфига
```bash
git clone git@github.com:CaesarFTPR/ghostty-config.git ~/.config/ghostty
```

### 3. Применение изменений
Если терминал уже запущен, нажмите `Cmd + Shift + ,` для мгновенной перезагрузки настроек без перезапуска сессии.
