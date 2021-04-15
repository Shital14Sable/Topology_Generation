%function Primary_Trajectory_Generation
clc
clear all
%-------------------------------------------------------------------------%
%                         INITIALIZATION    
%-------------------------------------------------------------------------%
% E = Total electric field matrix using Poisson's equation
% V = Potential matrix
% Nx = Number of grid points in X- direction
% Ny = Number of grid points in Y-Direction
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
%                           LOADING THE INPUT FILES
%-------------------------------------------------------------------------%
load('Test') %Variable number for the test iteration
disp(Test)
apts = 5;
grids = 3;
% date_yes = char(datetime(2020,10,09));
thruster_test = 'RIT_XT';
folder_name = ['C:\Users\shita\Box\Simulation\OSU-DSPG\particleTest\Topology_Generation_Data\Test_Data\' thruster_test];
% Azara's Local Directory for Simulation
% folder_name = ['C:\Users\azara\Box Sync\Ion Thruster Research\Clone\' thruster_test];
%-------------------------------------------------------------------------%
qi = 100;
e_charge = 1.602e-19;
eps = 8.854e-12;
m_Xe = 2.1801714e-25; %kg
f_bohm = 1;
% v_bohm = f_bohm * sqrt(100* 1.60217662e-19 *3/(100 * 2.18017e-25));
v_bohm = 0;

%%
for k = 1:grids
    Grid{k} = round(table2array(readtable([folder_name '\Test' num2str(Test) 'Gridvals.xls'], 'Sheet', k)));
end


%%
V = csvread([folder_name '\Test' num2str(Test) '_VtgDistMat.csv']);
SG_data = round(table2array(readtable([folder_name '\Test' num2str(Test) 'Gridvals.xls'], 'Sheet', 1)));
Node_factor = 1e-3 / 50;

Nx = size(V,1);
Ny  = size(V,2);
Ex = zeros(Nx,Ny);
Ey = zeros(Nx,Ny);

for i = 3:Nx-2
    for j = 3:Ny-2
    Ex(i,j) = -(-V(i, j+2) + 8*V(i,j+1) - 8*V(i,j-1) + V(i,j-2))/(12*Node_factor);
    Ey(i,j) = -(-V(i+2, j) + 8*V(i+1,j) - 8*V(i-1,j) + V(i-2,j))/(12*Node_factor);
    end
end

% Electric field Magnitude
E = sqrt(Ex.^2+Ey.^2);
 
x = (1:Ny);
y = (1:Nx);

Nj = 6000;
%-------------------------------------------------------------------------%
%                       Positon Simulation
%-------------------------------------------------------------------------%
% xn = SG_data(1,2); % Initial X position
% yn = SG_data(1,3)+1 : SG_data(2,1)-1; % Initial Y position


for i = 1:apts
    pt1 = [Grid{1}(i,2),Grid{1}(i,3)+1];
    pt2 = [Grid{1}(i,2),Grid{1}(i+1,1)-1];
    [~, xn(i,:),yn(i,:)] = CircleSegment(pt1,pt2);
end
% xn = 35;
% yn = 110;
no_partcls = apts * size(yn, 2);

NPos_x = zeros(no_partcls ,Nj); % X position matrix to multiple trajectories
NPos_y = zeros(no_partcls ,Nj); % Y position matrix to multiple trajectories
time_step = zeros(no_partcls ,Nj);
Vx_in= v_bohm;
Vy_in = 0;
Vx_new = zeros(no_partcls ,Nj);
Vy_new = zeros(no_partcls ,Nj);



part_no = 1;  %particle number
for g = 1:apts
    for itr = 1:size(yn, 2)
        [NPos_x(part_no,:), NPos_y(part_no ,:), Vx_new(part_no, :), Vy_new(part_no, :),  time_step(part_no,:)] = Path_Calculation(xn(g,itr), yn(g,itr), Ex, Ey, Vx_in, Vy_in, Nj);
    part_no = part_no + 1;
    end
end
% p_dim = size(NPos_x, 1);
% pos_cellX = {};
% pos_cellY = {};

% for s = 1:p_dim
%     [pos_cellX{s}, pos_cellY{s}] = Post_process(NPos_x(s,:), NPos_y(s,:));
% end

%-------------------------------------------------------------------------%
%                        SAVING THE TRAJECTORIES
%-------------------------------------------------------------------------%


if isfolder(folder_name)
    writematrix(Ex, [folder_name '\Test' num2str(Test) 'Ex.csv'])
    writematrix(Ey, [folder_name '\Test' num2str(Test) 'Ey.csv'])
    writematrix(NPos_x, [folder_name '\Test' num2str(Test) 'NPos_x.csv'])  % writes the generated Trajectory matrix to a given name
    writematrix(NPos_y, [folder_name '\Test' num2str(Test) 'NPos_y.csv'])  % writes the generated Trajectory matrix to a given name
    writematrix(time_step, [folder_name '\Test' num2str(Test) 'TimeStep.csv'])  % writes the generated Time Step matrix to a given name
    writematrix(Vx_new, [folder_name '\Test' num2str(Test) 'Vx.csv'])  % writes the generated Velocity matrix to a given name
else
    mkdir(fullfile(folder_name))
    writematrix(Ex, [folder_name '\Test' num2str(Test) 'Ex.csv'])
    writematrix(Ey, [folder_name '\Test' num2str(Test) 'Ey.csv'])
    writematrix(NPos_x, [folder_name '\Test' num2str(Test) 'NPos_x.csv']) % writes the generated Trajectory matrix to a given name
    writematrix(NPos_y, [folder_name '\Test' num2str(Test) 'NPos_y.csv'])  % writes the generated Trajectory matrix to a given name
    writematrix(time_step, [folder_name '\Test' num2str(Test) 'TimeStep.csv'])  % writes the generated Time Step matrix to a given name
    writematrix(Vx_new, [folder_name '\Test' num2str(Test) 'Vx.csv'])  % writes the generated Velocity matrix to a given name
end



