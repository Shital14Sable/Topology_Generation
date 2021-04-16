function [NPos_x, NPos_y, time_step, Vx] = Primary_Trajectory_Generation(V, sim_data, thrstr_data, folder_name, Grid)

%% INITIALIZATION    
% E = Total electric field matrix using Poisson's equation
% V = Potential matrix
% Nx = Number of grid points in X- direction
% Ny = Number of grid points in Y-Direction
%-------------------------------------------------------------------------%

%% LOADING THE INPUT FILES: Simulation Data
res = sim_data.res; % How much 1 mm is converted into. 
Test = sim_data.Test_no;
%Variable number for the test iteration

%%                          LOADING THE INPUT FILES: Thruster Data
apts = thrstr_data.Apt_nos;

%% 
% for k = 1:grids
%     Grid{k} = round(table2array(readtable([folder_name '\Test' num2str(Test) 'Gridvals.xls'], 'Sheet', k)));
% end

%%                      Calculating the Electric Potential Values
% V = csvread([folder_name '\Test' num2str(Test) '_VtgDistMat.csv']);
Node_factor = 1e-3 / res;
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

%%                       Electric field Magnitude
% E = sqrt(Ex.^2+Ey.^2);
%  
% x = (1:Ny);
% y = (1:Nx);

%%                      Setting up the Initial Position of the particle

for i = 1:apts
    pt1 = [Grid{1}(i,2),Grid{1}(i,3)+1];
    pt2 = [Grid{1}(i,2),Grid{1}(i+1,1)-1];
    [~, xn(i,:),yn(i,:)] = CircleSegment(pt1,pt2);
end

no_partcls = apts * size(yn, 2);


%%                      Setting up Simulation Matrices
NPos_x = zeros(no_partcls ,Nj); % X position matrix to multiple trajectories
NPos_y = zeros(no_partcls ,Nj); % Y position matrix to multiple trajectories
time_step = zeros(no_partcls ,Nj);
Vx_new = zeros(no_partcls ,Nj);
Vy_new = zeros(no_partcls ,Nj);



part_no = 1;  %particle number
for g = 1:apts
    for itr = 1:size(yn, 2)
        [NPos_x(part_no,:), NPos_y(part_no ,:), Vx_new(part_no, :), Vy_new(part_no, :),  time_step(part_no,:)] = Path_Calculation(xn(g,itr), yn(g,itr), Ex, Ey, Nj);
    part_no = part_no + 1;
    end
end

%%                        SAVING THE TRAJECTORIES
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



