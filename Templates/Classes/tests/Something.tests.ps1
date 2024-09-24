$ProjectPath = "$PSScriptRoot\..\.." | Convert-Path
$ProjectName = (Get-ChildItem $ProjectPath\*\*.psd1 | Where-Object {
        ($_.Directory.Name -match 'Source|src' -or $_.Directory.Name -eq $_.BaseName) -and
        $(try { Test-ModuleManifest $_.FullName -ErrorAction Stop }catch{$false}) }
    ).BaseName
Write-Host "ProjectPath: $ProjectPath ProjectName: $ProjectName"
Import-Module $ProjectName

InModuleScope $ProjectName {
    Describe Something {
        Context 'Type creation' {
            It 'Has created a type named Something' {
                'Something' -as [Type] | Should -BeOfType [Type]
            }
        }

        Context 'Constructors' {
            It 'Has a default constructor' {
                $instance = [Something]::new()
                $instance | Should -Not -BeNullOrEmpty
                $instance.GetType().Name | Should -Be 'Something'
            }
        }

        Context 'Methods' {
            BeforeEach {
                $instance = [Something]::new()
            }

            It 'Overrides the ToString method' {
                # Typo "class" is inherited from definition. Preserved here as validation is demonstrative.
                $instance.ToString() | Should -Be 'This class is Something'
            }
        }

        Context 'Properties' {
            BeforeEach {
                $instance = [Something]::new()
            }

            It 'Has a Name property' {
                $instance.Name | Should -Be 'Something'
            }
        }
    }
}
