function res_data = range_check(input_param)
    check_grid = {};
    check_grid{1,1} = 'no_of_grids_check';
    check_grid{1,2} = input_param(1,1) > 0;

    check_grid{2,1} = 'no_of_apr_check';
    check_grid{2,2} = input_param(2,1) > 0;

    check_grid{3,1} = 'SG_thickness_check';
    check_grid{3,2} = input_param(3,1) > 0;

    check_grid{4,1} = 'AG_thickness_check';
    check_grid{4,2} = input_param(4,1) > 0;

    check_grid{5,1} = 'SG_apr_check';
    check_grid{5,2} = input_param(5,1) > 0;

    check_grid{6,1} = 'AG_apr_check';
    check_grid{6,2} = input_param(6,1) > 0;

    check_grid{7,1} = 'gap_check';
    check_grid{7,2} =  input_param(7,1) > 0;

    check_grid{8,1} = 'SG_voltage_check';
    check_grid{8,2} = input_param(8,1) > 0;

    check_grid{9,1} = 'AG_voltage_check';
    check_grid{9,2} = input_param(9,1) < 0;

    check_grid{10,1} = 'Resol_check';
    check_grid{10,2} = input_param(10,1) > 0;

    check_grid{11,1} = 'LenX_check1';
    check_grid{11,2} = input_param(11,1) > 0;

    check_grid{12,1} = 'LenY_check1';
    check_grid{12,2} = input_param(12,1) > 0;

    check_grid{13,1} = 'LenX_check2';
    check_grid{13,2} = input_param(11,1) > (input_param(3,1)*input_param(1,1)/2 + (input_param(4,1)*input_param(1,1))/2 + input_param(7,1) + input_param(13,1));

    if any([check_grid{:,2}] ~= 0)
        res_data = 0;
    else
        res_data = 1;
    end
end
