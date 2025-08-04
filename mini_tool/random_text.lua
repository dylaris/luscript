local function split_into_words(text)
    local words = {}
    for word in string.gmatch(text, "%w+") do
        table.insert(words, word)
    end
    return words
end

local function build_transition_matrix(words)
    local matrix = {}

    for i = 1, #words - 1 do
        local current_word = words[i]
        local next_word = words[i+1]

        -- matrix[current_word] is a tbale
        -- which stores the key-value pair 
        -- like { next_word: count }
        if not matrix[current_word] then
            matrix[current_word] = {}
        end

        -- Record the count of next_word after current_word
        if not matrix[current_word][next_word] then
            matrix[current_word][next_word] = 0
        end
        matrix[current_word][next_word] = matrix[current_word][next_word] + 1
    end

    return matrix
end

local function convert_to_probalities(matrix)
    for current_word, next_words in pairs(matrix) do
        local total = 0
        for _, count in pairs(next_words) do
            total = total + count
        end

        for next, count in pairs(next_words) do
            matrix[current_word][next] = count / total
        end
    end
end

local function generate_random_text(start_word, matrix, length)
    local current_word = start_word
    local result = {current}

    for i = 1, length - 1 do
        local next_words = matrix[current_word]
        if not next_words then
            print(">>> NO TRANSITION <<<  ---> " .. current_word)
            break
        end

        -- Cumulative probability distribution
        local total_prob = 0
        local rand = math.random()
        for next_word, prob in pairs(next_words) do
            total_prob = total_prob + prob
            if rand <= total_prob then
                table.insert(result, next_word)
                current_word = next_word
                break
            end
        end
    end

    return table.concat(result, " ")
end

local function main()
    if #arg ~= 3 then
        print("usage: lua random_text.lua <FILE> <START> <LENGTH>")
        return 
    end

    local filename = arg[1]
    local start_word = arg[2]
    local length = arg[3]

    local file = assert(io.open(filename, "r"))
    local text = file:read("a")
    io.close(file)

    local words = split_into_words(text)
    local matrix = build_transition_matrix(words)
    convert_to_probalities(matrix)
    local random_text = generate_random_text(start_word, matrix, length)
    print(random_text)
end

main()
