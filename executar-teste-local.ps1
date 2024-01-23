# Esse script é da edição anterior da Rinha.
# Por favor, se você souber como deixar esse script similar ao da
# versão bash e se seu coração mandar, faça um pull request, tá?

# Assumindo que o diretório do gatling esteja no mesmo nível que este script
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Set the GATLING_HOME environment variable
$Env:GATLING_HOME = Join-Path $ScriptDir "gatling"

$GatlingBinDir = Join-Path $Env:GATLING_HOME "bin"
$Workspace = $ScriptDir

& "$GatlingBinDir\gatling.bat" -rm local -s RinhaBackendCrebitosSimulation `
    -rd "Rinha de Backend - 2024/Q1: Crébito" `
    -rf "$Workspace\results" `
    -sf "$Workspace\simulations"
