# Infraestrutura como Código: Servidor Web Apache

Script Bash para **provisionar automaticamente um servidor web Apache** em Linux, conforme o desafio de projeto da [DIO — Digital Innovation One](https://www.dio.me/).

Um servidor web usa o protocolo **HTTP** (e outros) para receber solicitações de clientes na World Wide Web. Ele armazena, processa e entrega páginas aos usuários. Neste projeto, essa configuração deixa de ser manual e passa a ser feita por um único script reutilizável (conceito de **IaC — Infrastructure as Code**).

---

## Objetivo do desafio

Automatizar, em um servidor Linux, as seguintes etapas:

1. Atualizar o sistema operacional
2. Instalar o **Apache2**
3. Instalar o **unzip**
4. Baixar a aplicação de exemplo no diretório `/tmp`
5. Copiar os arquivos da aplicação para o diretório padrão do Apache (`/var/www/html`)
6. Garantir que o serviço Apache esteja ativo

Aplicação utilizada no desafio:

- [denilsonbonatti/linux-site-dio](https://github.com/denilsonbonatti/linux-site-dio)  
- Arquivo ZIP: `https://github.com/denilsonbonatti/linux-site-dio/archive/refs/heads/main.zip`

---

## Estrutura do repositório

```text
servidor-apache/
├── provisionar-servidor-web.sh   # Script de provisionamento (IaC)
└── README.md                     # Documentação do projeto
```

---

## Requisitos

| Item | Detalhe |
|------|---------|
| Sistema operacional | Distribuição baseada em Debian/Ubuntu |
| Permissões | Execução como `root` (`sudo`) |
| Rede | Acesso à internet (download do site e pacotes) |
| Pacotes usados no script | `apt-get`, `wget`, `unzip`, `apache2`, `systemctl` |

Ambiente sugerido para testes: máquina virtual (VirtualBox, VMware, Hyper-V) com Ubuntu Server.

---

## O que o script faz

O arquivo `provisionar-servidor-web.sh` executa, em ordem:

| Etapa | Ação |
|-------|------|
| 1 | `apt-get update` e `apt-get upgrade` — atualiza índices e pacotes |
| 2 | Instala `apache2` e `unzip` |
| 3 | Baixa o ZIP da aplicação para `/tmp/main.zip` com `wget` |
| 4 | Descompacta o arquivo em `/tmp/linux-site-dio-main` |
| 5 | Copia o conteúdo para `/var/www/html` |
| 6 | Reinicia e habilita o serviço `apache2` |

O script usa `set -euo pipefail` para interromper a execução em caso de erro e valida se está sendo executado como root antes de continuar.

---

## Como executar

### 1. Transferir o script para o servidor Linux

Clone o repositório ou copie o arquivo `provisionar-servidor-web.sh` para a VM/servidor.

```bash
git clone <URL_DO_SEU_REPOSITORIO>
cd servidor-apache
```

### 2. Conceder permissão de execução

```bash
chmod +x provisionar-servidor-web.sh
```

### 3. Executar como root

```bash
sudo ./provisionar-servidor-web.sh
```

Aguarde a conclusão. Ao final, o script exibe o status do Apache e o IP sugerido para acesso.

### 4. Acessar o site

Descubra o IP da máquina (se ainda não souber):

```bash
hostname -I
# ou
ip a
```

No navegador (da máquina host ou de outro dispositivo na mesma rede):

```text
http://IP_DA_MAQUINA
```

---

## Fluxo resumido

```text
┌─────────────────┐
│  apt update /   │
│  apt upgrade    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Instala apache2 │
│    e unzip      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ wget + unzip    │
│  (site no /tmp) │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Copia para      │
│ /var/www/html   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ restart apache2 │
│ site no ar HTTP │
└─────────────────┘
```

---

## Verificações úteis

```bash
# Serviço Apache ativo?
systemctl status apache2

# Conteúdo publicado?
ls -la /var/www/html

# Teste local via HTTP
curl -I http://localhost
```

---

## Conceitos envolvidos

- **Servidor web**: software (Apache) + host Linux que responde a requisições HTTP.
- **Apache HTTP Server**: servidor web amplamente usado em ambientes Linux.
- **IaC (Infrastructure as Code)**: infraestrutura definida e versionada em arquivos (aqui, um shell script), reduzindo erros manuais e facilitando a reprodução do ambiente.
- **Diretório document root**: `/var/www/html` — pasta padrão onde o Apache busca as páginas a serem servidas.

---

## Observações

- O script limpa o conteúdo atual de `/var/www/html` antes de publicar a nova aplicação.
- Em produção, revise políticas de segurança (firewall, HTTPS, usuários, permissões).
- O alvo do desafio é Ubuntu/Debian; em outras distros (CentOS, Fedora etc.) os comandos de pacote e nomes de serviço podem mudar.

---

## Autor
Renan dos Santos Teixeira
Projeto desenvolvido como solução do desafio de **Linux / IaC** da DIO — provisionamento automatizado de servidor web com Apache.
