#!/bin/bash
export LANG=en_US.UTF-8
if [[ -f /root/cfipopw/txt.zip && -f /root/cfipopw/informlog ]]; then
echo
echo "请稍等，对优选反代IP进行地区识别，最多显示前10个IP"
rm -rf cdnIP.csv b.csv a.csv
awk -F ',' 'NR>1 && NR<=11 {print $1}' result.csv > a.csv
while IFS= read -r ip_address; do
UA_Browser="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36"
response=$(curl -sm5 --user-agent "${UA_Browser}" "https://api.ip.sb/geoip/$ip_address" -k | awk -F "country_code" '{print $2}' | awk -F'":"|","|"' '{print $2}')
if [ $? -eq 0 ]; then
echo "IP地址 $ip_address 的地区是: $response" | tee -a b.csv
else
echo "无法获取IP地址 $ip_address 的地区信息" | tee -a b.csv
fi
sleep 1
done < "a.csv"
echo -e "\n优选反代IP--国家地区识别" >> cdnIP.csv
cat b.csv >> cdnIP.csv
#grep 'SG' b.csv | head -n 10 >> cdnIP.csv
#grep 'HK' b.csv | head -n 10 >> cdnIP.csv
#grep 'JP' b.csv | head -n 10 >> cdnIP.csv
#grep 'KR' b.csv | head -n 10 >> cdnIP.csv
#grep 'TW' b.csv | head -n 10 >> cdnIP.csv
#grep 'US' b.csv | head -n 10 >> cdnIP.csv
#grep 'GB' b.csv | head -n 10 >> cdnIP.csv
#grep 'DE' b.csv | head -n 10 >> cdnIP.csv
#grep 'NL' b.csv | head -n 10 >> cdnIP.csv
#grep 'FR' b.csv | head -n 10 >> cdnIP.csv
echo
cat cdnIP.csv >> informlog
fi
if [[ -f /root/cfipopw/txt.zip && ! -f /root/cfipopw/informlog ]]; then
echo "下载更新反代IP库（来源：ymyuuu/IPDB）……"
curl -sL -m30 --retry 2 "https://ipdb.api.030101.xyz/?type=bestproxy;proxy" | tr -d '\r' | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | awk '!s[$0]++' > ip.new
if [ -s ip.new ]; then
mv -f ip.new ip.txt
echo "下载成功，共$(wc -l < ip.txt)个反代IP"
else
rm -f ip.new
if [ -s ip.txt ]; then
echo "下载失败，继续使用之前的反代IP库"
else
echo "反代IP库下载失败" && exit
fi
fi
fi
