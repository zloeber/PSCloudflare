---
external help file: PSCloudFlare-help.xml
Module Name: PSCloudFlare
online version: https://github.com/zloeber/PSCloudFlare
schema: 2.0.0
---

# Purge-CFFile

## SYNOPSIS
Purge Files by URL, Cache-Tags or Host

## SYNTAX

### Everything
```
Purge-CFFile [-ZoneID <String>] [-Everything] [<CommonParameters>]
```

### SingleURL
```
Purge-CFFile [-ZoneID <String>] [-Url <String>] [<CommonParameters>]
```

### MultipleURLs
```
Purge-CFFile [-ZoneID <String>] [-Urls <Array>] [<CommonParameters>]
```

### CacheTagsOrHosts
```
Purge-CFFile [-ZoneID <String>] [-CacheTags <Array>] [-Hosts <Array>] [<CommonParameters>]
```

## DESCRIPTION
Purge Files by URL, Cache-Tags or Host

## EXAMPLES

### EXAMPLE 1
```
Purge-CFFile -Urls $StaleUrls
```

## PARAMETERS

### -ZoneID
ZoneID.
If you pass ZoneID it will be targeted otherwise the currently loaded zone from Set-CFCurrentZone is targeted.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Everything
Purge everything

```yaml
Type: SwitchParameter
Parameter Sets: Everything
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Url
Purge a single URL

```yaml
Type: String
Parameter Sets: SingleURL
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Urls
Purge multiple URLs

```yaml
Type: Array
Parameter Sets: MultipleURLs
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CacheTags
Purge by cache tags

```yaml
Type: Array
Parameter Sets: CacheTagsOrHosts
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Hosts
Purge by hosts

```yaml
Type: Array
Parameter Sets: CacheTagsOrHosts
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Leo

## RELATED LINKS
