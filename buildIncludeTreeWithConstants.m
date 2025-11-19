function fileTree = buildIncludeTreeWithConstants(folderPath)
% This function is edited by Qwen3-Max.
    % folderPath = 'your_folder_path_here'; % 替换为实际路径
    headerFiles = dir(fullfile(folderPath, '*.h'));
    
    % 存储每个头文件的包含关系和常量定义
    fileTree = struct('filename', {}, 'includedFiles', {}, 'constants', {});
    
    for i = 1:length(headerFiles)
        filePath = fullfile(folderPath, headerFiles(i).name);
        includedFiles = findIncludeStatements(filePath);
        constants = findConstants(filePath);
        
        fileTree(i).filename = headerFiles(i).name;
        fileTree(i).includedFiles = includedFiles;
        fileTree(i).constants = constants;
    end
    
    % 显示结果
    % for i = 1:length(fileTree)
    %     fprintf('File: %s\n', fileTree(i).filename);
    %     fprintf('  Includes: %s\n', strjoin(fileTree(i).includedFiles, ', '));
    %     if ~isempty(fileTree(i).constants)
    %         fprintf('  Constants:\n');
    %         for j = 1:length(fileTree(i).constants)
    %             fprintf('    %s = %s (Type: %s)\n', ...
    %                 fileTree(i).constants(j).name, ...
    %                 fileTree(i).constants(j).value, ...
    %                 fileTree(i).constants(j).type);
    %         end
    %     else
    %         fprintf('  No constants found\n');
    %     end
    %     fprintf('\n');
    % end
end