---
external help file: PSCloudFlare-help.xml
online version: https://github.com/zloeber/PSCloudFlare
schema: 2.0.0
---

# Get-CFZoneID

## SYNOPSIS
Returns the ZoneID of the passed zone name (if it exists)

## SYNTAX

```
Get-CFZoneID [-Zone] <String>
```

## DESCRIPTION
Returns the ZoneID of the passed zone name (if it exists)

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-CFZoneID -Zone 'contoso.com'
```

## PARAMETERS

### -Zone
Zone name.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

### System.String

## NOTES
Author: Zachary Loeber

## RELATED LINKS

[https://github.com/zloeber/PSCloudFlare](https://github.com/zloeber/PSCloudFlare)

