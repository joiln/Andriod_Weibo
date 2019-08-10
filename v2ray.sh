#!/bin/bash

red='\e[91m'
green='\e[92m'
yellow='\e[93m'
magenta='\e[95m'
cyan='\e[96m'
none='\e[0m'
_red() { echo -e ${red}$*${none}; }
_green() { echo -e ${green}$*${none}; }
_yellow() { echo -e ${yellow}$*${none}; }
_magenta() { echo -e ${magenta}$*${none}; }
_cyan() { echo -e ${cyan}$*${none}; }

# Root
[[ $(id -u) != 0 ]] && echo -e "\n ��ѽ������ʹ�� ${red}root ${none}�û����� ${yellow}~(^_^) ${none}\n" && exit 1

cmd="apt-get"

sys_bit=$(uname -m)

case $sys_bit in
i[36]86)
	v2ray_bit="32"
	caddy_arch="386"
	;;
x86_64)
	v2ray_bit="64"
	caddy_arch="amd64"
	;;
*armv6*)
	v2ray_bit="arm"
	caddy_arch="arm6"
	;;
*armv7*)
	v2ray_bit="arm"
	caddy_arch="arm7"
	;;
*aarch64* | *armv8*)
	v2ray_bit="arm64"
	caddy_arch="arm64"
	;;
*)
	echo -e " 
	����������� ${red}�����ű�${none} ��֧�����ϵͳ�� ${yellow}(-_-) ${none}

	��ע: ��֧�� Ubuntu 16+ / Debian 8+ / CentOS 7+ ϵͳ
	" && exit 1
	;;
esac

# �����ļ�ⷽ��
if [[ $(command -v apt-get) || $(command -v yum) ]] && [[ $(command -v systemctl) ]]; then

	if [[ $(command -v yum) ]]; then

		cmd="yum"

	fi

else

	echo -e " 
	����������� ${red}�����ű�${none} ��֧�����ϵͳ�� ${yellow}(-_-) ${none}

	��ע: ��֧�� Ubuntu 16+ / Debian 8+ / CentOS 7+ ϵͳ
	" && exit 1

fi

uuid=$(cat /proc/sys/kernel/random/uuid)
old_id="e55c8d17-2cf3-b21a-bcf1-eeacb011ed79"
v2ray_server_config="/etc/v2ray/config.json"
v2ray_client_config="/etc/v2ray/233blog_v2ray_config.json"
backup="/etc/v2ray/233blog_v2ray_backup.conf"
_v2ray_sh="/usr/local/sbin/v2ray"
systemd=true
# _test=true

transport=(
	TCP
	TCP_HTTP
	WebSocket
	"WebSocket + TLS"
	HTTP/2
	mKCP
	mKCP_utp
	mKCP_srtp
	mKCP_wechat-video
	mKCP_dtls
	mKCP_wireguard
	QUIC
	QUIC_utp
	QUIC_srtp
	QUIC_wechat-video
	QUIC_dtls
	QUIC_wireguard
	TCP_dynamicPort
	TCP_HTTP_dynamicPort
	WebSocket_dynamicPort
	mKCP_dynamicPort
	mKCP_utp_dynamicPort
	mKCP_srtp_dynamicPort
	mKCP_wechat-video_dynamicPort
	mKCP_dtls_dynamicPort
	mKCP_wireguard_dynamicPort
	QUIC_dynamicPort
	QUIC_utp_dynamicPort
	QUIC_srtp_dynamicPort
	QUIC_wechat-video_dynamicPort
	QUIC_dtls_dynamicPort
	QUIC_wireguard_dynamicPort
)

ciphers=(
	aes-128-cfb
	aes-256-cfb
	chacha20
	chacha20-ietf
	aes-128-gcm
	aes-256-gcm
	chacha20-ietf-poly1305
)

_load() {
	local _dir="/etc/v2ray/233boy/v2ray/src/"
	. "${_dir}$@"
}
_sys_timezone() {
	IS_OPENVZ=
	if hostnamectl status | grep -q openvz; then
		IS_OPENVZ=1
	fi

	echo
	timedatectl set-timezone Asia/Shanghai
	timedatectl set-ntp true
	echo "�ѽ������������ΪAsia/Shanghaiʱ����ͨ��systemd-timesyncd�Զ�ͬ��ʱ�䡣"
	echo

	if [[ $IS_OPENVZ ]]; then
		echo
		echo -e "�����������Ϊ ${yellow}Openvz${none} ������ʹ��${yellow}v2ray mkcp${none}ϵ��Э�顣"
		echo -e "ע�⣺${yellow}Openvz${none} ϵͳʱ���޷���������ڳ������ͬ����"
		echo -e "�������ʱ���ʵ�����${yellow}����90��${none}��v2ray���޷�����ͨ�ţ��뷢ticket��ϵvps�����̵�����"
	fi
}

_sys_time() {
	echo -e "\n����ʱ�䣺${yellow}"
	timedatectl status | sed -n '1p;4p'
	echo -e "${none}"
	[[ $IS_OPENV ]] && pause
}
v2ray_config() {
	# clear
	echo
	while :; do
		echo -e "��ѡ�� "$yellow"V2Ray"$none" ����Э�� [${magenta}1-${#transport[*]}$none]"
		echo
		for ((i = 1; i <= ${#transport[*]}; i++)); do
			Stream="${transport[$i - 1]}"
			if [[ "$i" -le 9 ]]; then
				# echo
				echo -e "$yellow  $i. $none${Stream}"
			else
				# echo
				echo -e "$yellow $i. $none${Stream}"
			fi
		done
		echo
		echo "��ע1: ���� [dynamicPort] �ļ����ö�̬�˿�.."
		echo "��ע2: [utp | srtp | wechat-video | dtls | wireguard] �ֱ�αװ�� [BT���� | ��Ƶͨ�� | ΢����Ƶͨ�� | DTLS 1.2 ���ݰ� | WireGuard ���ݰ�]"
		echo
		read -p "$(echo -e "(Ĭ��Э��: ${cyan}TCP$none)"):" v2ray_transport
		[ -z "$v2ray_transport" ] && v2ray_transport=1
		case $v2ray_transport in
		[1-9] | [1-2][0-9] | 3[0-2])
			echo
			echo
			echo -e "$yellow V2Ray ����Э�� = $cyan${transport[$v2ray_transport - 1]}$none"
			echo "----------------------------------------------------------------"
			echo
			break
			;;
		*)
			error
			;;
		esac
	done
	v2ray_port_config
}
v2ray_port_config() {
	case $v2ray_transport in
	4 | 5)
		tls_config
		;;
	*)
		local random=$(shuf -i20001-65535 -n1)
		while :; do
			echo -e "������ "$yellow"V2Ray"$none" �˿� ["$magenta"1-65535"$none"]"
			read -p "$(echo -e "(Ĭ�϶˿�: ${cyan}${random}$none):")" v2ray_port
			[ -z "$v2ray_port" ] && v2ray_port=$random
			case $v2ray_port in
			[1-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9] | [1-5][0-9][0-9][0-9][0-9] | 6[0-4][0-9][0-9][0-9] | 65[0-4][0-9][0-9] | 655[0-3][0-5])
				echo
				echo
				echo -e "$yellow V2Ray �˿� = $cyan$v2ray_port$none"
				echo "----------------------------------------------------------------"
				echo
				break
				;;
			*)
				error
				;;
			esac
		done
		if [[ $v2ray_transport -ge 18 ]]; then
			v2ray_dynamic_port_start
		fi
		;;
	esac
}

v2ray_dynamic_port_start() {

	while :; do
		echo -e "������ "$yellow"V2Ray ��̬�˿ڿ�ʼ "$none"��Χ ["$magenta"1-65535"$none"]"
		read -p "$(echo -e "(Ĭ�Ͽ�ʼ�˿�: ${cyan}10000$none):")" v2ray_dynamic_port_start_input
		[ -z $v2ray_dynamic_port_start_input ] && v2ray_dynamic_port_start_input=10000
		case $v2ray_dynamic_port_start_input in
		$v2ray_port)
			echo
			echo " ���ܺ� V2Ray �˿�һëһ��...."
			echo
			echo -e " ��ǰ V2Ray �˿ڣ�${cyan}$v2ray_port${none}"
			error
			;;
		[1-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9] | [1-5][0-9][0-9][0-9][0-9] | 6[0-4][0-9][0-9][0-9] | 65[0-4][0-9][0-9] | 655[0-3][0-5])
			echo
			echo
			echo -e "$yellow V2Ray ��̬�˿ڿ�ʼ = $cyan$v2ray_dynamic_port_start_input$none"
			echo "----------------------------------------------------------------"
			echo
			break
			;;
		*)
			error
			;;
		esac

	done

	if [[ $v2ray_dynamic_port_start_input -lt $v2ray_port ]]; then
		lt_v2ray_port=true
	fi

	v2ray_dynamic_port_end
}
v2ray_dynamic_port_end() {

	while :; do
		echo -e "������ "$yellow"V2Ray ��̬�˿ڽ��� "$none"��Χ ["$magenta"1-65535"$none"]"
		read -p "$(echo -e "(Ĭ�Ͻ����˿�: ${cyan}20000$none):")" v2ray_dynamic_port_end_input
		[ -z $v2ray_dynamic_port_end_input ] && v2ray_dynamic_port_end_input=20000
		case $v2ray_dynamic_port_end_input in
		[1-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9] | [1-5][0-9][0-9][0-9][0-9] | 6[0-4][0-9][0-9][0-9] | 65[0-4][0-9][0-9] | 655[0-3][0-5])

			if [[ $v2ray_dynamic_port_end_input -le $v2ray_dynamic_port_start_input ]]; then
				echo
				echo " ����С�ڻ���� V2Ray ��̬�˿ڿ�ʼ��Χ"
				echo
				echo -e " ��ǰ V2Ray ��̬�˿ڿ�ʼ��${cyan}$v2ray_dynamic_port_start_input${none}"
				error
			elif [ $lt_v2ray_port ] && [[ ${v2ray_dynamic_port_end_input} -ge $v2ray_port ]]; then
				echo
				echo " V2Ray ��̬�˿ڽ�����Χ ���ܰ��� V2Ray �˿�..."
				echo
				echo -e " ��ǰ V2Ray �˿ڣ�${cyan}$v2ray_port${none}"
				error
			else
				echo
				echo
				echo -e "$yellow V2Ray ��̬�˿ڽ��� = $cyan$v2ray_dynamic_port_end_input$none"
				echo "----------------------------------------------------------------"
				echo
				break
			fi
			;;
		*)
			error
			;;
		esac

	done

}

tls_config() {

	echo
	local random=$(shuf -i20001-65535 -n1)
	while :; do
		echo -e "������ "$yellow"V2Ray"$none" �˿� ["$magenta"1-65535"$none"]������ѡ�� "$magenta"80"$none" �� "$magenta"443"$none" �˿�"
		read -p "$(echo -e "(Ĭ�϶˿�: ${cyan}${random}$none):")" v2ray_port
		[ -z "$v2ray_port" ] && v2ray_port=$random
		case $v2ray_port in
		80)
			echo
			echo " ...��˵�˲���ѡ�� 80 �˿��˿�....."
			error
			;;
		443)
			echo
			echo " ..��˵�˲���ѡ�� 443 �˿��˿�....."
			error
			;;
		[1-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9] | [1-5][0-9][0-9][0-9][0-9] | 6[0-4][0-9][0-9][0-9] | 65[0-4][0-9][0-9] | 655[0-3][0-5])
			echo
			echo
			echo -e "$yellow V2Ray �˿� = $cyan$v2ray_port$none"
			echo "----------------------------------------------------------------"
			echo
			break
			;;
		*)
			error
			;;
		esac
	done

	while :; do
		echo
		echo -e "������һ�� $magenta��ȷ������$none��һ��һ��һ��Ҫ��ȷ�������ܣ�������"
		read -p "(���磺www.baidu.com): " domain
		[ -z "$domain" ] && error && continue
		echo
		echo
		echo -e "$yellow ������� = $cyan$domain$none"
		echo "----------------------------------------------------------------"
		break
	done
	get_ip
	echo
	echo
	echo -e "$yellow �뽫 $magenta$domain$none $yellow������: $cyan$ip$none"
	echo
	echo -e "$yellow �뽫 $magenta$domain$none $yellow������: $cyan$ip$none"
	echo
	echo -e "$yellow �뽫 $magenta$domain$none $yellow������: $cyan$ip$none"
	echo "----------------------------------------------------------------"
	echo

	while :; do

		read -p "$(echo -e "(�Ƿ��Ѿ���ȷ����: [${magenta}Y$none]):") " record
		if [[ -z "$record" ]]; then
			error
		else
			if [[ "$record" == [Yy] ]]; then
				domain_check
				echo
				echo
				echo -e "$yellow �������� = ${cyan}��ȷ���Ѿ��н�����$none"
				echo "----------------------------------------------------------------"
				echo
				break
			else
				error
			fi
		fi

	done

	if [[ $v2ray_transport -ne 5 ]]; then
		auto_tls_config
	else
		caddy=true
		install_caddy_info="��"
	fi

	if [[ $caddy ]]; then
		path_config_ask
	fi
}
auto_tls_config() {
	echo -e "

		��װ Caddy ��ʵ�� �Զ����� TLS
		
		������Ѿ���װ Nginx �� Caddy

		$yellow����..�Լ��ܸ㶨���� TLS$none

		��ô�Ͳ���Ҫ ���Զ����� TLS
		"
	echo "----------------------------------------------------------------"
	echo

	while :; do

		read -p "$(echo -e "(�Ƿ��Զ����� TLS: [${magenta}Y/N$none]):") " auto_install_caddy
		if [[ -z "$auto_install_caddy" ]]; then
			error
		else
			if [[ "$auto_install_caddy" == [Yy] ]]; then
				caddy=true
				install_caddy_info="��"
				echo
				echo
				echo -e "$yellow �Զ����� TLS = $cyan$install_caddy_info$none"
				echo "----------------------------------------------------------------"
				echo
				break
			elif [[ "$auto_install_caddy" == [Nn] ]]; then
				install_caddy_info="�ر�"
				echo
				echo
				echo -e "$yellow �Զ����� TLS = $cyan$install_caddy_info$none"
				echo "----------------------------------------------------------------"
				echo
				break
			else
				error
			fi
		fi

	done
}
path_config_ask() {
	echo
	while :; do
		echo -e "�Ƿ��� ��վαװ �� ·������ [${magenta}Y/N$none]"
		read -p "$(echo -e "(Ĭ��: [${cyan}N$none]):")" path_ask
		[[ -z $path_ask ]] && path_ask="n"

		case $path_ask in
		Y | y)
			path_config
			break
			;;
		N | n)
			echo
			echo
			echo -e "$yellow ��վαװ �� ·������ = $cyan��������$none"
			echo "----------------------------------------------------------------"
			echo
			break
			;;
		*)
			error
			;;
		esac
	done
}
path_config() {
	echo
	while :; do
		echo -e "��������Ҫ ${magenta}����������·��$none , ���� /myv2ray , ��ôֻ��Ҫ���� myv2ray ����"
		read -p "$(echo -e "(Ĭ��: [${cyan}myv2ray$none]):")" path
		[[ -z $path ]] && path="myv2ray"

		case $path in
		*[/$]*)
			echo
			echo -e " ��������ű�̫������..���Է�����·�����ܰ���$red / $none��$red $ $none����������.... "
			echo
			error
			;;
		*)
			echo
			echo
			echo -e "$yellow ������·�� = ${cyan}/${path}$none"
			echo "----------------------------------------------------------------"
			echo
			break
			;;
		esac
	done
	is_path=true
	proxy_site_config
}
proxy_site_config() {
	echo
	while :; do
		echo -e "������ ${magenta}һ����ȷ��$none ${cyan}��ַ$none ������Ϊ ${cyan}��վ��αװ$none , ���� https://v2ray.com"
		echo -e "����...�㵱ǰ�������� $green$domain$none , αװ����ַ���� https://v2ray.com"
		echo -e "Ȼ����������ʱ��...��ʾ���������ݾ������� https://v2ray.com ������"
		echo -e "��ʵ����һ������...���׾ͺ�..."
		echo -e "�������αװ�ɹ�...����ʹ�� v2ray config �޸�αװ����ַ"
		read -p "$(echo -e "(Ĭ��: [${cyan}https://v2ray.com$none]):")" proxy_site
		[[ -z $proxy_site ]] && proxy_site="https://v2ray.com"

		case $proxy_site in
		*[#$]*)
			echo
			echo -e " ��������ű�̫������..����αװ����ַ���ܰ���$red # $none��$red $ $none����������.... "
			echo
			error
			;;
		*)
			echo
			echo
			echo -e "$yellow αװ����ַ = ${cyan}${proxy_site}$none"
			echo "----------------------------------------------------------------"
			echo
			break
			;;
		esac
	done
}

blocked_hosts() {
	echo
	while :; do
		echo -e "�Ƿ����������(��Ӱ������) [${magenta}Y/N$none]"
		read -p "$(echo -e "(Ĭ�� [${cyan}N$none]):")" blocked_ad
		[[ -z $blocked_ad ]] && blocked_ad="n"

		case $blocked_ad in
		Y | y)
			blocked_ad_info="����"
			ban_ad=true
			echo
			echo
			echo -e "$yellow ������� = $cyan����$none"
			echo "----------------------------------------------------------------"
			echo
			break
			;;
		N | n)
			blocked_ad_info="�ر�"
			echo
			echo
			echo -e "$yellow ������� = $cyan�ر�$none"
			echo "----------------------------------------------------------------"
			echo
			break
			;;
		*)
			error
			;;
		esac
	done
}
shadowsocks_config() {

	echo

	while :; do
		echo -e "�Ƿ����� ${yellow}Shadowsocks${none} [${magenta}Y/N$none]"
		read -p "$(echo -e "(Ĭ�� [${cyan}N$none]):") " install_shadowsocks
		[[ -z "$install_shadowsocks" ]] && install_shadowsocks="n"
		if [[ "$install_shadowsocks" == [Yy] ]]; then
			echo
			shadowsocks=true
			shadowsocks_port_config
			break
		elif [[ "$install_shadowsocks" == [Nn] ]]; then
			break
		else
			error
		fi

	done

}

shadowsocks_port_config() {
	local random=$(shuf -i20001-65535 -n1)
	while :; do
		echo -e "������ "$yellow"Shadowsocks"$none" �˿� ["$magenta"1-65535"$none"]�����ܺ� "$yellow"V2Ray"$none" �˿���ͬ"
		read -p "$(echo -e "(Ĭ�϶˿�: ${cyan}${random}$none):") " ssport
		[ -z "$ssport" ] && ssport=$random
		case $ssport in
		$v2ray_port)
			echo
			echo " ���ܺ� V2Ray �˿�һëһ��...."
			error
			;;
		[1-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9] | [1-5][0-9][0-9][0-9][0-9] | 6[0-4][0-9][0-9][0-9] | 65[0-4][0-9][0-9] | 655[0-3][0-5])
			if [[ $v2ray_transport == [45] ]]; then
				local tls=ture
			fi
			if [[ $tls && $ssport == "80" ]] || [[ $tls && $ssport == "443" ]]; then
				echo
				echo -e "��������ѡ���� "$green"WebSocket + TLS $none��$green HTTP/2"$none" ����Э��."
				echo
				echo -e "���Բ���ѡ�� "$magenta"80"$none" �� "$magenta"443"$none" �˿�"
				error
			elif [[ $v2ray_dynamic_port_start_input == $ssport || $v2ray_dynamic_port_end_input == $ssport ]]; then
				local multi_port="${v2ray_dynamic_port_start_input} - ${v2ray_dynamic_port_end_input}"
				echo
				echo " ��Ǹ���˶˿ں� V2Ray ��̬�˿� ��ͻ����ǰ V2Ray ��̬�˿ڷ�ΧΪ��$multi_port"
				error
			elif [[ $v2ray_dynamic_port_start_input -lt $ssport && $ssport -le $v2ray_dynamic_port_end_input ]]; then
				local multi_port="${v2ray_dynamic_port_start_input} - ${v2ray_dynamic_port_end_input}"
				echo
				echo " ��Ǹ���˶˿ں� V2Ray ��̬�˿� ��ͻ����ǰ V2Ray ��̬�˿ڷ�ΧΪ��$multi_port"
				error
			else
				echo
				echo
				echo -e "$yellow Shadowsocks �˿� = $cyan$ssport$none"
				echo "----------------------------------------------------------------"
				echo
				break
			fi
			;;
		*)
			error
			;;
		esac

	done

	shadowsocks_password_config
}
shadowsocks_password_config() {

	while :; do
		echo -e "������ "$yellow"Shadowsocks"$none" ����"
		read -p "$(echo -e "(Ĭ������: ${cyan}v2ray$none)"): " sspass
		[ -z "$sspass" ] && sspass="v2ray"
		case $sspass in
		*[/$]*)
			echo
			echo -e " ��������ű�̫������..�������벻�ܰ���$red / $none��$red $ $none����������.... "
			echo
			error
			;;
		*)
			echo
			echo
			echo -e "$yellow Shadowsocks ���� = $cyan$sspass$none"
			echo "----------------------------------------------------------------"
			echo
			break
			;;
		esac

	done

	shadowsocks_ciphers_config
}
shadowsocks_ciphers_config() {

	while :; do
		echo -e "��ѡ�� "$yellow"Shadowsocks"$none" ����Э�� [${magenta}1-${#ciphers[*]}$none]"
		for ((i = 1; i <= ${#ciphers[*]}; i++)); do
			ciphers_show="${ciphers[$i - 1]}"
			echo
			echo -e "$yellow $i. $none${ciphers_show}"
		done
		echo
		read -p "$(echo -e "(Ĭ�ϼ���Э��: ${cyan}${ciphers[6]}$none)"):" ssciphers_opt
		[ -z "$ssciphers_opt" ] && ssciphers_opt=7
		case $ssciphers_opt in
		[1-7])
			ssciphers=${ciphers[$ssciphers_opt - 1]}
			echo
			echo
			echo -e "$yellow Shadowsocks ����Э�� = $cyan${ssciphers}$none"
			echo "----------------------------------------------------------------"
			echo
			break
			;;
		*)
			error
			;;
		esac

	done
	pause
}

install_info() {
	clear
	echo
	echo " ....׼����װ�˿�..������ë��������ȷ��..."
	echo
	echo "---------- ��װ��Ϣ -------------"
	echo
	echo -e "$yellow V2Ray ����Э�� = $cyan${transport[$v2ray_transport - 1]}$none"

	if [[ $v2ray_transport == [45] ]]; then
		echo
		echo -e "$yellow V2Ray �˿� = $cyan$v2ray_port$none"
		echo
		echo -e "$yellow ������� = $cyan$domain$none"
		echo
		echo -e "$yellow �������� = ${cyan}��ȷ���Ѿ��н�����$none"
		echo
		echo -e "$yellow �Զ����� TLS = $cyan$install_caddy_info$none"

		if [[ $ban_ad ]]; then
			echo
			echo -e "$yellow ������� = $cyan$blocked_ad_info$none"
		fi
		if [[ $is_path ]]; then
			echo
			echo -e "$yellow ·������ = ${cyan}/${path}$none"
		fi
	elif [[ $v2ray_transport -ge 18 ]]; then
		echo
		echo -e "$yellow V2Ray �˿� = $cyan$v2ray_port$none"
		echo
		echo -e "$yellow V2Ray ��̬�˿ڷ�Χ = $cyan${v2ray_dynamic_port_start_input} - ${v2ray_dynamic_port_end_input}$none"

		if [[ $ban_ad ]]; then
			echo
			echo -e "$yellow ������� = $cyan$blocked_ad_info$none"
		fi
	else
		echo
		echo -e "$yellow V2Ray �˿� = $cyan$v2ray_port$none"

		if [[ $ban_ad ]]; then
			echo
			echo -e "$yellow ������� = $cyan$blocked_ad_info$none"
		fi
	fi
	if [ $shadowsocks ]; then
		echo
		echo -e "$yellow Shadowsocks �˿� = $cyan$ssport$none"
		echo
		echo -e "$yellow Shadowsocks ���� = $cyan$sspass$none"
		echo
		echo -e "$yellow Shadowsocks ����Э�� = $cyan${ssciphers}$none"
	else
		echo
		echo -e "$yellow �Ƿ����� Shadowsocks = ${cyan}δ����${none}"
	fi
	echo
	echo "---------- END -------------"
	echo
	pause
	echo
}

domain_check() {
	# if [[ $cmd == "yum" ]]; then
	# 	yum install bind-utils -y
	# else
	# 	$cmd install dnsutils -y
	# fi
	# test_domain=$(dig $domain +short)
	test_domain=$(ping $domain -c 1 | grep -oE -m1 "([0-9]{1,3}\.){3}[0-9]{1,3}")
	if [[ $test_domain != $ip ]]; then
		echo
		echo -e "$red ���������������....$none"
		echo
		echo -e " �������: $yellow$domain$none δ������: $cyan$ip$none"
		echo
		echo -e " ���������ǰ������: $cyan$test_domain$none"
		echo
		echo "��ע...������������ʹ�� Cloudflare �����Ļ�..�� Status �����һ����ͼ��..�������"
		echo
		exit 1
	fi
}

install_caddy() {
	# download caddy file then install
	_load download-caddy.sh
	_download_caddy_file
	_install_caddy_service
	caddy_config

}
caddy_config() {
	# local email=$(shuf -i1-10000000000 -n1)
	_load caddy-config.sh

	# systemctl restart caddy
	do_service restart caddy
}

install_v2ray() {
	$cmd update -y
	if [[ $cmd == "apt-get" ]]; then
		$cmd install -y lrzsz git zip unzip curl wget qrencode libcap2-bin dbus
	else
		# $cmd install -y lrzsz git zip unzip curl wget qrencode libcap iptables-services
		$cmd install -y lrzsz git zip unzip curl wget qrencode libcap
	fi
	ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
	[ -d /etc/v2ray ] && rm -rf /etc/v2ray
	# date -s "$(curl -sI g.cn | grep Date | cut -d' ' -f3-6)Z"
	_sys_timezone
	_sys_time

	if [[ $local_install ]]; then
		if [[ ! -d $(pwd)/config ]]; then
			echo
			echo -e "$red ��ѽѽ...��װʧ���˿�...$none"
			echo
			echo -e " ��ȷ�������������ϴ��� V2Ray һ����װ�ű� & ����ű�����ǰ ${green}$(pwd) $noneĿ¼��"
			echo
			exit 1
		fi
		mkdir -p /etc/v2ray/233boy/v2ray
		cp -rf $(pwd)/* /etc/v2ray/233boy/v2ray
	else
		pushd /tmp
		git clone https://github.com/233boy/v2ray -b "$_gitbranch" /etc/v2ray/233boy/v2ray --depth=1
		popd

	fi

	if [[ ! -d /etc/v2ray/233boy/v2ray ]]; then
		echo
		echo -e "$red ��ѽѽ...��¡�ű��ֿ������...$none"
		echo
		echo -e " ��ܰ��ʾ..... �볢�����а�װ Git: ${green}$cmd install -y git $none ֮���ٰ�װ�˽ű�"
		echo
		exit 1
	fi

	# download v2ray file then install
	_load download-v2ray.sh
	_download_v2ray_file
	_install_v2ray_service
	_mkdir_dir
}

open_port() {
	if [[ $cmd == "apt-get" ]]; then
		if [[ $1 != "multiport" ]]; then

			iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport $1 -j ACCEPT
			iptables -I INPUT -m state --state NEW -m udp -p udp --dport $1 -j ACCEPT
			ip6tables -I INPUT -m state --state NEW -m tcp -p tcp --dport $1 -j ACCEPT
			ip6tables -I INPUT -m state --state NEW -m udp -p udp --dport $1 -j ACCEPT

			# firewall-cmd --permanent --zone=public --add-port=$1/tcp
			# firewall-cmd --permanent --zone=public --add-port=$1/udp
			# firewall-cmd --reload

		else

			local multiport="${v2ray_dynamic_port_start_input}:${v2ray_dynamic_port_end_input}"
			iptables -I INPUT -p tcp --match multiport --dports $multiport -j ACCEPT
			iptables -I INPUT -p udp --match multiport --dports $multiport -j ACCEPT
			ip6tables -I INPUT -p tcp --match multiport --dports $multiport -j ACCEPT
			ip6tables -I INPUT -p udp --match multiport --dports $multiport -j ACCEPT

			# local multi_port="${v2ray_dynamic_port_start_input}-${v2ray_dynamic_port_end_input}"
			# firewall-cmd --permanent --zone=public --add-port=$multi_port/tcp
			# firewall-cmd --permanent --zone=public --add-port=$multi_port/udp
			# firewall-cmd --reload

		fi
		iptables-save >/etc/iptables.rules.v4
		ip6tables-save >/etc/iptables.rules.v6
		# else
		# 	service iptables save >/dev/null 2>&1
		# 	service ip6tables save >/dev/null 2>&1
	fi
}
del_port() {
	if [[ $cmd == "apt-get" ]]; then
		if [[ $1 != "multiport" ]]; then
			# if [[ $cmd == "apt-get" ]]; then
			iptables -D INPUT -m state --state NEW -m tcp -p tcp --dport $1 -j ACCEPT
			iptables -D INPUT -m state --state NEW -m udp -p udp --dport $1 -j ACCEPT
			ip6tables -D INPUT -m state --state NEW -m tcp -p tcp --dport $1 -j ACCEPT
			ip6tables -D INPUT -m state --state NEW -m udp -p udp --dport $1 -j ACCEPT
			# else
			# 	firewall-cmd --permanent --zone=public --remove-port=$1/tcp
			# 	firewall-cmd --permanent --zone=public --remove-port=$1/udp
			# fi
		else
			# if [[ $cmd == "apt-get" ]]; then
			local ports="${v2ray_dynamicPort_start}:${v2ray_dynamicPort_end}"
			iptables -D INPUT -p tcp --match multiport --dports $ports -j ACCEPT
			iptables -D INPUT -p udp --match multiport --dports $ports -j ACCEPT
			ip6tables -D INPUT -p tcp --match multiport --dports $ports -j ACCEPT
			ip6tables -D INPUT -p udp --match multiport --dports $ports -j ACCEPT
			# else
			# 	local ports="${v2ray_dynamicPort_start}-${v2ray_dynamicPort_end}"
			# 	firewall-cmd --permanent --zone=public --remove-port=$ports/tcp
			# 	firewall-cmd --permanent --zone=public --remove-port=$ports/udp
			# fi
		fi
		iptables-save >/etc/iptables.rules.v4
		ip6tables-save >/etc/iptables.rules.v6
		# else
		# 	service iptables save >/dev/null 2>&1
		# 	service ip6tables save >/dev/null 2>&1
	fi

}

config() {
	cp -f /etc/v2ray/233boy/v2ray/config/backup.conf $backup
	cp -f /etc/v2ray/233boy/v2ray/v2ray.sh $_v2ray_sh
	chmod +x $_v2ray_sh

	v2ray_id=$uuid
	alterId=233
	ban_bt=true
	if [[ $v2ray_transport -ge 18 ]]; then
		v2ray_dynamicPort_start=${v2ray_dynamic_port_start_input}
		v2ray_dynamicPort_end=${v2ray_dynamic_port_end_input}
	fi
	_load config.sh

	if [[ $cmd == "apt-get" ]]; then
		cat >/etc/network/if-pre-up.d/iptables <<-EOF
			#!/bin/sh
			/sbin/iptables-restore < /etc/iptables.rules.v4
			/sbin/ip6tables-restore < /etc/iptables.rules.v6
		EOF
		chmod +x /etc/network/if-pre-up.d/iptables
		# else
		# 	[ $(pgrep "firewall") ] && systemctl stop firewalld
		# 	systemctl mask firewalld
		# 	systemctl disable firewalld
		# 	systemctl enable iptables
		# 	systemctl enable ip6tables
		# 	systemctl start iptables
		# 	systemctl start ip6tables
	fi

	[[ $shadowsocks ]] && open_port $ssport
	if [[ $v2ray_transport == [45] ]]; then
		open_port "80"
		open_port "443"
		open_port $v2ray_port
	elif [[ $v2ray_transport -ge 18 ]]; then
		open_port $v2ray_port
		open_port "multiport"
	else
		open_port $v2ray_port
	fi
	# systemctl restart v2ray
	do_service restart v2ray
	backup_config

}

backup_config() {
	sed -i "18s/=1/=$v2ray_transport/; 21s/=2333/=$v2ray_port/; 24s/=$old_id/=$uuid/" $backup
	if [[ $v2ray_transport -ge 18 ]]; then
		sed -i "30s/=10000/=$v2ray_dynamic_port_start_input/; 33s/=20000/=$v2ray_dynamic_port_end_input/" $backup
	fi
	if [[ $shadowsocks ]]; then
		sed -i "42s/=/=true/; 45s/=6666/=$ssport/; 48s/=233blog.com/=$sspass/; 51s/=chacha20-ietf/=$ssciphers/" $backup
	fi
	[[ $v2ray_transport == [45] ]] && sed -i "36s/=233blog.com/=$domain/" $backup
	[[ $caddy ]] && sed -i "39s/=/=true/" $backup
	[[ $ban_ad ]] && sed -i "54s/=/=true/" $backup
	if [[ $is_path ]]; then
		sed -i "57s/=/=true/; 60s/=233blog/=$path/" $backup
		sed -i "63s#=https://liyafly.com#=$proxy_site#" $backup
	fi
}

get_ip() {
	ip=$(curl -s https://ipinfo.io/ip)
	[[ -z $ip ]] && ip=$(curl -s https://api.ip.sb/ip)
	[[ -z $ip ]] && ip=$(curl -s https://api.ipify.org)
	[[ -z $ip ]] && ip=$(curl -s https://ip.seeip.org)
	[[ -z $ip ]] && ip=$(curl -s https://ifconfig.co/ip)
	[[ -z $ip ]] && ip=$(curl -s https://api.myip.com | grep -oE "([0-9]{1,3}\.){3}[0-9]{1,3}")
	[[ -z $ip ]] && ip=$(curl -s icanhazip.com)
	[[ -z $ip ]] && ip=$(curl -s myip.ipip.net | grep -oE "([0-9]{1,3}\.){3}[0-9]{1,3}")
	[[ -z $ip ]] && echo -e "\n$red ������С�����˰ɣ�$none\n" && exit
}

error() {

	echo -e "\n$red �������$none\n"

}

pause() {

	read -rsp "$(echo -e "��$green Enter �س��� $none����....��$red Ctrl + C $noneȡ��.")" -d $'\n'
	echo
}
do_service() {
	if [[ $systemd ]]; then
		systemctl $1 $2
	else
		service $2 $1
	fi
}
show_config_info() {
	clear
	_load v2ray-info.sh
	_v2_args
	_v2_info
	_load ss-info.sh

}

install() {
	if [[ -f /usr/bin/v2ray/v2ray && -f /etc/v2ray/config.json ]] && [[ -f $backup && -d /etc/v2ray/233boy/v2ray ]]; then
		echo
		echo " ����...���Ѿ���װ V2Ray ��...�������°�װ"
		echo
		echo -e " $yellow���� ${cyan}v2ray${none} $yellow���ɹ��� V2Ray${none}"
		echo
		exit 1
	elif [[ -f /usr/bin/v2ray/v2ray && -f /etc/v2ray/config.json ]] && [[ -f /etc/v2ray/233blog_v2ray_backup.txt && -d /etc/v2ray/233boy/v2ray ]]; then
		echo
		echo "  �������Ҫ������װ.. ����ж�ؾɰ汾"
		echo
		echo -e " $yellow���� ${cyan}v2ray uninstall${none} $yellow����ж��${none}"
		echo
		exit 1
	fi
	v2ray_config
	blocked_hosts
	shadowsocks_config
	install_info
	# [[ $caddy ]] && domain_check
	install_v2ray
	if [[ $caddy || $v2ray_port == "80" ]]; then
		if [[ $cmd == "yum" ]]; then
			[[ $(pgrep "httpd") ]] && systemctl stop httpd
			[[ $(command -v httpd) ]] && yum remove httpd -y
		else
			[[ $(pgrep "apache2") ]] && service apache2 stop
			[[ $(command -v apache2) ]] && apt-get remove apache2* -y
		fi
	fi
	[[ $caddy ]] && install_caddy

	## bbr
	_load bbr.sh
	_try_enable_bbr

	get_ip
	config
	show_config_info
}
uninstall() {

	if [[ -f /usr/bin/v2ray/v2ray && -f /etc/v2ray/config.json ]] && [[ -f $backup && -d /etc/v2ray/233boy/v2ray ]]; then
		. $backup
		if [[ $mark ]]; then
			_load uninstall.sh
		else
			echo
			echo -e " $yellow���� ${cyan}v2ray uninstall${none} $yellow����ж��${none}"
			echo
		fi

	elif [[ -f /usr/bin/v2ray/v2ray && -f /etc/v2ray/config.json ]] && [[ -f /etc/v2ray/233blog_v2ray_backup.txt && -d /etc/v2ray/233boy/v2ray ]]; then
		echo
		echo -e " $yellow���� ${cyan}v2ray uninstall${none} $yellow����ж��${none}"
		echo
	else
		echo -e "
		$red ���ص�...��ò��ë�а�װ V2Ray ....ж�ظ�����Ŷ...$none

		��ע...��֧��ж��ʹ�ýű��ṩ�� V2Ray һ����װ�ű�
		" && exit 1
	fi

}

args=$1
_gitbranch=$2
[ -z $1 ] && args="online"
case $args in
online)
	#hello world
	[[ -z $_gitbranch ]] && _gitbranch="master"
	;;
local)
	local_install=true
	;;
*)
	echo
	echo -e " �������������� <$red $args $none> ...�����ʲô��...�ű�����ʶ����"
	echo
	echo -e " ��������ű���֧������$green local / online $none����"
	echo
	echo -e " ����$yellow local $none����ʹ�ñ��ذ�װ"
	echo
	echo -e " ����$yellow online $none����ʹ�����߰�װ (Ĭ��)"
	echo
	exit 1
	;;
esac

clear
while :; do
	echo
	echo "........... V2Ray һ����װ�ű� & ����ű�  .........."
	echo
	echo "����˵��: https://v2ray.com/"
	echo
	echo "��̳�: https://toutyrater.github.io/"
	echo
	echo " 1. ��װ"
	echo
	echo " 2. ж��"
	echo
	if [[ $local_install ]]; then
		echo -e "$yellow ��ܰ��ʾ.. ���ذ�װ������ ..$none"
		echo
	fi
	read -p "$(echo -e "��ѡ�� [${magenta}1-2$none]:")" choose
	case $choose in
	1)
		install
		break
		;;
	2)
		uninstall
		break
		;;
	*)
		error
		;;
	esac
done