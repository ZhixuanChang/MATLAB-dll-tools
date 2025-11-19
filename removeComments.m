function code_str = removeComments(code_str)
%remove comments from the input code string.

while contains(code_str, '//')
    pos = strfind(code_str, '//');
    part1 = code_str(1:pos(1)-1);
    part2 = code_str(pos(1)+2:end);
    pos = strfind(part2, sprintf('\n'));
    if isempty(pos)
        % there is nothing behind the comments
        code_str = part1;
    else
        part2 = part2(pos(1)+1:end);
        code_str = [part1, part2];
    end
end
end

