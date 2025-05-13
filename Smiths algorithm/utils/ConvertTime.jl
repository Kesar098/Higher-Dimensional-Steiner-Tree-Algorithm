function print_time(total_seconds::Float64)
    hours = Int(div(total_seconds, 3600))
    minutes = Int(div(total_seconds % 3600, 60))
    seconds = total_seconds % 60
    
    if (hours == 0)&&(minutes == 0)
        println("Time taken: $seconds seconds")
    elseif (hours == 0)
        println("Time taken: $minutes minutes, $seconds seconds.  ($total_seconds seconds.)" )
    else
        println("Time taken: $hours hours, $minutes minutes, $seconds seconds. ($total_seconds seconds.)")
    end
    return nothing
end