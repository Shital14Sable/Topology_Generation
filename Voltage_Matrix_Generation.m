clc
clear
%-------------------------------------------------------------------------%
load('Test') % Variable number for the test iteration
Test = Test + 1;
thruster_test = 'RIT_XT'; %Name of the thruster to test

Input_params = table2array(readtable(['Input_Data\Grid_parameter_' thruster_test '.xlsx'], 'Range','B1:B14')); %Input Parameters for the thruster 
Input_params(8,1) = 900;
Input_params(9,1) = -300;

folder_name = ['C:\Users\shita\Box\Simulation\OSU-DSPG\particleTest\Topology_Generation_Data\Test_Data\' thruster_test]; %Path to save the 
                                                                                                                         %generated data
Data_conversion(Input_params', Test) %This script converts the 

SG_data = round(table2array(readtable([folder_name '\Test' num2str(Test) '_Grid_points.xlsx'], 'Sheet', 1, 'Range','C1:G3'))); 
AG_data = round(table2array(readtable([folder_name '\Test' num2str(Test) '_Grid_points.xlsx'], 'Sheet', 2, 'Range','C1:G3')));

Nx = round(Input_params(10,1)*Input_params(12,1));     % Number of X-grids
Ny = round(Input_params(10,1)*Input_params(11,1));     % Number of Y-grids

Ni = 300;  % Number of iterations for voltage Generation
V_m = zeros(Nx,Ny);   % Potential (Voltage) matrix


%-------------------------------------------------------------------------%
% Initializing Shealth
%-------------------------------------------------------------------------%

pt1 = [SG_data(1,2),SG_data(1,3)+1];
pt2 = [SG_data(1,2),SG_data(2,1)-1];

[~, xn,yn] = CircleSegment(pt1,pt2);


%-------------------------------------------------------------------------%
% Initializing Particle Properties
%-------------------------------------------------------------------------%
tic

for itr = 1:300
    
    for i=2:Nx-1
        for j=2:Ny-1
%-------------------------------------------------------------------------%
                V_m(i,j)=0.25*(V_m(i+1,j)+V_m(i-1,j)+V_m(i,j+1)+V_m(i,j-1)); % approximates the potential over the space
%-------------------------------------------------------------------------%
            for r = 1:2
                V_m(SG_data(r,1):SG_data(r,3), SG_data(r,2):SG_data(r,4)) = SG_data(r,5); % defines the potential on screen grid
                V_m(AG_data(r,1):AG_data(r,3), AG_data(r,2):AG_data(r,4)) = AG_data(r,5); % defines the potential on accelerator grid
            end
            
            for w = 1:SG_data(1,3)
               V_m(w, 1:SG_data(1,2)) = SG_data(1,5)+30;
            end
            for w = SG_data(2,1):Nx
                V_m(w, 1:SG_data(1,2)) = SG_data(1,5)+30;
            end
                       
            for vr = 1:size(xn,2)
                V_m(yn(1,vr), 1:xn(1,vr)) = SG_data(1,5)+30;
            end
%-------------------------------------------------------------------------%
% Edges potentials calculations
%-------------------------------------------------------------------------%
                
                V_m(1,j) = (V_m(1,j-1) + V_m(2,j) + V_m(1,j+1))./3 ;
                V_m(Nx,j) = (V_m(Nx,j-1) + V_m(Nx-1,j) + V_m(Nx,j+1))./3;
                V_m(i,1) = (V_m(i-1,1) + V_m(i,2) + V_m(i+1,1))./3;
                V_m(i,Ny) = (V_m(i-1,Ny) + V_m(i, Ny-1) + V_m(i+1, Ny))./3;
                
%-------------------------------------------------------------------------%
%Corner potentials calculations
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

% A = gradient(V_m); % Gradient Matrix
% [Ex,Ey] = gradient(V_m); % Gradient in X and Y axis
% Ex = -Ex;
% Ey = -Ey;
% 
% 
% % Electric field Magnitude
% E = sqrt(Ex.^2+Ey.^2);
% 
% x = (1:Nx);
% y = (1:Ny);
% 
% % Contour Display for electric potential
% figure(1)
% contour_range_V = -300:0.5:1500;
% contour(x,y,V_m,contour_range_V,'linewidth',0.5);
% axis([min(x) max(x) min(y) max(y)]);
% colorbar('location','eastoutside','fontsize',14);
% xlabel('x-axis in mesh nodes','fontsize',14);
% ylabel('y-axis in mesh nodes','fontsize',14);
% title('Electric Potential distribution, V(x,y) in volts','fontsize',14);
% h1=gca;
% set(h1,'fontsize',14);
% fh1 = figure(1); 
% set(fh1, 'color', 'white')
