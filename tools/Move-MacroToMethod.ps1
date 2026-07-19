<#
.SYNOPSIS
    Moves the code of an ABAP macro (DEFINE ... END-OF-DEFINITION) into the method
    it is assigned to. The macro is left with an empty body afterwards, the method
    keeps the macro call and additionally contains the full code directly.

.DESCRIPTION
    Expects the classic abapGit file pair:
        <class>.clas.abap           (implementation, contains "METHOD x. <macro-call>.")
        <class>.clas.macros.abap    (contains "DEFINE <macro>. ... END-OF-DEFINITION.")

    For each "Method=Macro" mapping:
      1. The macro's body is extracted from the .macros.abap file.
      2. If the body ends with "ENDMETHOD." (typical when the macro took over the
         rest of the method including its closing statement), that line is split
         off and re-appended separately after the inserted code instead.
      3. The macro body in the .macros.abap file is cleared (DEFINE/END-OF-DEFINITION
         are kept).
      4. In the .clas.abap file, the code is inserted directly after the existing
         macro call in the respective method (the call itself is kept).

    The script is idempotent: if a macro is already empty, or the code is already
    present in the method, the respective mapping is skipped with a warning.

.PARAMETER ClassAbapPath
    Path to the "<class>.clas.abap" file. The associated macro file is derived
    automatically by replacing ".clas.abap" with ".clas.macros.abap" (standard
    abapGit naming scheme). Alternatively pass -MacrosAbapPath explicitly.

.PARAMETER MacrosAbapPath
    Optional explicit path to the macro file, in case the naming scheme doesn't apply.

.PARAMETER Mapping
    One or more mappings in the format "MethodName=MacroName".

.PARAMETER WhatIf
    Only shows what would be done (extraction/insert positions), without writing
    any files.

.EXAMPLE
    .\tools\Move-MacroToMethod.ps1 `
        -ClassAbapPath "src/#cadaxo#cl_sqlc_cockpit_parse.clas.abap" `
        -Mapping "execute_select_via_subpool=create_dynamic_select_subpool", `
                 "execute_select_via_subpool_v_2=create_dynamic_select_subpool2", `
                 "execute_select_v_1=m_execute_select", `
                 "execute_select_v_2=m_execute_select_v_2"

.EXAMPLE
    # Preview only, no changes written to disk
    .\tools\Move-MacroToMethod.ps1 -ClassAbapPath "src/#cadaxo#cl_sqlc_cockpit_parse.clas.abap" `
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

# 1) Extract all macro bodies from the original line list (before any modification)
$extracted = @()
foreach ($pair in $pairs) {
    $defineIdx = Find-LineIndexRegex $macroLines "^DEFINE\s+$([regex]::Escape($pair.Macro))\s*\.$"
    if ($defineIdx -lt 0) {
        Write-Warning "Macro '$($pair.Macro)' not found in $MacrosAbapPath - skipping mapping '$($pair.Method)=$($pair.Macro)'."
        continue
    }
    $endIdx = Find-LineIndex $macroLines "END-OF-DEFINITION." ($defineIdx + 1)
    if ($endIdx -lt 0) {
        Write-Warning "No END-OF-DEFINITION. found after DEFINE $($pair.Macro) - skipping."
        continue
    }

    if ($endIdx -eq $defineIdx + 1) {
        Write-Warning "Macro '$($pair.Macro)' already has an empty body - nothing to move."
        continue
    }

    $body = [System.Collections.Generic.List[string]]::new()
    for ($i = $defineIdx + 1; $i -lt $endIdx; $i++) { $body.Add($macroLines[$i]) }

    # Split off a trailing ENDMETHOD. (with optional blank lines before it) -> re-appended separately later
    $appendEndmethod = $false
    while ($body.Count -gt 0 -and $body[$body.Count - 1].Trim() -eq '') {
        $body.RemoveAt($body.Count - 1)
    }
    if ($body.Count -gt 0 -and $body[$body.Count - 1].Trim() -eq 'ENDMETHOD.') {
        $body.RemoveAt($body.Count - 1)
        while ($body.Count -gt 0 -and $body[$body.Count - 1].Trim() -eq '') {
            $body.RemoveAt($body.Count - 1)
        }
        $appendEndmethod = $true
    }

    # Strip leading blank lines (pure formatting right after DEFINE) so they don't get
    # confused with the blank lines that already sit between methods during the
    # idempotency check.
    while ($body.Count -gt 0 -and $body[0].Trim() -eq '') {
        $body.RemoveAt(0)
    }

    if ($body.Count -eq 0) {
        Write-Warning "Macro '$($pair.Macro)' has no code body left after cleanup - skipping."
        continue
    }

    $extracted += [PSCustomObject]@{
        Method          = $pair.Method
        Macro           = $pair.Macro
        DefineIdx       = $defineIdx
        EndDefIdx       = $endIdx
        Body            = $body
        AppendEndmethod = $appendEndmethod
    }
}

if ($extracted.Count -eq 0) {
    Write-Warning "Nothing to do - none of the given mappings could be processed."
    return
}

# 2) For each extracted macro, find its call inside the matching method in clas.abap
foreach ($item in $extracted) {
    $methodIdx = Find-LineIndexRegex $clasLines "^METHOD\s+$([regex]::Escape($item.Method))\s*\.$"
    if ($methodIdx -lt 0) {
        throw "Method '$($item.Method)' not found in $ClassAbapPath."
    }
    $nextMethodIdx = Find-LineIndexRegex $clasLines "^(METHOD\s+.+\.|ENDMETHOD\.)$" ($methodIdx + 1)
    if ($nextMethodIdx -lt 0) { $nextMethodIdx = $clasLines.Count }

    $callIdx = -1
    for ($i = $methodIdx + 1; $i -lt $nextMethodIdx; $i++) {
        if ($clasLines[$i].Trim() -eq "$($item.Macro).") { $callIdx = $i; break }
    }
    if ($callIdx -lt 0) {
        throw "Macro call '$($item.Macro).' not found in method '$($item.Method)'."
    }

    # Idempotency: compare the next NON-blank line after the call with the first body
    # line (otherwise the blank lines between methods would always be a false-positive match).
    $nextNonBlankIdx = $callIdx + 1
    while ($nextNonBlankIdx -lt $nextMethodIdx -and $clasLines[$nextNonBlankIdx].Trim() -eq '') {
        $nextNonBlankIdx++
    }
    if ($nextNonBlankIdx -lt $nextMethodIdx -and
        $clasLines[$nextNonBlankIdx].Trim() -eq $item.Body[0].Trim()) {
        Write-Warning "Method '$($item.Method)' already contains code after the macro call - skipping."
        continue
    }

    $item | Add-Member -NotePropertyName CallIdx -NotePropertyValue $callIdx
}

$toInsert = $extracted | Where-Object { $_.PSObject.Properties.Name -contains 'CallIdx' }

if ($WhatIfPreference) {
    foreach ($item in $toInsert) {
        Write-Host "Method '$($item.Method)': call '$($item.Macro).' at line $($item.CallIdx + 1), $($item.Body.Count) code lines would be inserted$(if ($item.AppendEndmethod) { ' (+ ENDMETHOD.)' })."
        Write-Host "Macro '$($item.Macro)' in $MacrosAbapPath would be cleared."
    }
    return
}

# 3) clas.abap: insert in descending index order so indices stay stable
foreach ($item in ($toInsert | Sort-Object CallIdx -Descending)) {
    $insertLines = [System.Collections.Generic.List[string]]::new($item.Body)
    if ($item.AppendEndmethod) { $insertLines.Add("  ENDMETHOD.") }
    $clasLines.InsertRange($item.CallIdx + 1, $insertLines)
}

# 4) macros.abap: remove bodies in descending index order (macro stays with an empty body)
foreach ($item in ($toInsert | Sort-Object DefineIdx -Descending)) {
    $macroLines.RemoveRange($item.DefineIdx + 1, $item.EndDefIdx - $item.DefineIdx - 1)
}

[System.IO.File]::WriteAllLines($ClassAbapPath, $clasLines, $encoding)
[System.IO.File]::WriteAllLines($MacrosAbapPath, $macroLines, $encoding)

Write-Host "Done: $($toInsert.Count) macro(s) moved."
foreach ($item in $toInsert) {
    Write-Host "  - $($item.Macro) -> $($item.Method) ($($item.Body.Count) lines$(if ($item.AppendEndmethod) { ' + ENDMETHOD.' }))"
}
