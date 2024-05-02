clc; clear;

time = [];
power = [];
burnup = [];
fclt = [];
for i = 6500:1000:40000

    filename = sprintf('vitanza_UN_p_%d_csv.csv',i);
    if exist(filename, 'file') == 0
       continue;
    end
    data = readmatrix(filename);
    time(i) = data(1,1);
    power(i) = i/1000;
    burnup(i) = data(1,4);
    fclt(i) = data(1,12); 
    thermal_cond(i) = data(1,20);

   
end

time_out = reshape(time, [], 1);
power_out = reshape(power, [], 1);
burnup_out = reshape(burnup, [], 1);
fclt_out = reshape(fclt, [], 1);
thermal_cond_out = reshape(fclt, [], 1);

%disp(time);
%disp(power_out);
% disp(burnup);
% disp(fclt);

output = [time_out power_out burnup_out fclt_out thermal_cond_out];

L=1;
for j=1:length(output) 
    if output(j,1)~=0 || output(j,2)~=0 || output(j,3)~=0
        final_output(L,:)=output(j,:);
        L=L+1;
    end
end

writematrix(final_output, 'processed_output.csv')
