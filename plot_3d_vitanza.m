clc; clear;

vitanza_reproduced = readmatrix('processed_output.csv');

disp(vitanza_reproduced);

z = vitanza_reproduced(:,2);
x = vitanza_reproduced(:,3);
y = vitanza_reproduced(:,4);

% z = normalize(z);
% x = normalize(x);
% y = normalize(y);

xlin = linspace(min(x), max(x), 100);
ylin = linspace(min(y), max(y), 100);
[X,Y] = meshgrid(xlin, ylin);
% Z = griddata(x,y,z,X,Y,'natural');
% Z = griddata(x,y,z,X,Y,'cubic');
Z = griddata(x,y,z,X,Y,'v4');
mesh(X,Y,Z)
axis tight; hold on
plot3(x,y,z,'.','MarkerSize',15)
set(gca,'FontName', 'Times New Roman')
%surf(X,Y,Z, 'LineStyle', 'none', 'FaceColor', 'interp')
xlabel("Burnup [%FIMA]")
ylabel("Temperature [K]")
zlabel("Linear Heat Rate [kW/m]")



