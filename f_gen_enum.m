function f_gen_enum(s_path, d_path)
% This function will recursively scan the specified path and generate MATLAB enumeration class definition for each enum
% type in C/C++ head files.

file_list = dir(fullfile(s_path, '**', '*.h'));

if isempty(file_list)
    fprintf('There is no header files in the specified path.\n');
    return;
end

for i = 1: length(file_list)
    file = file_list(i);
    file_fullpath = [file.folder, filesep, file.name];
    data_str = fileread(file_fullpath);

    str_residual = data_str;
    while contains(str_residual, 'enum')
        tmp = strsplit(str_residual, 'enum');
        tmp = strsplit(tmp{2}, ';');
        str_residual = tmp{2};
        tmp = strsplit(tmp{1}, '{');
        tmp = strsplit(tmp{2}, '}');
        enum_name = regexprep(tmp{2}, '[^a-zA-Z0-9_]', '');
        member_list = strsplit(tmp{1}, ',');
        member_list_str = '';
        for j = 1 : length(member_list)
            if contains(member_list{j}, '=')
                tmp = strsplit(member_list{j}, '=');
                member_name = regexprep(tmp{1}, '[^a-zA-Z0-9_]', '');
                member_value = int32(str2double(tmp{2}));
            else
                member_name = regexprep(member_list{j}, '[^a-zA-Z0-9_]', '');
                if j == 1
                    member_value = 0;
                else
                    member_value = member_value_last + 1;
                end
            end
            member_value_last = member_value;
            member_list_str = [member_list_str, sprintf('        %s (%d)\n', member_name, member_value)];
        end

        file_contents = [sprintf('classdef %s\n', enum_name), ...
            sprintf('    properties\n'), ...
            sprintf('        value int32\n'), ...
            sprintf('    end\n'), ...
            sprintf('\n'), ...
            sprintf('    methods\n'), ...
            sprintf('        function obj = %s(val)\n', enum_name), ...
            sprintf('            obj.value = val;\n'), ...
            sprintf('        end\n'), ...
            sprintf('    end\n'), ...
            sprintf('\n'), ...
            sprintf('    enumeration\n'), ...
            member_list_str, ...
            sprintf('    end\n'), ...
            sprintf('end\n')];
        fid = fopen([d_path, filesep, enum_name, '.m'], 'w');
        fprintf(fid, '%s', file_contents);
        fclose(fid);
    end
    return
end

end
