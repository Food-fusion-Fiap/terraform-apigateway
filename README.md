# terraform-apigateway

Este repositório contém as configurações do Terraform para criar um API Gateway e integrá-lo com outras funcionalidades.

## Funcionalidades

O API Gateway criado neste projeto é integrado com duas funcionalidades principais:

1. **food-fusion-auth**: Esta é uma função Lambda responsável por criar o token de autenticação (JWT).
2. **food-fusion-authorizer**: Esta é uma função Lambda que valida o token de autenticação em todas as requisições que chegam.

Após a validação do token JWT, o API Gateway encaminha as requisições autorizadas para o Amazon EKS.

## Configuração Local

Antes de aplicar as configurações do Terraform, siga as etapas abaixo para configurar o ambiente local:

1. Certifique-se de que as Lambdas `food-fusion-auth` e `food-fusion-authorizer` estão devidamente configuradas e implantadas em sua conta da AWS.
2. Defina as variáveis de ambiente necessárias para configurar a integração com as Lambdas e o Amazon EKS.

## Execução Local

Após configurar o ambiente local e definir as variáveis de ambiente necessárias, você pode aplicar as configurações do Terraform para criar o API Gateway e configurar as integrações:

```bash
terraform init
terraform apply
```

Após a aplicação bem-sucedida, seu API Gateway estará pronto para receber e encaminhar requisições autorizadas para o Amazon EKS. Certifique-se de que todas as integrações estejam funcionando corretamente antes de colocar o ambiente em produção.