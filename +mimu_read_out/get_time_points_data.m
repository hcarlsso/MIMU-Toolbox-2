function tp = get_time_points_data(cursorinfo)

    tp.time = cursorinfo(1:2:end);
    tp.values = cursorinfo(2:2:end);

end