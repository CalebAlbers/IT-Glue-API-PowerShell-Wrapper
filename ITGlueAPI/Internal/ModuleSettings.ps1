function Export-ITGlueModuleSettings {

$secureString = $ITGlue_API_KEY | ConvertFrom-SecureString 

@"
@{
    ITGlue_Base_URI = '$ITGlue_Base_URI'
    ITGlue_API_Key = '$secureString'
}
"@ | Out-File -FilePath './Settings/config.psd1'


}



function Import-ITGlueModuleSettings {

    # PLEASE ADD ERROR CHECKING

    if(test-path './Settings/config.psd1') {
        $tmp_config = Import-LocalizedData -BaseDirectory "./Settings" -FileName "config.psd1"

        # Send to function to strip potentially superflous slash (/)
        Add-ITGlueBaseURI $tmp_config.ITGlue_Base_URI
        Set-Variable -Name "ITGlue_API_Key"  -Value $tmp_config.ITGlue_API_Key `
                    -Option ReadOnly -Scope global -Force

        # Clean things up
        Remove-Variable "tmp_config"

        Write-Host "Module configuration loaded successfully!" -ForegroundColor Green
    }
    else {
        Write-Host "No configuration file was found." -ForegroundColor Red
        Write-Host "Please run Add-ITGlueBaseURI and Add-ITGlueAPIKey to get started."
    }
}