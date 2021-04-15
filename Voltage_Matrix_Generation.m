clc
clear
%-------------------------------------------------------------------------%
load('Test') % Variable number for the test iteration
Test = Test + 1;
thruster_test = 'RIT_XT'; %Name of the thruster to test

folder_name = ['C:\Users\shita\Box\Simulation\OSU-DSPG\particleTest\Topology_Generation_Data\Test_Data\' thruster_test]; %Path to save the 
                                                                                                                         %generated data
                                                                                                                         
%% Grid Calcs Test
apts = 5;
grids = 3;
voltage = [5,10,20];
gridThick = [0.6,0.2,0.1]; %mm
% All grids should have a different diameter
% Have an output that contains table of vals that says how to change the
% values for efficiency in the next simulation
% Next sim should use new vals
AptDiam = [0.2,0.3,0.1]; %mm
Gap = [0.8, 0.6, 0.3]; %mm
lengthX = 5;
lengthY = 5;
res = 50; % How much 1 mm is converted into. 

[~,~] = GridCalcs2(apts,grids,gridThick,AptDiam,Gap,lengthX,lengthY,res, voltage, folder_name, Test);


%%
for k = 1:grids
    Grid{k} = round(table2array(readtable([folder_name '\Test' num2str(Test) 'Gridvals.xls'], 'Sheet', k)));
end

%Nx = round(Input_params(10,1)*Input_params(12,1));     % Number of X-grids
% Ny = round(Input_params(10,1)*Input_params(11,1));     % Number of Y-grids

Nx = lengthX*res;
Ny = lengthY*res;
Ni = 300;  % Number of iterations for voltage Generation
V_m = zeros(Nx,Ny);   % Potential (Voltage) matrix


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

for itr = 1:30
    
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

