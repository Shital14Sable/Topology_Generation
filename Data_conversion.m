function Data_conversion(Ip, thruster_test)
% clc
% clear all
load('Test'); %Variable number for the test iteration
folder_name = ['C:\Users\sables\Box\Simulation\OSU-DSPG\particleTest\Topology_Generation_Data\Test_Data\' thruster_test ];
S(1,1) = 1; %Row X1
S(1,2) = (Ip(1,10)*Ip(1,13))+1;
S(1,3) = Ip(1,10)*((Ip(1,11)-Ip(1,5))/2);
S(1,4) = Ip(1,10)*(Ip(1,13)+Ip(1,3));
S(1,5) = Ip(1,8);
S(2,1) = S(1,3) + (Ip(1,10)*Ip(1,5))+1;
S(2,2) = S(1,2);
S(2,3) = Ip(1,10)*Ip(1,12);
S(2,4) = S(1,4);
S(2,5) = Ip(1,8);
A(1,1) = 1;
A(1,2) = Ip(1,10)*(Ip(1,13)+Ip(1,3)+Ip(1,7))+1;
A(1,3) = Ip(1,10)*((Ip(1,11)-Ip(1,6))/2);
A(1,4) = Ip(1,10)*(Ip(1,13)+Ip(1,3)+Ip(1,4) +Ip(1,7));
A(1,5) = Ip(1,9);
A(2,1) = A(1,3) + (Ip(1,10)* Ip(1,6))+1;
A(2,2) = A(1,2);
A(2,3) = Ip(1,10)*Ip(1,12);
A(2,4) = A(1,4);
A(2,5) = Ip(1,9);

if isfolder(folder_name)
    writematrix( S, [folder_name '\Test' num2str(Test) '_Grid_points.xlsx'],'Sheet',1,'Range','C2:G4');
    writematrix( A, [folder_name '\Test' num2str(Test) '_Grid_points.xlsx'],'Sheet',2,'Range','C2:G4');
else
    mkdir(fullfile(folder_name))
    writematrix( S, [folder_name '\Test' num2str(Test) '_Grid_points.xlsx'],'Sheet',1,'Range','C2:G4');
    writematrix( A, [folder_name '\Test' num2str(Test) '_Grid_points.xlsx'],'Sheet',2,'Range','C2:G4');
end




