#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["TestCore1/TestCore1.csproj", "TestCore1/"]
RUN dotnet restore "TestCore1/TestCore1.csproj"
COPY . .
WORKDIR "/src/TestCore1"
RUN dotnet build "TestCore1.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "TestCore1.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TestCore1.dll"]