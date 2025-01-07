#!/bin/sh
# login.sh
# ----------------------------------------------------
# 这里写死用户名、密码、MAC、运营商，不再对它们做 sed。
# 只在 URL 中用 __IP__ 作为替换占位符。

# 日志文件(可自行修改到可写目录)
LOGFILE="/data/runlog.txt"

# 在 URL 中，username/password/MAC 都是写死的
# 唯一要动态替换的 IP 用 __IP__
LOGIN_URL="http://10.50.255.11:801/eportal/portal/login?callback=dr1003&login_method=1&user_account=,1,202400000000@telecom&user_password=1234567890&wlan_user_ip=__IP__&wlan_user_ipv6=&wlan_user_mac=000000000000&wlan_ac_ip=&wlan_ac_name=&jsVersion=4.1.3&terminal_type=1&lang=zh-cn&v=1640&lang=zh"

echo "************** 开始执行 login.sh **************"
echo "当前使用的登录URL: $LOGIN_URL"

{
  echo "====================================="
  echo "[`date '+%Y-%m-%d %H:%M:%S'`] 开始执行 login.sh"
  echo "[`date '+%Y-%m-%d %H:%M:%S'`] LOGIN_URL=$LOGIN_URL"
} >> "$LOGFILE" 2>/dev/null

# 1) 发起登录请求
curl -s "$LOGIN_URL" -o /data/login_result.txt

echo "************** 登录请求已发送 **************"
echo "返回内容(前5行)："
head -n 5 /data/login_result.txt

{
  echo "[`date '+%Y-%m-%d %H:%M:%S'`] 已发送登录请求"
  echo "返回前5行："
  head -n 5 /data/login_result.txt
} >> "$LOGFILE" 2>/dev/null

# 2) 等几秒让网络切换生效
sleep 3

# 3) 测试网络连通性
ret_code=$(curl -I -s --connect-timeout 5 "www.baidu.com" -w "%{http_code}" -o /dev/null)
if [ "x$ret_code" = "x200" ]; then
    echo "网络已通，登录成功。"
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] 登录成功，网络已通。" >> "$LOGFILE" 2>/dev/null
else
    echo "登录失败或网络不通。"
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] 登录失败或网络不通，ret_code=$ret_code" >> "$LOGFILE" 2>/dev/null
fi
