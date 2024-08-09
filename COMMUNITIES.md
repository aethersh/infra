# BGP Communities

_Exclusively using BGP Large Communities_

Credits/Sources

- https://borderli.net/
- https://datatracker.ietf.org/doc/html/rfc8195

## Info Communities

| Community         | Learned         |
| ----------------- | --------------- |
| `215207:0:100`    | from self       |
| `215207:100:80`   | from transit    |
| `215207:100:90`   | from IXP RS     |
| `215207:100:100`  | from peer       |
| `215207:100:200`  | from downstream |
| `215207:120:$ASN` | from $ASN       |

### Location

`215207:140:$PLACE`

Place codes are based on ISO-3166 numerical country codes, optionally with a numerical prefix:

- United States: Number of state when admitted to the union
- Canada: Land area rank of province

| `$PLACE` | ISO-3166-1 | Location                            |
| -------- | ---------- | ----------------------------------- |
| 10840    | 840        | Virginia, US (10th state)           |
| 11840    | 840        | New York, US (11th state)           |
| 14840    | 840        | Vermont, US (14th state)            |
| 31840    | 840        | California, US (31st state)         |
| 34840    | 840        | Kansas City, US (34th state)        |
| 4124     | 124        | Ontario, CA (4th largest land mass) |
| 2124     | 124        | Quebec, CA (2nd largest land mass)  |
| 276      | 276        | Germany                             |
| 528      | 528        | Netherlands                         |

### IXPs

`215207:160:$RS_ASN`

| `$RS_ASN` | IXP       |
| --------- | --------- |
| 209643    | Locix NL  |
| 202409    | Locix DUS |
| 202409    | Locix FRA |
| 62768     | NVIX      |
| 57369     | ONIX      |
| 57369     | FREMIX    |
| 36090     | F4IX MCI  |
| 47498     | FogIXP    |

Use IXP communities combined with Location communities to determine difference between different IXPs that use the same RS ASN.

## Action Communities

_NO._
