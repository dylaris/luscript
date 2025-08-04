-- Usage: lua count_words.lua <filename>

local function count_words(text)
    local words = {}

    for word in text:gmatch("%w+") do
        word = word:lower()
        words[word] = (words[word] or 0) + 1
    end

    return words
end

local function sort_words(words)
    local sorted_words = {}

    for word, count in pairs(words) do
        table.insert(sorted_words, {key = word, value = count})
    end

    table.sort(sorted_words, function (a, b)
        return a.value > b.value
    end)

    return sorted_words
end

local function count_file_words(filename)
    local file = assert(io.open(filename, "r"))
    local words = count_words(file:read("a"))
    return words
end

local function draw_words(words, sorted)
    if sorted then
        for idx, pair in ipairs(words) do
            print(string.format("[%04d] %-15s %s", idx, pair.key, string.rep("+", pair.value)))
        end
    else
        for word, count in pairs(words) do
            print(string.format("%-15s %s", word, string.rep("+", count)))
        end
    end
end

local function main()
    local filename = arg[1]
    if not filename then return end

    local words = count_file_words(filename)
    words = sort_words(words)
    draw_words(words, true)
end

main()
