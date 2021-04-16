function thrust =  Thrust_Calculation(Vx, Ts, NPos_x, thrstr_data, folder_name, Grid)
%function Thrust = Thrust_Calculation(Ib, Vb)
% 

apts = thrstr_data.Apts;
grids = thrstr_data.Grids;
%%
% for k = 1:grids
%     Grid{k} = round(table2array(readtable([folder_name '\Test' num2str(Test) 'Gridvals.xls'], 'Sheet', k)));
% end

%%
for i = 1:apts
    pt1 = [Grid{1}(i,2),Grid{1}(i,3)+1];
    pt2 = [Grid{1}(i,2),Grid{1}(i+1,1)-1];
    [~, xn(i,:),yn(i,:)] = CircleSegment(pt1,pt2);
end

thrust_index = Grid{end}(1,4);
sum_t = sum(T_s,2);
Vb_sum = 0;
itr = 0;
for i = 1:size(Vb)
    row_vb = Vb(i,:);
    Vb_cell = row_vb(row_vb~=0);
    
    result = find(NPos_x(i,:)>thrust_index);
    if isempty(result)
        continue
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