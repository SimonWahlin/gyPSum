<#
    Get-Something.ps1 ends up in source/test/public instead of source/pubic
    Get-Something.ps1 is not used as template
    Lots of empty newlines in manifest file
    Get-Something.test.ps1.template is not templating
    rename parameter usegit to SetGitConfiguration (or something like that)
  
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
        UseAzurePipelines = $false
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
        UseAzurePipelines = $false
        UseVSCode         = $true
        LicenseType       = 'MIT'
        SourceDirectory   = 'Source'
        Features          = @('Unittests') # NO MODULE TESTS, ONLY FOLDERS WITH TESTS
    },
    @{
        ModuleType        = 'CustomModule'
        UseGit            = $true
        MainGitBranch     = 'main'
        UseGitVersion     = $false
        UseGitHub         = $true
        UseAzurePipelines = $true
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
        UseAzurePipelines = $true
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
        UseAzurePipelines = $true
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


