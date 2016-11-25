---
external help file: PSCloudFlare-help.xml
online version: https://github.com/zloeber/PSCloudFlare
schema: 2.0.0
---

# Invoke-CFAPI4Request

## SYNOPSIS
Send REST request to Cloudflare URI.

## SYNTAX

```
Invoke-CFAPI4Request [[-Uri] <Uri>] [[-Headers] <Hashtable>] [[-Body] <Hashtable>] [[-Method] <String>]
```

## DESCRIPTION
Send REST request to Cloudflare URI.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
TBD
```

## PARAMETERS

### -Uri
Target URI to send request to.

```yaml
Type: Uri
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: ($Script:RESTParams).URI
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
Default value: ($Script:RESTParams).Headers
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
Default value: ($Script:RESTParams).Body
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
Default value: ($Script:RESTParams).Method
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES
Author: Zachary Loeber

## RELATED LINKS

[https://github.com/zloeber/PSCloudFlare](https://github.com/zloeber/PSCloudFlare)

