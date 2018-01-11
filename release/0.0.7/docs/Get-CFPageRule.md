---
external help file: PSCloudFlare-help.xml
Module Name: PSCloudFlare
online version: https://github.com/zloeber/PSCloudFlare
schema: 2.0.0
---

# Get-CFPageRule

## SYNOPSIS
List Cloudflare page rules.

## SYNTAX

```
Get-CFPageRule [[-ZoneID] <String>] [[-Status] <CFPageRuleStatus>] [[-OrderBy] <String>]
 [[-Direction] <String>] [[-MatchScope] <String>] [[-PageLimit] <Int32>]
```

## DESCRIPTION
List Cloudflare page rules.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-CFPageRule
```

Shows all cloudflare Page rules for the zone.

### -------------------------- EXAMPLE 2 --------------------------
```
TBD
```

## PARAMETERS

### -ZoneID
If you pass ZoneID it will be targeted otherwise the currently loaded zone from Set-CFCurrentZone is targeted.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Status
Rule status.
Can be active, inactive, or null.
Default is null (returns both active and inactive rules).

```yaml
Type: CFPageRuleStatus
Parameter Sets: (All)
Aliases: 
Accepted values: active, disabled

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OrderBy
Order the results by status or priority.
Default is priority.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: Priority
Accept pipeline input: False
Accept wildcard characters: False
```

### -Direction
Return results in asc (ascending) or dec (decending) order.
Default is asc.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 4
Default value: Asc
Accept pipeline input: False
Accept wildcard characters: False
```

### -MatchScope
Match either 'any' or 'all' the supplied matching parameters passed to this function.
Default is all.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 5
Default value: All
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageLimit
Maximum results returned per page.
Default is 50.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: 6
Default value: 50
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES
Author: Zachary Loeber

## RELATED LINKS

[https://github.com/zloeber/PSCloudFlare](https://github.com/zloeber/PSCloudFlare)

