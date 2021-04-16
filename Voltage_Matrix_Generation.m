function [V_m, Grid] = Voltage_Matrix_Generation(folder_name, thrstr_data, sim_data)

%%Setting up the workspace for simulation
thruster_test = thrstr_data.Name; %Name of the thruster to test
folder_name = [folder_name thruster_test];

%% Set up grid Data
apts = thrstr_data.Apt_nos;
grids = thrstr_data.Grid_nos;
voltage = thrstr_data.Voltage;
gridThick = thrstr_data.GridThick; %mm
AptDiam = thrstr_data.AptDiam; %mm
Gap = thrstr_data.Gap; %mm

%% Set up simulation data
res = sim_data.res; % How much 1 mm is converted into. 
Test = sim_data.Test_no;
lengthX = sim_data.lengthX;
lengthY = sim_data.lengthY;
Nx = lengthX *res;
Ny = lengthY *res;
Ni = sim_data.Itr_no; % Number of iterations for voltage Generation

%% Get grid points
Grid = Grid_pnt_Calc(apts,grids,gridThick,AptDiam,Gap,lengthX,lengthY,res, voltage, folder_name, Test);

%%
% for k = 1:grids
%     Grid{k} = round(table2array(readtable([folder_name '\Test' num2str(Test) 'Gridvals.xls'], 'Sheet', k)));
% end

%% Defining Potential (Voltage) matrix
V_m = zeros(Nx,Ny);


%-------------------------------------------------------------------------%
% Initializing Shealth
%-------------------------------------------------------------------------%

for i = 1:apts
    pt1 = [Grid{1}(i,2),Grid{1}(i,3)+1];
    pt2 = [Grid{1}(i,2),Grid{1}(i+1,1)-1];
    [~, xn(i,:),yn(i,:)] = CircleSegment(pt1,pt2);
end

%-------------------------------------------------------------------------%
% Initializing Particle Properties
%-------------------------------------------------------------------------%
tic

for itr = 1:Ni
    
    for i=2:Nx-1
        for j=2:Ny-1
%-------------------------------------------------------------------------%
                V_m(i,j)=0.25*(V_m(i+1,j)+V_m(i-1,j)+V_m(i,j+1)+V_m(i,j-1)); % approximates the potential over the space
%-------------------------------------------------------------------------%
            for r = 1:grids
                for s = 1:apts+1
                V_m(Grid{r}(s,1):Grid{r}(s,3), Grid{r}(s,2):Grid{r}(s,4)) = Grid{r}(s,5); % defines the potential on the grid
                end
            end
            
            for p = 1:apts+1
                for w = 1:Grid{1}(1,3)
                    V_m(Grid{1}(p,1):Grid{1}(p,3), 1:Grid{1}(1,2)) = Grid{1}(1,5)+30; %Defines the potential behind the Grid
                end
            end
             

            for h = 1:size(xn,1)
                for vr = 1:size(xn,2)
                    V_m(yn(h,vr), 1:xn(h,vr)) = Grid{1}(1,5)+30;  %Defines the potential 
                end
            end
%-------------------------------------------------------------------------%
% Edges potentials calculations, simulation space
%-------------------------------------------------------------------------%
                
                V_m(1,j) = (V_m(1,j-1) + V_m(2,j) + V_m(1,j+1))./3 ;
                V_m(Nx,j) = (V_m(Nx,j-1) + V_m(Nx-1,j) + V_m(Nx,j+1))./3;
                V_m(i,1) = (V_m(i-1,1) + V_m(i,2) + V_m(i+1,1))./3;
                V_m(i,Ny) = (V_m(i-1,Ny) + V_m(i, Ny-1) + V_m(i+1, Ny))./3;
                
%-------------------------------------------------------------------------%
%Corner potentials calculations, simulation space
%-------------------------------------------------------------------------%
                
                V_m(1,1) = 0.5*(V_m(1,2)+V_m(2,1));
                V_m(Nx,1) = 0.5*(V_m(Nx-1,1)+V_m(Nx,2));
                V_m(1,Ny) = 0.5*(V_m(1,Ny-1)+V_m(2,Ny));
                V_m(Nx,Ny) = 0.5*(V_m(Nx,Ny-1)+V_m(Nx-1,Ny));
                
%-------------------------------------------------------------------------%
 
        end
    end
end
toc

if isfolder(folder_name)
    writematrix(V_m, [folder_name '\Test' num2str(Test) '_VtgDistMat.csv'])  % writes the generated voltage matrix to a given name
else
    mkdir(fullfile(folder_name))
    writematrix(V_m, [folder_name '\Test' num2str(Test) '_VtgDistMat.csv']) % writes the generated voltage matrix to a given name
end

% Test = Test +1;
save('Test', "Test")

