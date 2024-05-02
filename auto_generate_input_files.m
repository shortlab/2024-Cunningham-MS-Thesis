clc; clear;

baseName = 'vitanza_UN_p_';
contents = fileread('vitanza_UN_base_3.i');


for i = 6500:1000:40000

    fileName = [baseName, num2str(i),'.i'];
    newcontents = regexprep(contents, {'    y = ''\d+ \d+'''}, {sprintf('    y = ''0 %d''', i)});
    fid = fopen(fileName, 'w');
    fwrite(fid, newcontents);
    fclose(fid);

end

