---
external help file: PSCloudFlare-help.xml
Module Name: PSCloudFlare
online version: https://github.com/zloeber/PSCloudFlare
schema: 2.0.0
---

# Get-CFFirewallRule

## SYNOPSIS
List Cloudflare firewall rules.

## SYNTAX

```
Get-CFFirewallRule [[-ZoneID] <String>] [[-MatchItem] <String>] [[-MatchTarget] <CFFirewallTarget>]
 [[-MatchMode] <CFFirewallMode>] [[-OrderBy] <String>] [[-Direction] <String>] [[-MatchScope] <String>]
 [[-PageLimit] <Int32>]
```

## DESCRIPTION
List Cloudflare firewall rules.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-CFFirewallRule
```

Shows all cloudflare firewall rules at the top of the organization

### -------------------------- EXAMPLE 2 --------------------------
```
Set-CFCurrentZone 'contoso.org'
```

PS\> Get-CFFirewallRule

Shows all cloudflare firewall rules for the contoso.org zone.

### -------------------------- EXAMPLE 3 --------------------------
```
Get-CFFirewallRule -MatchMode whitelist
```

Shows only whitelist firewall items

### -------------------------- EXAMPLE 4 --------------------------
```
Get-CFFirewallRule -MatchMode whitelist -MatchItem '4.2.2.2' -MatchScope any
```

Returns any whitelisted item that matches 4.2.2.2

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

### -MatchItem
This can be an IP, IP range (Cidr notation), ASN (AS####), or 2 letter Country code if matching by Target in your search.
Default is null (match all items).

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

### -MatchTarget
Are you matching an IP, IP_Range, ASN, or Country?

```yaml
Type: CFFirewallTarget
Parameter Sets: (All)
Aliases: 
Accepted values: ip, ip_range, country, asn

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MatchMode
Matches only firewall rules with this mode.
Options include whitelist, block, challenge, js_challenge.
Default is null (match all modes)

```yaml
Type: CFFirewallMode
Parameter Sets: (All)
Aliases: 
Accepted values: whitelist, block, challenge, js_challenge

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
Default value: Configuration_value
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

