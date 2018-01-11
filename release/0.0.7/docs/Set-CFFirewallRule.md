---
external help file: PSCloudFlare-help.xml
Module Name: PSCloudFlare
online version: https://github.com/zloeber/PSCloudFlare
schema: 2.0.0
---

# Set-CFFirewallRule

## SYNOPSIS
Modifies a cloudflare firewall rule.

## SYNTAX

```
Set-CFFirewallRule [[-ZoneID] <String>] [-ID] <String[]> [[-Item] <String>] [[-Target] <CFFirewallTarget>]
 [[-Mode] <CFFirewallMode>] [[-Notes] <String>]
```

## DESCRIPTION
Modifies a cloudflare firewall rule.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Set-CFFirewallRule -ZoneID $ZoneID -Item '96.9.128.0/24' -Notes 'Load Balancer Ip Block - 4.1' -Target 'ip_range' -Mode:challenge -Verbose
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

### -ID
The firewall ID you would like to modify.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Item
This can be an IP, IP range (Cidr notation), ASN (AS####), or 2 letter Country code

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

### -Target
Are you adding an IP, IP_Range, ASN, or Country?

```yaml
Type: CFFirewallTarget
Parameter Sets: (All)
Aliases: 
Accepted values: ip, ip_range, country, asn

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Mode
What is this rule going to do?
Options include whitelist, block, challenge, js_challenge.
Default is to whitelist.

```yaml
Type: CFFirewallMode
Parameter Sets: (All)
Aliases: 
Accepted values: whitelist, block, challenge, js_challenge

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Notes
Any additional notes for the added firewall rule

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 6
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

