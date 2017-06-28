function Get-ITGlueUsers {
    [CmdletBinding(DefaultParameterSetName="index")]
    Param (
        [Parameter(ParameterSetName="index")]
            [String]$filter_name = "",
            [String]$filter_email = "",

            [ValidateSet("Administrator", "Manager", "Editor", "Creator", "Lite", "Read-only")]
            [String]$filter_role_name = "",

            [ValidateSet( "name",  "email",  "reputation",  "id", "created_at", "updated-at", `
                        "-name", "-email", "-reputation", "-id","-created_at","-updated-at")]
            [String]$sort = "",

            [Nullable[Int]]$page_number = $null,
            [Nullable[int]]$page_size = $null,

        [Parameter(ParameterSetName="show")]
            [Nullable[Int]]$id = $null
    )

    $resource_uri = "/users/${id}"

    if($PSCmdlet.ParameterSetName -eq "index") {
        $body = @{
                "filter[name]" = $filter_name
                "filter[email]" = $filter_email
                "filter[role_name]" = $filter_role_name
                "sort" = $sort
        }
        if($page_number) {
            $body += @{"page[number]" = $page_number}
        }
        if($page_size) {
            $body += @{"page[size]" = $page_size}
        }
    }


    $ITGlue_Headers.Add("x-api-key", (New-Object System.Management.Automation.PSCredential 'N/A', $ITGlue_API_Key).GetNetworkCredential().Password)
    $rest_output = Invoke-RestMethod -method "GET" -uri ($ITGlue_Base_URI + $resource_uri) -headers $ITGlue_Headers `
                                     -body $body -ErrorAction Stop -ErrorVariable $web_error
    $ITGlue_Headers.Remove('x-api-key') >$null # Quietly clean up scope so the API key doesn't persist

    $data = @{}
    $data = $rest_output 
    return $data
}