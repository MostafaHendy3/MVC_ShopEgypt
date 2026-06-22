FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

COPY ["ShopEgypt/ShopEgypt.csproj", "ShopEgypt/"]
COPY ["ShopEgypt.Application/ShopEgypt.Application.csproj", "ShopEgypt.Application/"]
COPY ["ShopEgypt.Domain/ShopEgypt.Domain.csproj", "ShopEgypt.Domain/"]
COPY ["ShopEgypt.Infrastructure/ShopEgypt.Infrastructure.csproj", "ShopEgypt.Infrastructure/"]

RUN dotnet restore "ShopEgypt/ShopEgypt.csproj"

COPY . .

WORKDIR "/src/ShopEgypt"
RUN dotnet publish -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app

COPY --from=build /app/publish .

ENV ASPNETCORE_ENVIRONMENT=Production
ENV ASPNETCORE_URLS=http://+:80

EXPOSE 80

ENTRYPOINT ["dotnet", "ShopEgypt.dll"]