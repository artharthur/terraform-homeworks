# Задание 5: Использование Terraform в команде

## Задание 1: Проверка кода линтерами

### Использованные инструменты

**TFLint** - линтер для Terraform кода
**Checkov** - сканер безопасности для Infrastructure as Code

### Проверяемый код

Код из Задания 4 (модули для Proxmox LXC контейнеров и VPC).

### Результаты TFLint
```
Warning: [Fixable] variable "network_bridge" is declared but not used
(terraform_unused_declarations)

  on variables.tf line 23:
  23: variable "network_bridge" {

Reference: https://github.com/terraform-linters/tflint-ruleset-terraform/blob/v0.13.0/docs/rules/terraform_unused_declarations.md
```

**Найденные проблемы:**
- Неиспользуемая переменная `network_bridge` в файле `variables.tf`

**Тип ошибки:** Неиспользуемые объявления (Unused declarations)

### Результаты Checkov
```
terraform framework : 100%
secrets framework   : 100%
```

**Результат:** Проблем безопасности не найдено 

### Типы ошибок обнаруженных в проекте

1. **Неиспользуемые переменные** (terraform_unused_declarations)
   - Переменная объявлена но не используется в коде
   - Уровень: Warning
   - Исправление: Удалить неиспользуемую переменную или начать её использовать

### Исправление

Переменная `network_bridge` используется в `main.tf` при вызове модулей:
```hcl
network_bridge = module.vpc_dev.network_bridge
```

Ложное срабатывание - переменная передаётся из outputs модуля vpc.

### Выводы

- TFLint помогает найти неиспользуемый код и потенциальные проблемы
- Checkov проверяет безопасность инфраструктуры
- Код прошёл проверку безопасности
- Найдена 1 потенциальная проблема с неиспользуемой переменной (ложное срабатывание)

### Рекомендации

1. Запускать линтеры перед коммитом
2. Добавить в CI/CD pipeline автоматическую проверку
3. Исправлять все warnings для чистоты кода

