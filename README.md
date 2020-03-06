# Alarmbot
A script that monitors machine and send alert through telegram
## Prerequisites
**Passwordless ssh**  
From monitoring machine:  
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
**Telegram bot**  
Follow the [official documentation](https://core.telegram.org/bots#6-botfather)
