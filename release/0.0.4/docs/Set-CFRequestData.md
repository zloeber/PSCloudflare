---
external help file: PSCloudFlare-help.xml
online version: https://github.com/zloeber/PSCloudFlare
schema: 2.0.0
---

# Set-CFRequestData

## SYNOPSIS
Sets the parameters for a request to the Cloudflare API.

## SYNTAX

```
Set-CFRequestData [-URI] <String> [[-Headers] <Hashtable>] [[-Body] <Hashtable>] [[-Method] <String>]
```

## DESCRIPTION
Sets the parameters for a request to the Cloudflare API.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
TBD
```

## PARAMETERS

### -URI
Target URI to send request to.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Headers
All the headers in hashtable format you will be sending.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: $Script:Headers
Accept pipeline input: False
Accept wildcard characters: False
```

### -Body
The body of the REST request

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Method
REST method to send.
Can be Head, Get, Put, Patch, Post, or Delete.
Default is Get.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 4
Default value: Get
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES
Author: Zachary Loeber

## RELATED LINKS

[https://github.com/zloeber/PSCloudFlare](https://github.com/zloeber/PSCloudFlare)

