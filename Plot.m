clc 
clear


load('Test') %Variable number for the test iteration'

Test = 10;
thruster_test = 'RIT_XT';
folder_name = ['C:\Users\shita\Box\Simulation\OSU-DSPG\particleTest\Topology_Generation_Data\Test_Data\' thruster_test]; %change the location according to where you are running the test
% SG_data = round(table2array(readtable([folder_name '\Test' num2str(Test) '_Grid_points.xlsx'], 'Sheet', 1, 'Range','C1:G3'))); 
% pt1 = [SG_data(1,2),SG_data(1,3)+1];
% pt2 = [SG_data(1,2),SG_data(2,1)-1];
% 
% [h,xn,yn] = CircleSegment(pt1,pt2);
% size_mat = size(yn, 2);


V = csvread([folder_name '\Test' num2str(Test) '_VtgDistMat.csv']);
NPos_x = csvread([folder_name '\Test' num2str(Test) 'NPos_x.csv']);  
% NPos_x = reshape(NPos_x,[size(NPos_x,1)/size_mat, size_mat])'; 
NPos_y = csvread([folder_name '\Test' num2str(Test) 'NPos_y.csv']);
% NPos_y = reshape(NPos_y,[size(NPos_y,1)/size_mat, size_mat])';

% size1 = 6*10e-3/size(V, 1); % this variable is needed for interpolation, it is the grid size (e.g. 0.1 m)

Nx = size(V,1);
Ny  = size(V,2);
Ex = csvread([folder_name '\Test' num2str(Test) 'Ex.csv']);
Ey = csvread([folder_name '\Test' num2str(Test) 'Ey.csv']);


p_dim = size(NPos_x, 1);
pos_cellX = {};
pos_cellY = {};

for s = 1:p_dim
    [pos_cellX{s}, pos_cellY{s}] = Post_process(NPos_x(s,:), NPos_y(s,:));
end

% Electric field Magnitude

E = sqrt(Ex.^2+Ey.^2);
 
x = (1:Ny);
y = (1:Nx);

% Quiver Display for electric field Lines
figure(1)
contour(x,y,E,'linewidth',0.5);
hold on, quiver(x,y,Ex,Ey,2)
title('Electric field Lines, E (x,y) in V/m','fontsize',14);
axis([min(x) max(x) min(y) max(y)]);
colorbar('location','eastoutside','fontsize',14);
xlabel('x-axis in meters','fontsize',14);
ylabel('y-axis in meters','fontsize',14);
h3=gca;
set(h3,'fontsize',14);


