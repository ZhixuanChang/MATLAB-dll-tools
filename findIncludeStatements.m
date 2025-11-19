function includedFiles = findIncludeStatements(filePath)
% This function is edited by Qwen3-Max.
    % 从头文件中提取所有include语句
    try
        fileContent = readlines(filePath);
        % 查找#include语句
        includeLines = fileContent(contains(fileContent, '#include'));
        
        includedFiles = {};
        for j = 1:length(includeLines)
            % 提取文件名（处理 #include <file.h> 和 #include "file.h"）
            pattern1 = '#include\s+<([^>]+)>';
            pattern2 = '#include\s+"([^"]+)"';
            
            matches1 = regexp(includeLines{j}, pattern1, 'tokens');
            matches2 = regexp(includeLines{j}, pattern2, 'tokens');
            
            if ~isempty(matches1)
                includedFiles{end+1} = matches1{1}{1};
            elseif ~isempty(matches2)
                includedFiles{end+1} = matches2{1}{1};
            end
        end
        includedFiles = unique(includedFiles); % 去重
    catch
        includedFiles = {};
    end
end