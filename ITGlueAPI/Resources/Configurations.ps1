function Get-ITGlueConfigurations {


    [CmdletBinding(DefaultParameterSetName=”index”)]
    Param (

        [Parameter()]
            [Nullable[Int]]$id,

        [Parameter(ParameterSetName="index")]
            [String]$filter_name = "",

            [Nullable[Int]]$filter_organization_id = $null,
            [Nullable[Int]]$filter_configuration_type_id = $null,
            [Nullable[Int]]$filter_configuration_status_id = $null,
            [String]$filter_serial_number = "",

            [String]$sort = "",

            [Nullable[Int]]$page_number = $null,
            [Nullable[int]]$page_size = $null,
            [String]$include = "",

        [Parameter(ParameterSetName="show")]
            [Nullable[Int]]$organization_id = $null
    )

    $resource_uri = "/configurations/${id}"

    if($PSCmdlet.ParameterSetName -eq "index") {
        $body = @{
                "filter[name]" = $filter_name
                "filter[serial-number]" = $filter_serial_number
                "sort" = $sort
        }
        if($filter_organization_id) {$body += @{"filter[organization-id]" = $filter_organization_id}}
        if($filter_configuration_type_id) {$body += @{"filter[configuration-type-id]" = $filter_configuration_type_id}}
        if($filter_configuration_status_id) {$body += @{"filter[configuration-status-id]" = $filter_configuration_status_id}}
        if($page_number) {$body += @{"page[number]" = $page_number}}
        if($page_size) {$body += @{"page[size]" = $page_size}}
    }
    else {
        #Parameter set "Show" is selected; switch to nested relationships route
        $resource_uri = "/organizations/${organization_id}/relationships/configurations/${id}"
    }


    $ITGlue_Headers.Add("x-api-key", (New-Object System.Management.Automation.PSCredential 'N/A', $ITGlue_API_Key).GetNetworkCredential().Password)
    $rest_output = Invoke-RestMethod -method "GET" -uri ($ITGlue_Base_URI + $resource_uri) -headers $ITGlue_Headers -body $body
    $ITGlue_Headers.Remove('x-api-key') >$null # Quietly clean up scope so the API key doesn't persist


    $data = $rest_output.data   
    return $data
}