param(
    $ModulePath = "$PSScriptRoot\..\..\Source\"
)
# Remove trailing slash or backslash
$ModulePath = $ModulePath -replace '[\\/]*$'
$ModuleName = (Get-Item "$ModulePath\..").Name
$ModuleManifestName = '<%=$PLASTER_PARAM_ModuleName%>.psd1'
$ModuleManifestPath = Join-Path -Path $ModulePath -ChildPath $ModuleManifestName

Describe 'Core Module Tests' -Tags 'CoreModule', 'Unit' {

    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath
        $? | Should Be $true
    }

    It 'Loads from module path without errors' {
        {Import-Module "$ModulePath\$ModuleName.psd1" -ErrorAction Stop} | Should -Not -Throw
    }

    AfterAll {
        Get-Module -Name $ModuleName | Remove-Module -Force
    }

}