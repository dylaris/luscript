local reader = require("reader"):new("hello")
local byteop = require("byteop")

local little_endian = true

local ELF_file = {
    header = {}
}

local function fmt_print(fmt, prompt, ...)
    print(string.format("%-15s " .. fmt, prompt .. ":", table.unpack{...}))
end

local function print_header()
    local header = ELF_file.header

    local magic = header.ident.magic
    fmt_print("0x%02X %c %c %c", "Magic", magic[1], magic[2], magic[3], magic[4])
    local class = header.ident.class
    fmt_print("%s", "Class", class == 32 and "32 bit" or "64 bit")
    local data = header.ident.data
    fmt_print("%s", "Data", data == 1 and "little endian" or "big endian")
    fmt_print("%d", "Version", header.ident.version)
    local osabi = header.ident.osabi
    fmt_print("%s", "OSABI", osabi == 0 and "UNIX System V ABI" or "Unknown")
    fmt_print("%d", "ABI Version", header.ident.abiversion)
    fmt_print("%s", "Pad", table.concat(header.ident.pad, " "))

    if header.type == 0 then
        fmt_print("%s", "Type", "NONE")
    elseif header.type == 1 then
        fmt_print("%s", "Type", "REL")
    elseif header.type == 2 then
        fmt_print("%s", "Type", "EXEC")
    elseif header.type == 3 then
        fmt_print("%s", "Type", "DYN")
    elseif header.type == 4 then
        fmt_print("%s", "Type", "CORE")
    else
        fmt_print("%s", "Type", "UNKNOWN")
    end

    if header.machine == 62 then 
        fmt_print("%s", "Machine", "X86-64")
    elseif header.machine == 3 then
        fmt_print("%s", "Machine", "X86")
    elseif header.machine == 40 then
        fmt_print("%s", "Machine", "ARM")
    else
        fmt_print("%s", "Machine", "UNKNOWN")
    end

    fmt_print("%d", "Version", header.version)
    fmt_print("0x%X", "Entry", header.entry)
    fmt_print("%d", "Phoff", header.phoff)
    fmt_print("%d", "Shoff", header.shoff)
    fmt_print("%d", "Flags", header.flags)
    fmt_print("%d", "Ehsize", header.ehsize)
    fmt_print("%d", "Phentsize", header.phentsize)
    fmt_print("%d", "Phnum", header.phnum)
    fmt_print("%d", "Shentsize", header.shentsize)
    fmt_print("%d", "Shnum", header.shnum)
    fmt_print("%d", "Shstrndx", header.shstrndx)
end

local function parse_header()
    local header = ELF_file.header

    -- unsigned char e_ident[16];   /* Magic number and other info */
    header.ident = {}
    header.ident.magic = reader:read(4)
    header.ident.class = reader:read(1)
    header.ident.data = reader:read(1)[1]
    if header.ident.data == 2 then little_endian = false end
    header.ident.version = reader:read(1)[1]
    header.ident.osabi = reader:read(1)[1]
    header.ident.abiversion = reader:read(1)[1]
    header.ident.pad = reader:read(7)
    -- uint16_t e_type;             /* Object file type */
    header.type = byteop.to_u16(little_endian, reader:read(2))
    -- uint16_t e_machine;          /* Architecture */
    header.machine = byteop.to_u16(little_endian, reader:read(2))
    -- uint32_t e_version;          /* Object file version */
    header.version = byteop.to_u32(little_endian, reader:read(4))
    -- uint64_t e_entry;            /* Entry point virtual address */
    header.entry = byteop.to_u64(little_endian, reader:read(8))
    -- uint64_t e_phoff;            /* Program header table file offset */
    header.phoff = byteop.to_u64(little_endian, reader:read(8))
    -- uint64_t e_shoff;            /* Section header table file offset */
    header.shoff = byteop.to_u64(little_endian, reader:read(8))
    -- uint32_t e_flags;            /* Processor-specific flags */
    header.flags = byteop.to_u32(little_endian, reader:read(4))
    -- uint16_t e_ehsize;           /* ELF header size in bytes */
    header.ehsize = byteop.to_u16(little_endian, reader:read(2))
    -- uint16_t e_phentsize;        /* Program header table entry size */
    header.phentsize = byteop.to_u16(little_endian, reader:read(2))
    -- uint16_t e_phnum;            /* Program header table entry count */
    header.phnum = byteop.to_u16(little_endian, reader:read(2))
    -- uint16_t e_shentsize;        /* Section header table entry size */
    header.shentsize = byteop.to_u16(little_endian, reader:read(2))
    -- uint16_t e_shnum;            /* Section header table entry count */
    header.shnum = byteop.to_u16(little_endian, reader:read(2))
    -- uint16_t e_shstrndx;         /* Section header string table index */
    header.shstrndx = byteop.to_u16(little_endian, reader:read(2))
end

parse_header()
print_header()
