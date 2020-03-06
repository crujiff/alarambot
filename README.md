# Alarmbot
A script that monitors machine and send alert through telegram
## Prerequisites
1. Passwordless ssh
  **How to do this**</br>
  From monitoring machine:</br>
  ```
  ssh-keygen -t rsa
  ssh monitor_user@machine_to_monitor mkdir -p .ssh
  cat .ssh/id_rsa.pub | ssh monitor_user@machine_to_monitor 'cat >> .ssh/authorized_keys'
  ```
  On machine to monitor
  ```
  ssh monitor_user@machine_to_monitor
  chmod go-w ~/
  chmod 700 ~/.ssh
  chmod 600 ~/.ssh/authorized_keys
  ```
2. Create Telegram Bot
Follow the [official documentation]  (https://core.telegram.org/bots#6-botfather)
