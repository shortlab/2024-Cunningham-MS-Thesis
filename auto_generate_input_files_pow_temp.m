clc; clear;

baseName = 'vitanza_UN_t_p_';
contents = fileread('vitanza_UN_base_3.i');


for i = 6500:2000:40000

    for j = 1215:20:1315

    fileName = [baseName, num2str(j), '_', num2str(i),'.i'];

    new_temp = regexprep(contents, {'    value = \d+'}, {sprintf('    value = %d', j)});
    fid = fopen(fileName, 'w');
    fwrite(fid, new_temp);
    fclose(fid);

    contents2 = fileread(fileName);

    new_power = regexprep(contents2, {'    y = ''0 \d+'''}, {sprintf('    y = ''0 %d''', i)});
    fid = fopen(fileName, 'w');
    fwrite(fid, new_power);
    fclose(fid);
    
   
    end

end

    