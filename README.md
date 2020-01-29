# bprefix

Convert byte counts to human-readable SI and IEC binary prefix formatted
strings.

## Dependencies

- Lua 5.3 or 5.2

## Usage

`bprefix.lua` accepts values from standard input or command-line arguments.

### Example #1: Input from arguments

```
$ ./bprefix.lua 1287451
1287451 = 1.29 Mb = 1.23 Mib
```

### Example #2: Input from stdin

```
$ seq 992 8 1040 | ./bprefix.lua
992 = 992 b = 992 b
1000 = 1.00 Kb = 1000 b
1008 = 1.01 Kb = 1008 b
1016 = 1.02 Kb = 1016 b
1024 = 1.02 Kb = 1.00 Kib
1032 = 1.03 Kb = 1.01 Kib
1040 = 1.04 Kb = 1.02 Kib
```
