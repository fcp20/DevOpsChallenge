FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build

WORKDIR /app

COPY . ./

RUN dotnet restore && \
      dotnet publish src/MyWebApp/MyWebApp.csproj --no-restore -c Release -o out

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1

ENV ASPNETCORE_URLS http://+:8081

WORKDIR /app

COPY --from=build /app/out .

ENTRYPOINT ["dotnet", "MyWebApp.dll"]
