%For testing 
clear
clc
clf

% % Circle Segment Test
% %Round the values 
% pt1 = [5,3];
% pt2 = [5,60];
% 
% [h,x3,y3] = CircleSegment(pt1,pt2);


% Grid test
%% Grid Calcs Test
apts = 4;
grids = 4;
voltage = [5,10,20,30];
gridThick = [0.3,0.2,0.1,0.3]; %mm
% All grids should have a different diameter
% Have an output that contains table of vals that says how to change the
% values for efficiency in the next simulation
% Next sim should use new vals
AptDiam = [0.2,0.3,0.1,0.2]; %mm
Gap = 0.5; %mm
lengthX = 5;
lengthY = 5;
res = 100; % How much 1 mm is converted into. 

[x,y] = GridCalcs2(apts,grids,gridThick,AptDiam,Gap,lengthX,lengthY,res, voltage);

%% 
% Aperture diameter should be variable too

%% Can I change (0,0) to be the top left?
% can I plot
% Upload to github