module SaveREPL

export saveREPL

immutable REPLEntry
    time::String
    mode::String
    command::String
end

function saveREPL(path::String)
    println("\tWhich lines would you like to save?")
    print("\tLines: ")
    lines = chomp(replace(readline(), " ", ""))
    println("Save lines $lines to $path? [Y/n]")
    confirm = lowercase(strip(readline()))
    if confirm == "y"
        julia_history = history()
        f = open(path, "w")
        write(f, script(julia_history, lines))
        close(f)
    end
end

function script(histories, lines)
    lines = reverse(split(lines, ','))
    output = ""
    history = reverse(histories)
    for line in lines
        if contains(line, ":") # found range
            line_range = int(reverse(split(line, ':')))
            if length(line_range) == 2
                line_range = range(line_range[1],-1,line_range[2])
            elseif length(line_range) == 3
                line_range[2] = -line_range[2]
                line_range = range(line_range...)
            end
            entries = history[line_range+1]
        else
            entries = [history[int(line)+1]]
        end
        for entry in entries
            entry.mode == "julia" || error("cannot output shell or help modes")
            output *= entry.command
        end
    end
    return output
end

function history()
    julia_history = open(Base.REPL.find_hist_file())
    line = readline(julia_history)
    histories = REPLEntry[]
    while !eof(julia_history)
        if contains(line, "# time: ")
            time = replace(chomp(line), "# time: ", "")
            mode = replace(chomp(readline(julia_history)), "# mode: ", "")
            line = readline(julia_history)
            command = ""
            while beginswith(line, "\t")
                command *= replace(line, "\t", "", 1)
                line = readline(julia_history)
            end
            push!(histories, REPLEntry(time, mode, command))
        end
    end
    close(julia_history)
    return histories
end

end # module
