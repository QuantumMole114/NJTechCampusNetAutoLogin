#!/bin/sh
install() {
        # Add script to system autostart docker
        uci set firewall.startup_script=include
        uci set firewall.startup_script.type='script'
        uci set firewall.startup_script.path="/data/startup_script.sh"
        uci set firewall.startup_script.enabled='1'
        uci commit firewall
        echo -e "\033[32m  startup_script complete. \033[0m"
}
uninstall() {
    # Remove scripts from system autostart
    uci delete firewall.startup_script
    uci commit firewall
    echo -e "\033[33m startup_script  has been removed. \033[0m"
}

startup_script() {
        # Put your custom script here.
        echo "Starting custom scripts..." >> /data/autoLogin.log
        echo "Start time: $(date)" >> /data/autoLogin.log

        chmod +x /data/autoLogin.sh >> /data/autoLogin.log 2>&1
        chmod +x /data/login.sh >> /data/autoLogin.log 2>&1
        chmod +x /data/login_base.sh >> /data/autoLogin.log 2>&1
        
        echo "Permissions set." >> /data/autoLogin.log

        sleep 90
        echo "Executing autoLogin.sh..." >> /data/autoLogin.log
        sh /data/autoLogin.sh >> /data/autoLogin.log 2>&1 &
}

main() {
    [ -z "$1" ] && startup_script && return
    case "$1" in
    install)
        install
        ;;
    uninstall)
        uninstall
        ;;
    *)
        echo -e "\033[31m Unknown parameter: $1 \033[0m"
        return 1
        ;;
    esac
}


main "$@"