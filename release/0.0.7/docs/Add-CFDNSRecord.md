---
external help file: PSCloudFlare-help.xml
Module Name: PSCloudFlare
online version: https://github.com/zloeber/PSCloudFlare
schema: 2.0.0
---

# Add-CFDNSRecord

## SYNOPSIS
Adds a cloudflare dns record.

## SYNTAX

```
Add-CFDNSRecord [[-ZoneID] <String>] [-RecordType] <CFDNSRecordType> [-Name] <String> [-Content] <String>
 [[-TTL] <Int32>] [[-Proxied] <CFDNSOrangeCloudMode>]
```

## DESCRIPTION
Adds a cloudflare dns record.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
TBD
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

### -RecordType
Type of record to modify.

```yaml
Type: CFDNSRecordType
Parameter Sets: (All)
Aliases: 
Accepted values: A, AAAA, CNAME, TXT, SRV, LOC, MX, NS, SPF

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
name of the record to modify.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Content
DNS record value write.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TTL
Time to live, optional update setting.
Default is 120.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: 5
Default value: 120
Accept pipeline input: False
Accept wildcard characters: False
```

### -Proxied
Set or unset orange cloud mode for a record.
Optional.

```yaml
Type: CFDNSOrangeCloudMode
Parameter Sets: (All)
Aliases: 
Accepted values: on, off

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

