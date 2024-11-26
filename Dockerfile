# Usa uma imagem base Ubuntu 22.04 para maior compatibilidade com pacotes recentes
# --platform=linux/amd64 força o docker a usar a arquitetura x86_64
FROM --platform=linux/amd64 ubuntu:22.04

# Configura o fuso horário para evitar prompts de interação
ENV DEBIAN_FRONTEND=noninteractive

# Define o shell padrão como bash
SHELL ["/bin/bash", "-c"]

# Instale o sudo
RUN apt-get update && apt-get install -y sudo && rm -rf /var/lib/apt/lists/*

# Adicione o usuário 'vscode' ao grupo sudo e configure sem senha
RUN useradd -m vscode && \
    echo "vscode:vscode" | chpasswd && \
    adduser vscode sudo && \
    echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Atualiza os repositórios do apt
RUN echo "Atualizando repositórios do apt" && \
    apt-get update && apt-get clean && rm -rf /var/lib/apt/lists/*

# Instala o OpenJDK 17 para desenvolvimento Java
RUN echo "Instalando OpenJDK 17" && \
    apt-get update && \
    apt-get install -y openjdk-17-jdk && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Instala o curl, necessário para baixar arquivos da internet
RUN echo "Instalando curl" && \
    apt-get update && \
    apt-get install -y curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Instala o iputils-ping para usar o ping no terminal
RUN echo "Instalando o ping" && \
    apt-get update && \
    apt-get install -y iputils-ping

# Instala o Maven, ferramenta de automação de build para projetos Java
RUN echo "Instalando Maven" && \
    apt-get update && \
    apt-get install -y maven && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Instala o git, necessário para controle de versão e baixar dependências de repositórios
RUN echo "Instalando git" && \
    apt-get update && \
    apt-get install -y git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Instala o unzip, necessário para extrair arquivos compactados
RUN echo "Instalando unzip" && \
    apt-get update && \
    apt-get install -y unzip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Instala o ca-certificates para comunicação segura HTTPS
RUN echo "Instalando ca-certificates" && \
    apt-get update && \
    apt-get install -y ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Instala o procps, útil para comandos como `ps` e `top`
RUN echo "Instalando procps" && \
    apt-get update && \
    apt-get install -y procps && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Instala o wget
RUN echo "Instalando wget" && \
    apt-get update && \
    apt-get install -y wget

# Instala o gnupg para usar o gpg
RUN echo "Instalando gpg" && \
    apt-get update && \
    apt-get install -y gnupg

# Instala o nano editor
RUN echo "Instalando nano" && \
    apt-get update && \
    apt-get install -y nano

# Instala AWS CLI
RUN echo "Download AWS CLI" && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# AWS CLI para executar depende de bibliotecas específicas para sistemas x86_64 (64 bits), 
# mas estas bibliotecas podem não estar disponiveis em alguns sistemas ARM (como Raspberry Pi ou Macs com chips Apple Silicon).
RUN echo "Instala libc6" && \
    apt-get update && \
    apt install -y libc6 && \
    apt-get install -y libc6-dev

# Descompacta a pasta AWS CLI
RUN echo "Descompacta AWS CLI" && \
    unzip awscliv2.zip

# Instala AWS CLI
RUN echo "Instala AWS CLI" && \
    ./aws/install

# Dar permissão de execução no AWS CLI
RUN echo "Permissão no AWS CLI" && \
    chmod +x /usr/local/bin/aws

# Baixa o pacote lsb-release
RUN echo "Instala lsb-release" && \
    apt-get update && \
    apt-get install -y lsb-release

# Baixa o terraform e descompacta
RUN echo "Baixa o terraform e descompacta" && \
    curl --insecure -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o terraform.zip && \
    unzip terraform.zip && \
    mv terraform /usr/local/bin/

# Dar permissão de execução no terraform
RUN echo "Permissão no terraform" && \
    chmod +x /usr/local/bin/terraform

# Define a variável de ambiente JAVA_HOME para o Java 17
ENV JAVA_HOME /usr/lib/jvm/java-17-openjdk-amd64
ENV PATH "$JAVA_HOME/bin:$PATH"

# Define a variável de ambiente MAVEN_HOME para o Maven
ENV MAVEN_HOME /usr/share/maven
ENV PATH "$MAVEN_HOME/bin:$PATH"

# Variáveis de ambiente para configuração da AWS CLI
# Exemplo de uso:
# docker run -e AWS_ACCESS_KEY_ID=your-access-key -e AWS_SECRET_ACCESS_KEY=your-secret-key -e AWS_DEFAULT_REGION=us-east-1 my-docker-image

ENV AWS_ACCESS_KEY_ID=""
ENV AWS_SECRET_ACCESS_KEY=""
ENV AWS_DEFAULT_REGION=""

# Copia o script de inicialização para o container
COPY aws-configure.sh /usr/local/bin/aws-configure.sh

# Torna o script executável
RUN chmod +x /usr/local/bin/aws-configure.sh

# Define o comando padrão para inicializar o container
CMD ["java", "-version"]