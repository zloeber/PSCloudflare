---
external help file: PSCloudFlare-help.xml
Module Name: PSCloudFlare
online version: https://github.com/zloeber/PSCloudFlare
schema: 2.0.0
---

# Get-CFWAFRulePackage

## SYNOPSIS
List Cloudflare WAF rules.

## SYNTAX

```
Get-CFWAFRulePackage [[-ZoneID] <String>] [[-Name] <String>] [[-OrderBy] <String>] [[-Direction] <String>]
 [[-MatchScope] <String>] [[-PageLimit] <Int32>]
```

## DESCRIPTION
List Cloudflare WAF rules.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Set-CFCurrentZone 'contoso.org'
```

PS\> Get-CFWAFRulePackage

Shows all cloudflare WAF rule packages for the contoso.org zone.

### -------------------------- EXAMPLE 2 --------------------------
```
TBD
```

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

### -Name
rule package name.
If not supplied then all rule packages are returned.

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

### -OrderBy
Order the results by configuration_target, configuration_value, or mode.
Default is configuration_value

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: Name
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

