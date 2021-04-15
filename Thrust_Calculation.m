% Thrust Calculation
%function Thrust = Thrust_Calculation(Ib, Vb)
% 
clc
clear all
% load('Test') %Variable number for the test iteration'
Test = 10;
thruster_test = 'RIT_XT';
folder_name = ['C:\Users\shita\Box\Simulation\OSU-DSPG\particleTest\Topology_Generation_Data\Test_Data\' thruster_test];
% m_dot = 1.231845e-9; %kg/s RIT10
% m_dot = 1.231845e-9; %kg/s RITEvo
m_dot = 1.4744e-10; %RIT_XT
SG_data = round(table2array(readtable([folder_name '\Test' num2str(Test) '_Grid_points.xlsx'], 'Sheet', 1, 'Range','C1:G3'))); 
AG_data = round(table2array(readtable([folder_name '\Test' num2str(Test) '_Grid_points.xlsx'], 'Sheet', 2, 'Range','C1:G3')));
pt1 = [SG_data(1,2),SG_data(1,3)+1];
pt2 = [SG_data(1,2),SG_data(2,1)-1];

[h,xn,yn] = CircleSegment(pt1,pt2);
size_mat = size(yn, 2);
thrust_index = AG_data(1,4);


Vb = csvread([folder_name '\Test' num2str(Test) 'Vx.csv']);
T_s = csvread([folder_name '\Test' num2str(Test) 'TimeStep.csv']);
NPos_x = csvread([folder_name '\Test' num2str(Test) 'NPos_x.csv']);  % writes the generated Trajectory matrix to a given name
% NPos_x = reshape(NPos_x,[size(NPos_x,1)/size_mat, size_mat])';
% Vb = (reshape(Vb,[size(Vb,1)/size_mat, size_mat]))';
% T_s = (reshape(T_s,[size(T_s,1)/size_mat, size_mat]))';
sum_t = sum(T_s,2);
Vb_sum = 0;
itr = 0;
for i = 1:size(Vb)
    row_vb = Vb(i,:);
    Vb_cell = row_vb(row_vb~=0);
    
    result = find(NPos_x(i,:)>thrust_index);% & NPos_x(i,:)<(thrust_index+1));
    if isempty(result)
        continue
        % thr = thr + (100 * Vb_cell(1,result) * 2.1801714e-25 * max(sum_t));
    else
        itr = itr + 1 ;
        result = result(1,1);
        Vb_sum(1,itr) = Vb_cell(1,result);
    end
end

vel_avg = sum(Vb_sum) ./  size(Vb_sum, 2);

thrust_total = vel_avg * m_dot; %total Thrust per aperture
save([folder_name '\Test' num2str(Test) '_Thrust'], "thrust_total")
save([folder_name '\Test' num2str(Test) '_avg_exit_velocity'], "vel_avg")