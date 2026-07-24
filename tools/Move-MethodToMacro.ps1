<#
.SYNOPSIS
    Reverse of Move-MacroToMethod.ps1: moves the code that currently lives directly
    in a method (after its macro call) back into the ABAP macro (DEFINE ...
    END-OF-DEFINITION), including the method's ENDMETHOD. statement. The method is
    left with just the macro call afterwards.

.DESCRIPTION
    Expects the classic abapGit file pair:
        <class>.clas.abap           (implementation, contains "METHOD x. <macro-call>. ... ENDMETHOD.")
        <class>.clas.macros.abap    (contains "DEFINE <macro>. END-OF-DEFINITION." with an empty body)

    For each "Method=Macro" mapping:
      1. The method's body is located: everything after the macro call up to and
         including the method's own "ENDMETHOD." line.
      2. That whole block (code + ENDMETHOD.) is cut out of the .clas.abap file, so
         the method only contains "METHOD x." followed by the macro call.
      3. The cut-out block is inserted into the macro's body in .clas.macros.abap
         (between DEFINE and END-OF-DEFINITION), so the macro now ends with
         ENDMETHOD. again, exactly like before the code was moved out of it.

    The script is idempotent: if the macro already has a non-empty body, or the
    method has no ENDMETHOD. to pull in (i.e. it already just calls the macro), the
    respective mapping is skipped with a warning.

.PARAMETER ClassAbapPath
    Path to the "<class>.clas.abap" file. The associated macro file is derived
    automatically by replacing ".clas.abap" with ".clas.macros.abap" (standard
    abapGit naming scheme). Alternatively pass -MacrosAbapPath explicitly.

.PARAMETER MacrosAbapPath
    Optional explicit path to the macro file, in case the naming scheme doesn't apply.

.PARAMETER Mapping
    One or more mappings in the format "MethodName=MacroName".

.PARAMETER WhatIf
    Only shows what would be done (extraction/removal positions), without writing
    any files.

.EXAMPLE
    .\tools\Move-MethodToMacro.ps1 `
        -ClassAbapPath "src/#cadaxo#cl_sqlc_cockpit_parse.clas.abap" `
        -Mapping "execute_select_via_subpool=create_dynamic_select_subpool", `
                 "execute_select_via_subpool_v_2=create_dynamic_select_subpool2", `
                 "execute_select_v_1=m_execute_select", `
                 "execute_select_v_2=m_execute_select_v_2"

.EXAMPLE
    # Preview only, no changes written to disk
    .\tools\Move-MethodToMacro.ps1 -ClassAbapPath "src/#cadaxo#cl_sqlc_cockpit_parse.clas.abap" `
        -Mapping "execute_select_v_1=m_execute_select" -WhatIf
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true)]
    [string]$ClassAbapPath,

    [Parameter()]
    [string]$MacrosAbapPath,

    [Parameter(Mandatory = $true)]
    [string[]]$Mapping
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $ClassAbapPath)) {
    throw "ClassAbapPath not found: $ClassAbapPath"
}

if (-not $MacrosAbapPath) {
    if ($ClassAbapPath -notlike "*.clas.abap") {
        throw "Cannot derive MacrosAbapPath automatically (ClassAbapPath does not end in '.clas.abap'). Please pass -MacrosAbapPath explicitly."
    }
    $MacrosAbapPath = $ClassAbapPath -replace '\.clas\.abap$', '.clas.macros.abap'
}

if (-not (Test-Path $MacrosAbapPath)) {
    throw "MacrosAbapPath not found: $MacrosAbapPath"
}

# Parse "Method=Macro" mapping strings
$pairs = foreach ($m in $Mapping) {
    if ($m -notmatch '^\s*(?<method>[^=]+?)\s*=\s*(?<macro>.+?)\s*$') {
        throw "Invalid mapping (expected 'Method=Macro'): '$m'"
    }
    [PSCustomObject]@{
        Method = $Matches['method']
        Macro  = $Matches['macro']
    }
}

$encoding = New-Object System.Text.UTF8Encoding($false)

$macroLines = [System.Collections.Generic.List[string]]::new(
    [System.IO.File]::ReadAllLines($MacrosAbapPath)
)
$clasLines = [System.Collections.Generic.List[string]]::new(
    [System.IO.File]::ReadAllLines($ClassAbapPath)
)

function Find-LineIndex {
    param([System.Collections.Generic.List[string]]$Lines, [string]$Text, [int]$From = 0)
    for ($i = $From; $i -lt $Lines.Count; $i++) {
        if ($Lines[$i].Trim() -eq $Text) { return $i }
    }
    return -1
}

function Find-LineIndexRegex {
    param([System.Collections.Generic.List[string]]$Lines, [string]$Pattern, [int]$From = 0)
    for ($i = $From; $i -lt $Lines.Count; $i++) {
        if ($Lines[$i].Trim() -match $Pattern) { return $i }
    }
    return -1
}

# 1) For each mapping, locate the macro (must currently be empty) and the method's
#    ENDMETHOD. boundary (must currently exist), then extract the block to move.
$extracted = @()
foreach ($pair in $pairs) {
    $defineIdx = Find-LineIndexRegex $macroLines "^DEFINE\s+$([regex]::Escape($pair.Macro))\s*\.$"
    if ($defineIdx -lt 0) {
        Write-Warning "Macro '$($pair.Macro)' not found in $MacrosAbapPath - skipping mapping '$($pair.Method)=$($pair.Macro)'."
        continue
    }
    $endDefIdx = Find-LineIndex $macroLines "END-OF-DEFINITION." ($defineIdx + 1)
    if ($endDefIdx -lt 0) {
        Write-Warning "No END-OF-DEFINITION. found after DEFINE $($pair.Macro) - skipping."
        continue
    }
    if ($endDefIdx -ne $defineIdx + 1) {
        Write-Warning "Macro '$($pair.Macro)' already has a non-empty body - skipping (nothing to pull in)."
        continue
    }

    $methodIdx = Find-LineIndexRegex $clasLines "^METHOD\s+$([regex]::Escape($pair.Method))\s*\.$"
    if ($methodIdx -lt 0) {
        throw "Method '$($pair.Method)' not found in $ClassAbapPath."
    }

    $boundaryIdx = Find-LineIndexRegex $clasLines "^(METHOD\s+.+\.|ENDMETHOD\.)$" ($methodIdx + 1)
    if ($boundaryIdx -lt 0) {
        throw "No ENDMETHOD. found after method '$($pair.Method)' before end of file."
    }
    if ($clasLines[$boundaryIdx].Trim() -ne 'ENDMETHOD.') {
        Write-Warning "Method '$($pair.Method)' has no ENDMETHOD. of its own (it already just calls the macro) - skipping."
        continue
    }
    $endMethodIdx = $boundaryIdx

    $callIdx = -1
    for ($i = $methodIdx + 1; $i -lt $endMethodIdx; $i++) {
        if ($clasLines[$i].Trim() -eq "$($pair.Macro).") { $callIdx = $i; break }
    }
    if ($callIdx -lt 0) {
        throw "Macro call '$($pair.Macro).' not found in method '$($pair.Method)'."
    }

    $body = [System.Collections.Generic.List[string]]::new()
    for ($i = $callIdx + 1; $i -le $endMethodIdx; $i++) { $body.Add($clasLines[$i]) }

    $extracted += [PSCustomObject]@{
        Method       = $pair.Method
        Macro        = $pair.Macro
        DefineIdx    = $defineIdx
        CallIdx      = $callIdx
        EndMethodIdx = $endMethodIdx
        Body         = $body
    }
}

if ($extracted.Count -eq 0) {
    Write-Warning "Nothing to do - none of the given mappings could be processed."
    return
}

if ($WhatIfPreference) {
    foreach ($item in $extracted) {
        Write-Host "Method '$($item.Method)': lines $($item.CallIdx + 2)-$($item.EndMethodIdx + 1) ($($item.Body.Count) lines, including ENDMETHOD.) would move into macro '$($item.Macro)'."
    }
    return
}

# 2) clas.abap: remove the moved block, in descending index order so indices stay stable
foreach ($item in ($extracted | Sort-Object CallIdx -Descending)) {
    $clasLines.RemoveRange($item.CallIdx + 1, $item.EndMethodIdx - $item.CallIdx)
}

# 3) macros.abap: insert the block into the (currently empty) macro body, descending order
foreach ($item in ($extracted | Sort-Object DefineIdx -Descending)) {
    $macroLines.InsertRange($item.DefineIdx + 1, $item.Body)
}

[System.IO.File]::WriteAllLines($ClassAbapPath, $clasLines, $encoding)
[System.IO.File]::WriteAllLines($MacrosAbapPath, $macroLines, $encoding)

Write-Host "Done: $($extracted.Count) macro(s) restored."
foreach ($item in $extracted) {
    Write-Host "  - $($item.Method) -> $($item.Macro) ($($item.Body.Count) lines, including ENDMETHOD.)"
}
