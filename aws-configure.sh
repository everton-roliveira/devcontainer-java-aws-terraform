#!/bin/bash

echo "Verificando configurações da AWS no ambiente..."

# Verifica se as variáveis de ambiente estão definidas
if [[ -n "$AWS_ACCESS_KEY_ID" && -n "$AWS_SECRET_ACCESS_KEY" && -n "$AWS_DEFAULT_REGION" ]]; then
  echo "Variáveis de ambiente encontradas. Configurando AWS CLI automaticamente..."

  # Define o perfil (padrão: default)
  PROFILE=${AWS_PROFILE:-default}

  # Cria os diretórios e arquivos necessários
  mkdir -p ~/.aws

  # Cria o arquivo de credenciais
  cat > ~/.aws/credentials <<- EOM
[$PROFILE]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
EOM

  # Ajusta as permissões do arquivo de credenciais
  chmod 600 ~/.aws/credentials

  # Cria o arquivo de configuração
  cat > ~/.aws/config <<- EOM
[$PROFILE]
region = $AWS_DEFAULT_REGION
output = json
EOM

  echo "AWS CLI configurado com sucesso para o perfil [$PROFILE]."
else
  echo "Erro: As seguintes variáveis de ambiente não estão definidas:"
  [[ -z "$AWS_ACCESS_KEY_ID" ]] && echo " - AWS_ACCESS_KEY_ID"
  [[ -z "$AWS_SECRET_ACCESS_KEY" ]] && echo " - AWS_SECRET_ACCESS_KEY"
  [[ -z "$AWS_DEFAULT_REGION" ]] && echo " - AWS_DEFAULT_REGION"
  echo "Configuração automática não realizada. Configure manualmente com o comando 'aws configure'."
  exit 1
fi

# Verifica se o AWS CLI está instalado
if ! command -v aws &> /dev/null; then
  echo "Erro: AWS CLI não encontrado. Instale-o antes de continuar."
  exit 1
fi

# Rodar o comando padrão do container (se necessário)
exec "$@"
