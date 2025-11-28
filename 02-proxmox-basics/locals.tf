locals {
  # Общие параметры для именования
  project_name = "netology"
  env_name     = "develop"
  
  # Формируем имена контейнеров через интерполяцию
  vm_web_name = "${local.project_name}-${local.env_name}-platform-web"
  vm_db_name  = "${local.project_name}-${local.env_name}-platform-db"
}
