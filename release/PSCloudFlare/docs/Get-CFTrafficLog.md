---
external help file: PSCloudFlare-help.xml
Module Name: PSCloudFlare
online version: https://github.com/zloeber/PSCloudFlare
schema: 2.0.0
---

# Get-CFTrafficLog

## SYNOPSIS
List Cloudflare traffic logs.

## SYNTAX

```
Get-CFTrafficLog [[-ZoneID] <String>] [[-OrderBy] <String>] [[-Direction] <String>] [[-PageLimit] <Int32>]
 [[-ResultLimit] <Int32>]
```

## DESCRIPTION
List Cloudflare traffic logs.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-CFTrafficLog
```

Shows all cloudflare firewall rules at the top of the organization

### -------------------------- EXAMPLE 2 --------------------------
```
Set-CFCurrentZone 'contoso.org'
```

PS\> Get-CFTrafficLog

Shows all cloudflare firewall rules for the contoso.org zone.

## PARAMETERS

### -ZoneID
You apply firewall rules to individual zones or to the whole organization.
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

### -OrderBy
Order the results by id, action, host, ip, country, or occurred_at.
Default is occurred_at.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: Occurred_at
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
Position: 3
Default value: Asc
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageLimit
Maximum results returned per page.
Default is 50.
Max is 500.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: 4
Default value: 50
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResultLimit
Maximum page results returned.
Default is 0 (unlimited).

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: 5
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES
Author: Zachary Loeber

## RELATED LINKS

[https://github.com/zloeber/PSCloudFlare](https://github.com/zloeber/PSCloudFlare)

