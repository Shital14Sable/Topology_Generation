function [thrust_total] = Optimization_run(thruster_test)
%This code will optimize the specs for the grid
%% Folder name:
sim_data = SimulationData;
thrstr_data = access_data(thruster_test);
folder_name = ['C:\Users\shita\Box\Simulation\OSU-DSPG\particleTest\Topology_Generation_Data\Test_Data\' thruster_test];



%% Make sure code is starting
t = now;
d = datetime(t,'ConvertFrom','datenum');
writematrix(d,'ITSTARTED!')

%% Voltage Matrix Generation
[V, Grid] = Voltage_Matrix_Generation(folder_name, thrstr_data, sim_data);

%% Primary Matrix Generation
%Outputs position, velocity + time step
[NPos_x, ~, time_step, Vx]  = Primary_Trajectory_Generation(V, sim_data, thrstr_data, folder_name, Grid);

%% Thrust Calculation
[thrust_total] = Thrust_Calculation(Vx, time_step, NPos_x, thrstr_data, folder_name, Grid);

%% Make sure the code finished
t = now;
d = datetime(t,'ConvertFrom','datenum');
writematrix(d,'ITWORKED!')

