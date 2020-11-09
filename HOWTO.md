# Nibo DevOps Challenge - How-To

# Getting Started

## Links

- [Fork do Projeto](https://github.com/fcp20/DevOpsChallenge)
- [Azure DevOps](https://dev.azure.com/fcp20-DevOpsChallenge/)
- [Docker Hub Image](https://hub.docker.com/repository/docker/fcp20/nibo-devops-challenge)

## Ambientes

| Ambiente | Status                                         |
| -------- | -----------------------------------------------|
| Produção | [Open in Browse](http://13.92.122.217/status)  |
| QA       | [Open in Browse](http://13.92.122.217/status)  |

# Estruturas

## Projeto

Fonte: [Project Structure](https://docs.microsoft.com/en-us/dotnet/core/porting/project-structure)

```sh
.
├── azure-pipelines.yml
├── Dockerfile
├── HOWTO.md
├── k8s
│   └── mywebapp.yaml
├── MyWebApp.sln
├── README.md
├── src
│   └── MyWebApp
│       ├── appsettings.Development.json
│       ├── appsettings.json
│       ├── Controllers
│       │   └── WeatherForecastController.cs
│       ├── MyWebApp.csproj
│       ├── Program.cs
│       ├── Startup.cs
│       └── WeatherForecast.cs
└── tests
    ├── Tests.MSTest
    │   ├── ByAlphabeticalOrder.cs
    │   └── Tests.MSTest.csproj
    ├── Tests.NUnit
    │   ├── ByOrder.cs
    │   └── Tests.NUnit.csproj
    └── Tests.XUnit
        ├── Attributes
        │   └── TestPriorityAttribute.cs
        ├── ByAlphabeticalOrder.cs
        ├── ByDisplayName.cs
        ├── ByPriorityOrder.cs
        ├── Orderers
        │   ├── AlphabeticalOrderer.cs
        │   ├── DisplayNameOrderer.cs
        │   └── PriorityOrderer.cs
        └── Tests.XUnit.csproj
```

- Corrigidos os testes de acordo com cada framework utilizado e sua regra de ordem de execução
- Alterada estrutura do projeto para atender à orientação da Microsoft
- Adicionada estrutura do kubernetes para deployment da aplicação contendo: `deployment` e `service`.
- Criado Dockerfile para publicação da aplicação em Docker, tendo como docker registry hub.docker.com e deploy em cluster de kubernetes

## Infraestrutura (Kubernetes)

```sh
.
├── k8s
│   └── namespaces.yaml
├── README.md
└── terraform
    ├── creds
    │   ├── nibo_rsa
    │   └── nibo_rsa.pub
    ├── main.tf
    ├── terraform.tfstate
    ├── terraform.tfstate.backup
    └── variables.tf
```

- Criado cluster de kubernetes por meio de terraform.
- O cluster consiste basicamente em dois namespaces, sendo um para cada aplicação, seguindo a ideia que cada serviço em seu namespace terá um LoadBalancer (IP Público) definido, conforme `Kind` em [mywebapp.yaml](k8s/mywebapp.yaml).
- A chave ssh (se necessária) foi enviada separadamente, bem como o `kubeconfig` para gerenciamento do `AKS` via `kubectl`.

## Azure

Resource Group: `rg-nibo`

Kubernetes service: `aks-nibo`

Log Analytics workspace: `log-nibo`
- Criado caso haja necessidade de interagir com os logs apresentados pelo `appi-nibo` e/ou criação de métricas sob o k8s cluster, utlizando o `Monitor | Containers` da Azure.

Application Insights: `appi-nibo`
- Recurso utilizado para monitoramento do cluster e as aplicações existentes
- Criado healthcheck para ambiente de `production` e `staging`, considerando os deployments de cada ambiente conforme [Link](https://portal.azure.com/#@fcp20outlook.onmicrosoft.com/resource/subscriptions/8564a48b-4c5b-4aa7-88f3-321bd2963daf/resourcegroups/rg-nibo/providers/microsoft.insights/components/appi-nibo/availability).

## Azure DevOps

- Foram criadas 2 Pipelines e 1 Release para solução do problema.
  - `github-nibo-devops-challenge`: Pipeline vinculada ao repositório do `GitHub`, com trigger automático para branch `master` e `staging`.
    - `Release`: Reponsável por realizar o deploy da aplicação de acordo com sua branch de origem (master,staging) para seu ambiente de destino (production,staging).
    - Para que tenha-se a atualização do ambiente de staging (QA) faz-se necessário o merge das alterações desejadas (Pull Request) com a branch `staging`.
  - `nibo-devops-challenge`: repositório no `Azure Repos` criado à partir do repositório do `GitHub` para apresentação de como seria o fluxo de aprovação de Pull Request (branch policies) e automação do CI/CD.
    - Caso o repositório fosse este - não o GitHub - seria possível a realização do deployment a partir de um pull-request.
