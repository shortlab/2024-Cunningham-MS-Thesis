clc; clear;

time = [];
power = [];
burnup = [];
fclt = [];


for i = 6500:2000:40000

    for j = 1215:20:1315

    filename = sprintf('vitanza_UN_t_p_%d_%d_csv.csv',j,i);
    if exist(filename, 'file') == 0
       continue;
    end
    data = readmatrix(filename);
    time(i,j) = data(1,1);
    power(i,j) = i;
    burnup(i,j) = data(1,4);
    fclt(i,j) = data(1,11); 

    end

   
end
    time_out = reshape(time, [], 1);
    power_out = reshape(power, [], 1);
    burnup_out = reshape(burnup, [], 1);
    fclt_out = reshape(fclt, [], 1);
    
    %disp(time);
    %disp(power_out);
    % disp(burnup);
    % disp(fclt);
    
    output = [time_out power_out burnup_out fclt_out];
    
    L=1;
    for j=1:length(output) 
        if output(j,1)~=0 || output(j,2)~=0 || output(j,3)~=0
            final_output(L,:)=output(j,:);
            L=L+1;
        end
    end
    
    writematrix(final_output, 'processed_output.csv')
