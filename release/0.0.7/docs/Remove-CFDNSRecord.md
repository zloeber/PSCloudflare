---
external help file: PSCloudFlare-help.xml
Module Name: PSCloudFlare
online version: https://github.com/zloeber/PSCloudFlare
schema: 2.0.0
---

# Remove-CFDNSRecord

## SYNOPSIS
Removes a cloudflare dns record.

## SYNTAX

```
Remove-CFDNSRecord [[-ZoneID] <String>] [-ID] <String>
```

## DESCRIPTION
Removes a cloudflare dns record.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Remove-CFDNSRecord -ZoneId abcdef0123456789abcdef0123456789 -ID 0123456789abcdef0123456789abcdef
```

## PARAMETERS

### -ZoneID
You apply dns records to individual zones or to the whole organization.
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
The dns record ID you would like to modify.
If not defined it will be derived from the Name and RecordType parameters.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES
Author: Karl Barbour

## RELATED LINKS

[https://github.com/zloeber/PSCloudFlare](https://github.com/zloeber/PSCloudFlare)

