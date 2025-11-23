# Домашние задания по курсу Terraform

---

## Структура репозитория

### [01-intro](01-intro/) - Введение в Terraform

**Выполненные задания:**

-  **Задание 1**: Базовая работа с Terraform (Docker контейнеры, random_password)
-  **Задание 2**: Remote Docker на Proxmox LXC с MySQL и генерируемыми паролями

 **[Полный отчёт с решениями →](01-intro/README.md)**

---

##  Используемые технологии

- **Terraform**: v1.14.0
- **Docker**: v29.0.2
- **Proxmox VE**: v9.0.3
- **ОС**: macOS, Ubuntu 22.04

---

##  Особенности выполнения

- Вместо Yandex Cloud используется **локальный Proxmox сервер** с LXC контейнерами
- Автоматизация установки Docker через Terraform provisioners
- Remote Docker управление через SSH
- Генерация случайных паролей для баз данных

