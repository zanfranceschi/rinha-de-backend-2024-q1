# Assumindo que o diretório do gatling esteja no mesmo nível que este script
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Set the GATLING_HOME environment variable
$Env:GATLING_HOME = Join-Path $ScriptDir "gatling"

$GatlingBinDir = Join-Path $Env:GATLING_HOME "bin"
$Workspace = $ScriptDir

& "$GatlingBinDir\gatling.bat" -rm local -s RinhaBackendDebitosCreditosSimulation `
    -rd "Rinha de Backend - 2024/Q1: Crébito" `
    -rf "$Workspace\results" `
    -sf "$Workspace\simulations"
