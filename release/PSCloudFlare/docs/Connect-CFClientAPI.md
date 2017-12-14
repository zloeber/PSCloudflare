---
external help file: PSCloudFlare-help.xml
Module Name: PSCloudFlare
online version: https://github.com/zloeber/PSCloudFlare
schema: 2.0.0
---

# Connect-CFClientAPI

## SYNOPSIS
Connects to the CloudFlare API for future requests.

## SYNTAX

```
Connect-CFClientAPI [-APIToken] <String> [-EmailAddress] <String>
```

## DESCRIPTION
Connects to the CloudFlare API for future requests.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Connect-CFClientAPI -APIToken xxxxxxxxxxxxxxxxxxxxx -EmailAddress 'jdoe@contoso.com'
```

## PARAMETERS

### -APIToken
The Cloudflare API token.

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

### -EmailAddress
The associated email address with this Cloudflare API token.

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
Author: Zachary Loeber

## RELATED LINKS

[https://github.com/zloeber/PSCloudFlare](https://github.com/zloeber/PSCloudFlare)

