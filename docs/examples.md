```powershell
@ModuleParams = @{

}

New-gyPSumModule @ModuleParams
```

New-gyPSumModule -ModuleType FullModule -TemplatePath 'C:\Users\simon\github\gyPSum\Templates\Module' -ModuleAuthor 'Simon Wåhlin' -ModuleName 'MyNewModule' -ModuleDescription 'A great module for lots of things' -CustomRepo '' -ModuleVersion '0.0.1' -UseGit $true -MainGitBranch 'main' -UseGitVersion $true -UseGitHub $false -UseAzurePipelines $false -GitHubOwner '' -UseVSCode $true -LicenseType 'MIT' -SourceDirectory 'Source' -Features @('Enum','Classes','git','Unittests','build') -DestinationPath "~/"