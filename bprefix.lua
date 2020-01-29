#!/usr/bin/env lua

-- bprefix.lua - Display byte sizes formatted with IEC and SI binary prefixes
-- from standard input or command-line arguments

-- PREFIXES - Lookup table for 1-9 Binary Prefix units
-- See: https://en.wikipedia.org/wiki/Binary_prefix
PREFIXES = {
	[1] = 'K',
	[2] = 'M',
	[3] = 'G',
	[4] = 'M',
	[5] = 'T',
	[6] = 'P',
	[7] = 'E',
	[8] = 'Z',
	[9] = 'Y'
}

-- Implement log function with a paramaterized base value
-- log[b](x) = log[c](x) / log[c](b)
function logn(x, b)
	return math.log(x) / math.log(b)
end

-- Truncate a (floating point) number
function trunc(num)
	float = string.format("%f", num)
	whole_portion = string.gmatch(float, "(%d+).")()
	return tonumber(whole_portion)
end

-- Format a decimal number with a prefix computed based on function
-- arguments. This is a generic method use by both format_si and format_iec.
-- 
-- num: a whole decimal number to format
-- base: the number system used by 'num' (eg. 10 for decimal/SI or 2 for binary/IEC)
-- divisor: a divisor adjusting logn(num, base) so it produces an index usable against the 'PREFIXES' table
-- prefix_appendum: a string value appended to the computed prefix value
function format_prefix_generic(num, base, divisor, prefix_appendum)
	-- find the unit index, and cap it to the largest unit in PREFIXES table
	unit_idx = trunc(logn(num, base) / divisor)
	unit_idx = math.min(unit_idx, #PREFIXES)

	if unit_idx == 0 then
		-- if supplied value is too small to have an applicable prefix,
		-- show the whole decimal formatted as bytes
		return string.format("%d %s", num, 'b')
	else
		-- if supplied value was large enough to have a si/iec prefix, format
		-- it as appropriate
		prefix = PREFIXES[unit_idx] .. prefix_appendum
		adjusted_num = num / (base ^ (unit_idx * divisor))
		return string.format("%.2f %s", adjusted_num, prefix)
	end
end

-- Format and return a string containing the highest applicable Si prefix
-- (base-10) value of the given number
function format_si(num)
	return format_prefix_generic(num, 10, 3, 'b')
end

-- Format and return a string containing the highest applicable IEC prefix
-- (base-2) value of the given number
function format_iec(num)
	return format_prefix_generic(num, 2, 10, 'ib')
end

-- Given a string value containing a decimal, format and return a string
-- showing the original value, the value formatted with an Si Prefix, and the
-- value formatted with an IEC prefix
function format_main(str)
	local num = tonumber(str)
	if (num == nil) then
		return string.format("Err: '%s' is not a number", str)
	end

	return string.format("%s = %s = %s",
		str, format_si(num), format_iec(num))
end

-- Format and print line-separated values from standard input
function process_stdin()
	line = io.read()
	while line do
		print(format_main(line, false))
		line = io.read()
	end
end

-- Format and print line-separated values from command-line arguments
function process_argv()
	for i = 1, #arg do
		print(format_main(arg[i], eic))
	end
end

-- Main entrypoint
function main()
	if (#arg <= 0) then
		process_stdin() -- no command-line arguments, so use stdin as input
	else
		process_argv() -- CLI arguments exist, so use argv as input
	end
end

main()
