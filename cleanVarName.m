function name_str = cleanVarName(name_str)
%remove characters which cannot be used as a variable name in C.
name_str = regexprep(name_str, '[^a-zA-Z0-9_]', '');
end

