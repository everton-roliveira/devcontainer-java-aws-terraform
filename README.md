# Ubuntu 22.04 com Java 17

Este projeto fornece uma **imagem Docker** baseada no **Ubuntu 22.04**, configurada com várias ferramentas essenciais para desenvolvimento em **Java**, automação de builds, e outras utilidades comuns no desenvolvimento de software.

## Funcionalidades da Imagem

A imagem Docker inclui as seguintes ferramentas e pacotes:

- **Ubuntu 22.04**: Sistema operacional base.
- **Java 17 (OpenJDK)**: Para desenvolvimento de aplicações Java.
- **Maven**: Ferramenta de automação de builds para projetos Java.
- **Git**: Controle de versão e integração com repositórios de código.
- **Curl**: Utilitário para transferir dados com URLs (necessário para baixar dependências).
- **Unzip**: Ferramenta para descompactar arquivos.
- **ca-certificates**: Certificados de segurança para comunicação HTTPS.
- **Procps**: Utilitário para visualizar processos e informações do sistema.
- **Wget**: Utilitário de download de arquivos da web.
- **GPG**: Ferramenta para uso de criptografia e autenticação.
- **Nano**: Editor de texto leve.
- **AWS CLI**: Interface de linha de comando para interagir com os serviços da AWS.
- **Terraform**: Ferramenta de automação para infraestrutura como código.

## Como Usar

### 1. **Via DevContainer**

Você pode usar essa imagem em um **DevContainer** no Visual Studio Code para configurar e iniciar seu ambiente de desenvolvimento de forma rápida.

#### Passos para configurar:

##### 1.1 **Configurar Variáveis de Ambiente para AWS CLI** (opcional)

Antes de iniciar o DevContainer, configure as variáveis de ambiente para a AWS CLI. No arquivo .env-example, altere os valores das variaveis pelas credenciais e região corretos, e depois renomeie para `.env` apenas.

```bash
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
AWS_DEFAULT_REGION=us-east-1
```

### 1.2 **Iniciar o DevContainer**

- **Opção 1**: No canto inferior esquerdo do VS Code, clique no ícone do `Dev Container` e selecione **Rebuild Container**.
- **Opção 2**: Pressione `F1` no VS Code, digite o comando `> devcontainers: Rebuild Container` e pressione Enter.

Ao seguir qualquer uma das opções acima, o container será iniciado com a imagem configurada.

> **Importante**: Certifique-se de que a pasta do projeto esteja visível no Explorer do VS Code, pois o DevContainer só funcionará se encontrar o diretório e o arquivo correto **.devcontainer/devcontainer.json**.

> **Nota**: Na primeira execução, o processo pode demorar até que todas as dependências sejam baixadas e a imagem seja construída.

## 2. **Via terminal**

### 2.1 **Construindo a Imagem Docker**

Você pode construir a imagem Docker com o seguinte comando:

```bash
docker build -t my-docker-image .
```

### 2.2 **Executando o Container**

Após construir a imagem, você pode rodar o container usando o comando abaixo. Lembre-se de substituir `<VALUE>` pelos valores corretos para as variáveis de ambiente da AWS:

```bash
docker run -e AWS_ACCESS_KEY_ID=<VALUE> -e AWS_SECRET_ACCESS_KEY=<VALUE> -e AWS_DEFAULT_REGION=<VALUE> my-docker-image
```

Se você não quiser usar a AWS CLI ou preferir configurar mais tarde, pode remover as variáveis de ambiente -e, e configurar a AWS CLI dentro do container, executando os comandos de configuração normalmente:

```bash
docker run my-docker-image
```
Dentro do container, basta executar os comandos da AWS CLI como de costume.

## 3. **Personalização e Dependências**

A imagem Docker fornecida é configurada para atender a vários cenários comuns de desenvolvimento Java e automação. No entanto, ela pode ser personalizada e estendida conforme as necessidades do seu projeto.

### 3.1 **Customizando a Imagem**

Você pode personalizar a imagem Docker para adicionar ou remover pacotes conforme necessário. A seguir estão algumas direções para personalização:

- **Adicionar pacotes adicionais**: Para adicionar pacotes, edite o arquivo `Dockerfile` e use o comando `apt-get install` para instalar qualquer pacote necessário. Exemplo para instalar o Node.js:
  
    ```dockerfile
    RUN apt-get update && apt-get install -y nodejs
    ```

    - Instalar outras versões de Java: Caso precise de uma versão diferente do Java (por exemplo, Java 11), substitua a linha no Dockerfile que instala o OpenJDK 17:
        ```bash
        RUN apt-get update && apt-get install -y openjdk-11-jdk
        ```

    - Alterar variáveis de ambiente: As variáveis de ambiente, como o `JAVA_HOME` e o `MAVEN_HOME`, são definidas automaticamente no Dockerfile, mas podem ser ajustadas conforme necessário para outros projetos ou versões de ferramentas.

    - Configuração personalizada da **AWS CLI**: O script `aws-configure.sh` pode ser alterado para personalizar a configuração da AWS CLI com diferentes parâmetros ou processos de inicialização. Se precisar de outra configuração ou adicionar mais parâmetros, edite o script conforme necessário.

### 3.2 Dependências da Imagem
Além das ferramentas já incluídas na imagem, algumas dependências podem ser necessárias dependendo do seu projeto:

    - **AWS CLI**: A imagem já inclui a AWS CLI, mas se você precisar de uma versão específica ou do AWS CLI v1, pode ser necessário modificar o Dockerfile para buscar essa versão.

    - **Terraform**: A imagem inclui o `Terraform v1.9.8`. Caso precise de outra versão, edite a linha de instalação do Terraform no Dockerfile para apontar para o URL da versão desejada.

    - **Java**: A imagem é configurada com o OpenJDK 17, mas outras versões podem ser facilmente instaladas e configuradas. Consulte as seções acima para customizações.

    - **Maven**: A imagem já inclui o Maven, mas versões alternativas ou plugins adicionais podem ser instalados, conforme necessário para seu fluxo de trabalho.

### 3.3 Atualizando Dependências
Caso você precise atualizar alguma dependência ou ferramenta dentro da imagem, edite o `Dockerfile` conforme necessário e reconstua a imagem. Exemplo de como atualizar o `Maven`:

```bash
RUN apt-get update && apt-get install --only-upgrade maven
```

Após editar o `Dockerfile, basta executar o comando de rebuild da imagem:
```bash
docker build -t my-docker-image .
```