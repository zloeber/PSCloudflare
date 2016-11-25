---
external help file: PSCloudFlare-help.xml
online version: https://github.com/zloeber/PSCloudFlare
schema: 2.0.0
---

# Get-CFFirewallRule

## SYNOPSIS
List Cloudflare firewall rules.

## SYNTAX

```
Get-CFFirewallRule [[-ZoneID] <String>]
```

## DESCRIPTION
List Cloudflare firewall rules.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-CFFirewallRule
```

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

## INPUTS

## OUTPUTS

## NOTES
Author: Zachary Loeber

## RELATED LINKS

[https://github.com/zloeber/PSCloudFlare](https://github.com/zloeber/PSCloudFlare)

