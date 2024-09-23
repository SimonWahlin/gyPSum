$BaseParams = @{
    ModuleDescription = 'A great module for lots of things'
    ModuleAuthor      = 'Simon Wåhlin'
    ModuleVersion     = '0.0.1'
}

$testcases = @(
    @{
        ModuleType        = 'CustomModule'
        UseGit            = $true
        MainGitBranch     = 'main'
        UseGitVersion     = $true
        # UseGitHub         = $false
        # UseAzurePipelines = $false
        # GitHubOwner       = ''
        UseVSCode         = $true
        LicenseType       = 'MIT'
        # SourceDirectory   = 'Source'
        # Features          = @()
        DestinationPath   = "~/"
    },
    @{
        ModuleType        = 'MinimalModule'
        DestinationPath   = "~/"
    },
    @{
        ModuleType        = 'FullModule'
        DestinationPath   = "~/"
    },
    @{
        ModuleType        = 'CustomModule'
        UseGit            = $true
        MainGitBranch     = 'mastah'
        UseGitVersion     = $true
        UseGitHub         = $true
        UseAzurePipelines = $false
        UseVSCode         = $true
        LicenseType       = 'MIT'
        SourceDirectory   = 'Source'
        Features          = @('Unittests')
        DestinationPath   = "~/"
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
        DestinationPath   = "~/"
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
        SourceDirectory   = 'MySourceCode'
        Features          = @()
        DestinationPath   = "~/"
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
        SourceDirectory   = 'MySourceCode'
        DestinationPath   = "~/"
    }
)

for($i = 0; $i -lt $testcases.Count; $i++) {
    $Name = "MyModule$i"
    $SplatParams = $testcases[$i]
    New-gyPSumModule -ModuleName $Name @BaseParams @SplatParams
}


