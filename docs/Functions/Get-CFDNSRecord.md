---
external help file: PSCloudFlare-help.xml
Module Name: PSCloudFlare
online version: https://github.com/zloeber/PSCloudFlare
schema: 2.0.0
---

# Get-CFDNSRecord

## SYNOPSIS
List Cloudflare page rules.

## SYNTAX

```
Get-CFDNSRecord [[-ZoneID] <String>] [[-RecordType] <CFDNSRecordType>] [[-Name] <String>] [[-PerPage] <Int32>]
 [[-Order] <String>] [[-Direction] <String>] [[-MatchScope] <String>]
```

## DESCRIPTION
List Cloudflare page rules.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-CFDNSRecord
```

Shows all DNS records in the current zone

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

### -RecordType
Record type to retrieve.
If no value is passed all types will be enumerated.

```yaml
Type: CFDNSRecordType
Parameter Sets: (All)
Aliases: 
Accepted values: A, AAAA, CNAME, TXT, SRV, LOC, MX, NS, SPF

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
DNS record name.
If not passed then all records will be returned.

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

### -PerPage
Maximum results returned per page.
Default is 50.

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

### -Order
Order the results by type, name, content, ttl, or proxied.
Default is name.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 5
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

## INPUTS

## OUTPUTS

## NOTES
Author: Zachary Loeber

## RELATED LINKS

[https://github.com/zloeber/PSCloudFlare](https://github.com/zloeber/PSCloudFlare)

