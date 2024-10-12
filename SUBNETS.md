# Subnets & BGP Communities

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
- Germany: Population rank of state

| `$PLACE` | ISO-3166-1 | Location                                     |
| -------- | ---------- | -------------------------------------------- |
| 10840    | 840        | Virginia, US (10th state)                    |
| 11840    | 840        | New York, US (11th state)                    |
| 14840    | 840        | Vermont, US (14th state)                     |
| 31840    | 840        | California, US (31st state)                  |
| 34840    | 840        | Kansas City, US (34th state)                 |
| 4124     | 124        | Ontario, CA (4th largest land mass)          |
| 2124     | 124        | Quebec, CA (2nd largest land mass)           |
| 5124     | 124        | British Columbia, CA (2nd largest land mass) |
| 1276     | 276        | North Rhine-Westphalia (Düsseldorf) Germany  |
| 5276     | 276        | Hesse (Frankfurt) Germany                    |
| 528      | 528        | Netherlands                                  |
| 756      | 756        | Switzerland                                  |

### IXPs

`215207:160:$RS_ASN`

| `$RS_ASN` | IXP       |
| --------- | --------- |
| 209643    | Locix NL  |
| 202409    | Locix DÜS |
| 202409    | Locix FRA |
| 62768     | NVIX      |
| 57369     | ONIX      |
| 57369     | FREMIX    |
| 36090     | F4IX MCI  |
| 47498     | FogIXP    |

Use IXP communities combined with Location communities to determine difference between different IXPs that use the same RS ASN.

## Subnets

### `2602:fbcf:d0::/44`

| Subnet                 | Location             | Description             |
| ---------------------- | -------------------- | ----------------------- |
| `2602:fbcf:d0::/47`    | New York City, US    | Advertised by `pete`    |
| `2602:fbcf:d2::/47`    | Vermont, US          | _Not advertised_        |
| `2602:fbcf:d4::/48`    | Kansas City, US      | Advertised by `yeehaw`  |
| `2602:fbcf:d5::/48`    | California, US       | Advertised by `bay`     |
| `2602:fbcf:d6::/48`    | _unused_             | _unused_                |
| `2602:fbcf:d7:ca::/48` | Quebec, CA           | _Not advertised_        |
| `2602:fbcf:d8:ca::/48` | Ontario, CA          | Advertised by `maple`   |
| `2602:fbcf:d9:ca::/48` | British Columbia, CA | Advertised by `falaise` |
| `2602:fbcf:da::/48`    | Switzerland          | Advertised by `zurich`  |
| `2602:fbcf:db::/48`    | Netherlands          | Advertised by `tulip`   |
| `2602:fbcf:dc::/48`    | Virginia, US         | Advertised by `nova`    |
| `2602:fbcf:dd::/48`    | _unused_             | _unused_                |
| `2602:fbcf:de::/48`    | Germany              | Advertised by `strudel` |
| `2602:fbcf:df::/48`    | ANYCAST              | Anycast Range           |

## Action Communities

Not supported at this time.
