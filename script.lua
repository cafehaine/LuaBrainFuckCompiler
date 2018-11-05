local pprint = require("prettyprint").print

local before = [[section .data
	buffer: times 256 db 0	; buffer of memory

section .text
	global _start

_start:
	mov rbx, 0	; mem pointer
]]

local after = [[

	mov rax, 60	; id syscall sys_exit
	mov rdi, 0	; arg 1 de sys_exit (exit code)
	syscall

read_byte:
	mov rax, 0	; sys_read
	mov rdi, 0	; fd STDIN

	mov rsi, buffer
	add rsi, rbx	; buffer + pointeur

	mov rdx, 1	; len
	syscall
	ret

write_byte:
	mov rax, 1	; sys_write
	mov rdi, 1	; fd STDOUT

	mov rsi, buffer
	add rsi, rbx	; buffer + pointeur

	mov rdx, 1	; len
	syscall
	ret
]]

local instructions = {
	[">"] = [[

	add bl, {count}]],
	["<"] = [[

	sub bl, {count}]],
	["+"] = [[

	mov rsi, buffer
	add rsi, rbx
	add byte [rsi], {count}]],
	["-"] = [[

	mov rsi, buffer
	add rsi, rbx
	sub byte [rsi], {count}]],
	["."] = [[

	call write_byte]],
	[","] = [[

	call read_byte]]
}

-- Only those opcodes are "optimized" at the moment
local repeatables {[">"] = true, ["<"] = true, ["+"] = true, ["-"] = true}

-- Recursively generates an AST for the passed code
function genast(code)
	local tree = {}
	local i = 1

	while i <= #code do
		local c = code:sub(i,i)

		if c == "[" then
			local loop, delta = genast(code:sub(i+1))
			i = i + delta
			tree[#tree+1] = {op=loop}

		elseif c == "]" then
			i = i + 1
			return tree, i

		elseif repeatables[c] then
			i = i + 1
			local count = 1
			while i <= #code and code:sub(i,i) == c do
				count = count + 1
				i = i + 1
			end
			tree[#tree+1] = {op=c, count=count}

		elseif instructions[c] then
			i = i + 1
			tree[#tree+1] = {op=c}
		else
			i = i + 1
		end
	end

	return tree,i
end

function asttoasm(ast)
	local output = {}
	output[#output+1] = before
	for k,v in ipairs(ast) do
		output[#output+1] = instructions[v.op]:gsub("{count}",v.count)
	end
	output[#output+1] = after
	return table.concat(output)
end

local hello_no_loops = [[++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++.  Increment to 'H' and print
+++++++++++++++++++++++++++++.                                             Increment to 'e' and print
+++++++.                                                                   Increment to 'l' and print
.                                                                          Value is already at 'l' so just print
+++.                                                                       Increment to 'o' and print
]]

local ast = genast(hello_no_loops)

print(asttoasm(ast))
