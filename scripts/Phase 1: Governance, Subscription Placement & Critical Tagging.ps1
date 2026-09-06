<#
.SYNOPSIS
    Project 4 - Phase 1: Governance, Subscription Placement & Critical Tagging
    Target Subscription: sub-ent-platform-prod (SUB_ID)
#>

# 1. Scope & Governance Variables
$SubscriptionId   = "SUB_ID"
$SubscriptionName = "sub-ent-platform-prod"
$TargetMG         = "mg-prod"
$Location         = "eastus"

$RGHub            = "rg-prd-hub-network-001"
$RGApp            = "rg-prd-app-privatelink-001"

# Enterprise Critical Tags Schema
$Tags = @{
    Environment   = "Production"
    Project       = "Project-4-ZeroTrust-LZ"
    Owner         = "Cloud-SecOps-Team"
    CostCenter    = "CC-INFRA-702"
    SecurityLevel = "High-Restricted"
}

# 2. Authentication & Subscription Context
Write-Host "Setting context to $SubscriptionName ($SubscriptionId)..." -ForegroundColor Cyan
Connect-AzAccount -ErrorAction SilentlyContinue
Set-AzContext -SubscriptionId $SubscriptionId

# 3. Governance: Move Subscription under mg-prod Management Group
Write-Host "Associating Subscription $SubscriptionId with Management Group $TargetMG..." -ForegroundColor Cyan
New-AzManagementGroupSubscription -GroupName $TargetMG -SubscriptionId $SubscriptionId -ErrorAction SilentlyContinue

# 4. Pre-Register Core Resource Provider
Write-Host "Registering Microsoft.Network Resource Provider..." -ForegroundColor Cyan
Register-AzResourceProvider -ProviderNamespace "Microsoft.Network" | Out-Null

# 5. Provision Resource Groups with Enterprise Tags
Write-Host "Creating Resource Group: $RGHub with tags..." -ForegroundColor Cyan
New-AzResourceGroup -Name $RGHub -Location $Location -Tag $Tags -Force

Write-Host "Creating Resource Group: $RGApp with tags..." -ForegroundColor Cyan
New-AzResourceGroup -Name $RGApp -Location $Location -Tag $Tags -Force

# 6. Output Verification
Write-Host "`n========================================================" -ForegroundColor Green
Write-Host " Phase 1 Deployment Completed Successfully!" -ForegroundColor Green
Write-Host " Management Group : $TargetMG" -ForegroundColor Green
Write-Host " Resource Groups  : $RGHub, $RGApp" -ForegroundColor Green
Write-Host " Applied Tags     : Environment, Project, Owner, CostCenter, SecurityLevel" -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Green
