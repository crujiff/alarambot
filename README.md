# Alarmbot
A script that monitors machine and send alert through telegram
## Prerequisites
Passwordless ssh from monitoring machine and machine to monitor </br>
**How to do this**</br>
From monitoring machine:</br>
`ssh-keygen -t rsa `</br>
`ssh *monitor_user*@*machine_to_monitor* mkdir -p .ssh `</br>
` cat .ssh/id_rsa.pub | ssh *monitor_user*@*machine_to_monitor* 'cat >> .ssh/authorized_keys'`</br>`
