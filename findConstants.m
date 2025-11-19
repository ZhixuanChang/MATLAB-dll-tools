function constants = findConstants(filePath)
% Find all constants in a file.
%
% This function is edited by Qwen3-Max.
    % 查找文件中的常量定义
    constants = struct('name', {}, 'value', {}, 'type', {});
    
    try
        fileContent = readlines(filePath);
        
        % 查找 #define 宏定义（整型和浮点型）
        defineLines = fileContent(contains(fileContent, '#define') & ...
                                 ~contains(fileContent, '/*') & ...
                                 ~contains(fileContent, '*/') & ...
                                 ~contains(fileContent, '//'));
        
        for i = 1:length(defineLines)
            defineMatch = regexp(defineLines{i}, ...
                '#define\s+([A-Za-z_][A-Za-z0-9_]*)\s+([^/\s].*)', 'tokens');
            
            if ~isempty(defineMatch)
                macroName = defineMatch{1}{1};
                macroValue = strtrim(defineMatch{1}{2});
                
                % 检查宏值是否为数值类型（整型或浮点型）
                if isNumericValue(macroValue)
                    constants(end+1) = struct('name', macroName, ...
                                            'value', macroValue, ...
                                            'type', 'define');
                end
            end
        end
        
        % 查找 constexpr 定义
        constexprLines = fileContent(contains(fileContent, 'constexpr'));
        for i = 1:length(constexprLines)
            % 匹配 constexpr int/float/double var = value;
            constexprPattern = 'constexpr\s+(int|float|double|bool)\s+([A-Za-z_][A-Za-z0-9_]*)\s*=\s*([^;]+);';
            constexprMatch = regexp(constexprLines{i}, constexprPattern, 'tokens');
            
            if ~isempty(constexprMatch)
                varName = constexprMatch{1}{2};
                varValue = strtrim(constexprMatch{1}{3});
                
                constants(end+1) = struct('name', varName, ...
                                        'value', varValue, ...
                                        'type', 'constexpr');
            end
        end
        
    catch
        constants = struct('name', {}, 'value', {}, 'type', {});
    end
end