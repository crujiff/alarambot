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
**Compile token.txt**  
Here you've to insert the api token generated on the previous step  
**Compile dist_list.txt**  
Here you have to insert all the telegram id that you want to reach with this bot  
**Compile hostname.txt**  
*machine_to_monitor  monitor_user %free_ram %free_cpu %free_fs*  
Example:  
  ```
  host1 Vito 5 5 20
  host2 Vito 10 10 50
  ```
