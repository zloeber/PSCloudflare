---
external help file: PSCloudFlare-help.xml
Module Name: PSCloudFlare
online version: https://github.com/zloeber/PSCloudFlare
schema: 2.0.0
---

# Get-CFWAFRuleGroup

## SYNOPSIS
List Cloudflare WAF rules.

## SYNTAX

```
Get-CFWAFRuleGroup [[-ZoneID] <String>] [[-PackageID] <String>] [[-Name] <String>]
 [[-Mode] <CFWAFRuleGroupMode>] [[-OrderBy] <String>] [[-Direction] <String>] [[-MatchScope] <String>]
 [[-PageLimit] <Int32>]
```

## DESCRIPTION
List Cloudflare WAF rules.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-CFWAFRuleGroup
```

Shows all cloudflare WAF rule groups for the zone.

## PARAMETERS

### -ZoneID
You apply WAF rules to individual zones or to the whole organization.
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

### -PackageID
Package ID to query.
If not supplied then all package IDs are queried.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
rule group name.
If not supplied then all rule groups are returned.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Mode
WAF rule group mode to query for.
Can be on or off.
Default is all modes.

```yaml
Type: CFWAFRuleGroupMode
Parameter Sets: (All)
Aliases: 
Accepted values: on, off

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OrderBy
Order the results by configuration_target, configuration_value, or mode.
Default is configuration_value

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 5
Default value: Mode
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
Position: 6
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
Position: 7
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
Position: 8
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

