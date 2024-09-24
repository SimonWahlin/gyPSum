<#
    TODO:
    * Fix GitVersion config
    * PlatyPS

#>

$BaseParams = @{
    ModuleDescription = 'A great module for lots of things'
    ModuleAuthor      = 'Simon Wåhlin'
    ModuleVersion     = '0.0.1'
    DestinationPath   = '~/ModuleTest'
}

$testcases = @(
    @{
        ModuleType        = 'CustomModule'
        UseGit            = $true
        MainGitBranch     = 'main'
        UseGitVersion     = $true
        UseGitHub         = $false
        # UseAzurePipelines = $false
        UseVSCode         = $true
        LicenseType       = 'MIT'
        SourceDirectory   = 'Source'
        Features          = @()
    },
    @{
        ModuleType        = 'MinimalModule'
    },
    @{
        ModuleType        = 'FullModule'
    },
    @{
        ModuleType        = 'CustomModule'
        UseGit            = $true
        MainGitBranch     = 'mastah' # ONLY REQUIRED WHEN USING GITVERSION
        UseGitVersion     = $true
        UseGitHub         = $true
        # UseAzurePipelines = $false
        UseVSCode         = $true
        LicenseType       = 'MIT'
        SourceDirectory   = 'Source'
        Features          = @('Unittests')
    },
    @{
        ModuleType        = 'CustomModule'
        UseGit            = $true
        MainGitBranch     = 'main'
        UseGitVersion     = $false
        UseGitHub         = $true
        # UseAzurePipelines = $true
        UseVSCode         = $false
        LicenseType       = 'MIT'
        SourceDirectory   = 'Source'
        Features          = @('build')
    },
    @{
        ModuleType        = 'CustomModule'
        UseGit            = $true
        MainGitBranch     = 'main'
        UseGitVersion     = $false
        UseGitHub         = $true
        # UseAzurePipelines = $true
        UseVSCode         = $false
        LicenseType       = 'MIT'
        SourceDirectory   = 'src'
        Features          = @()
    },
    @{
        ModuleType        = 'CustomModule'
        UseGit            = $true
        MainGitBranch     = 'main'
        UseGitVersion     = $false
        UseGitHub         = $true
        # UseAzurePipelines = $true
        UseVSCode         = $false
        LicenseType       = 'MIT'
    }
)

for($i = 0; $i -lt $testcases.Count; $i++) {
    $Name = "MyModule$i"
    Write-Host "Creating module $Name"
    $SplatParams = $testcases[$i]
    New-gyPSumModule -ModuleName $Name @BaseParams @SplatParams
}


