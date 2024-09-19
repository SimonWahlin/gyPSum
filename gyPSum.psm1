function New-gyPSumModule {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$DestinationPath = $null,

        [Parameter()]
        [string]$TemplatePath = $null
    )
    # Dynamic param logic proudly stolen from Invoke-Plaster
    # Process the template's Plaster manifest file to convert parameters defined there into dynamic parameters.
    dynamicparam {
        $ResolvedTemplatePath = (Join-Path $MyInvocation.MyCommand.Module.ModuleBase "Templates/Module")
        if($null -ne $TemplatePath) {
            $ResolvedTemplatePath = $TemplatePath
        }

        $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
    
        $manifest = $null
        $templateAbsolutePath = $null
    
        # Nothing to do until the ResolvedTemplatePath parameter has been provided.
        if ($null -eq $ResolvedTemplatePath) {
            return
        }
    
        try {
            # Let's convert non-terminating errors in this function to terminating so we
            # catch and format the error message as a warning.
            $ErrorActionPreference = 'Stop'
    
            # The constrained runspace is not available in the dynamicparam block.  Shouldn't be needed
            # since we are only evaluating the parameters in the manifest - no need for EvaluateConditionAttribute as we
            # are not building up multiple parametersets.  And no need for EvaluateAttributeValue since we are only
            # grabbing the parameter's value which is static.
            $templateAbsolutePath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ResolvedTemplatePath)
            if (!(Test-Path -LiteralPath $templateAbsolutePath -PathType Container)) {
                throw ($templateAbsolutePath)
            }
            
            $manifest = Test-PlasterManifest -Path "$templateAbsolutePath/plasterManifest.xml" -ErrorAction Stop 3>$null
    
            # The user-defined parameters in the Plaster manifest are converted to dynamic parameters
            # which allows the user to provide the parameters via the command line.
            # This enables non-interactive use cases.
            foreach ($node in $manifest.plasterManifest.parameters.ChildNodes) {
                if ($node -isnot [System.Xml.XmlElement]) {
                    continue
                }
    
                $name = $node.name
                $type = $node.type
                $prompt = if ($node.prompt) { $node.prompt } else { $name }
    
                if (!$name -or !$type) { continue }
    
                # Configure ParameterAttribute and add to attr collection
                $attributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
                $paramAttribute = New-Object System.Management.Automation.ParameterAttribute
                $paramAttribute.HelpMessage = $prompt
                $attributeCollection.Add($paramAttribute)
    
                switch -regex ($type) {
                    'text|user-fullname|user-email' {
                        $param = New-Object System.Management.Automation.RuntimeDefinedParameter `
                            -ArgumentList ($name, [string], $attributeCollection)
                        break
                    }
    
                    'choice|multichoice' {
                        $choiceNodes = $node.ChildNodes
                        $setValues = New-Object string[] $choiceNodes.Count
                        $i = 0
    
                        foreach ($choiceNode in $choiceNodes) {
                            $setValues[$i++] = $choiceNode.value
                        }
    
                        $validateSetAttr = New-Object System.Management.Automation.ValidateSetAttribute $setValues
                        $attributeCollection.Add($validateSetAttr)
                        $type = if ($type -eq 'multichoice') { [string[]] } else { [string] }
                        $param = New-Object System.Management.Automation.RuntimeDefinedParameter `
                            -ArgumentList ($name, $type, $attributeCollection)
                        break
                    }
    
                    default { throw ($type, $name) }
                }
    
                $paramDictionary.Add($name, $param)
            }
        }
        catch {
            Write-Warning ($_)
        }
    
        $paramDictionary
    }
    process {
        $PlasterParam = @{}
        foreach($key in $PSBoundParameters.Keys) {
            if($key -eq 'TemplatePath') {continue}
            if($key -eq 'DestinationPath' -and $null -eq $PSBoundParameters[$key]) {continue}
            $PlasterParam[$key] = $PSBoundParameters[$key]
        }
        Invoke-Plaster -TemplatePath $ResolvedTemplatePath @PlasterParam
    }
}

Export-ModuleMember -Function 'New-gyPSumModule'