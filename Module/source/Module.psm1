$ModulePath = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$PrivatePath = '{0}\private\*.ps1' -f $ModulePath
$PublicPath = '{0}\public\*.ps1'-f $ModulePath
$Scripts = Get-ChildItem -Path $PrivatePath, $PublicPath | Select-Object -ExpandProperty FullName

foreach($Script in $Scripts) {
        . $Script
}

$PublicScriptBlock = [ScriptBlock]::Create((Get-ChildItem -Path $PublicPath | Get-Content | Out-String))
$PublicFunctions = $PublicScriptBlock.Ast.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst]},$false).Name
$PublicAlias = $PublicScriptBlock.Ast.FindAll({ $args[0] -is [System.Management.Automation.Language.ParamBlockAst] },$true).Where{$_.TypeName.FullName -eq 'alias'}.PositionalArguments.Value

$ExportParam = @{}
if($PublicFunctions) {
        $ExportParam.Add('Function',$PublicFunctions)
}
if($PublicAlias) {
        $ExportParam.Add('Alias',$PublicAlias)
}
if($ExportParam.Keys.Count -gt 0) {
        Export-ModuleMember @ExportParam
}
