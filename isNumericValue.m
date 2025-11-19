function result = isNumericValue(valueStr)
% This function is edited by Qwen3-Max.
    % 判断字符串是否表示数值
    result = false;
    
    % 去除注释和多余的空白
    valueStr = strtrim(valueStr);
    
    % 检查是否为数字、浮点数或带运算符的简单表达式
    % 这里只检查简单的数值形式
    if ~isempty(valueStr) && ~contains(valueStr, '(') && ~contains(valueStr, ')') && ...
       ~contains(valueStr, '{') && ~contains(valueStr, '}') && ...
       ~contains(valueStr, '[') && ~contains(valueStr, ']') && ...
       ~contains(valueStr, 'if') && ~contains(valueStr, 'else') && ...
       ~contains(valueStr, 'for') && ~contains(valueStr, 'while')
        
        % 尝试转换为数字
        try
            % 处理简单的数值表达式
            testStr = valueStr;
            % 替换常见的宏或常量（可根据需要扩展）
            testStr = regexprep(testStr, '\s+', ''); % 移除空格
            
            % 检查是否为纯数字或包含基本运算符的表达式
            if regexp(testStr, '^[0-9+\-*/.eE]+$') % 简单的数字表达式
                result = true;
            elseif str2double(testStr) == str2double(testStr) % 可以转换为数字
                result = true;
            else
                % 检查是否为十六进制、八进制等格式
                if startsWith(testStr, '0x') || startsWith(testStr, '0X')
                    try
                        str2double(testStr);
                        result = true;
                    catch
                        result = false;
                    end
                elseif startsWith(testStr, '0') && length(testStr) > 1
                    try
                        str2double(testStr);
                        result = true;
                    catch
                        result = false;
                    end
                end
            end
        catch
            result = false;
        end
    end
end