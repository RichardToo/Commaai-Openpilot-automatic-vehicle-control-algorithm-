function [trajref_params, simulation_stop_y, simulation_stop_time] =...
    set_trajref_params(roadmap_name, veh_params)
% ��������·������������ֹͣ����?

% ���:
% trajref_params        : ����·������
% simulation_stop_y     : ������y����ֵ����60ʱ������ֹͣ��
% simulation_stop_time  : ������ʱ��, s

% ����
% roadmap_name          : ·������

trajref_params.dist_interval = 0.2;     %trajref���������, m

switch (roadmap_name)
    % ������ѡ����·��ָ����Ӧ������·������
    case 'small_circle'
        trajref_params.traj1_dist = 30; %traj1�ĳ���, m
        trajref_params.r2 = 5;          %traj2�İ뾶, m
        trajref_params.traj3_dist = 15; %traj3�ĳ���, m
        trajref_params.r4 = 5;          %traj4�İ뾶, m
        trajref_params.r5 = 5;          %traj5�İ뾶, m
        trajref_params.traj6_dist = 30; %traj6�ĳ���?, m
        
        simulation_stop_y = 30;     %������y����ֵ����30ʱ������ֹͣ
        simulation_stop_time = 90 / veh_params.velocity; %������ʱ��, s
        
    case 'big_circle'
        trajref_params.traj1_dist = 60;
        trajref_params.r2 = 10;
        trajref_params.traj3_dist = 30;
        trajref_params.r4 = 10;
        trajref_params.r5 = 10;
        trajref_params.traj6_dist = 30;
        
        simulation_stop_y = 60;
        simulation_stop_time = 180 / veh_params.velocity;
    case 'wave_test'
        trajref_params.traj1_dist = 230;
        
        simulation_stop_y = 60;
        simulation_stop_time = 180 / veh_params.velocity;
    otherwise
        disp('The roadmap does not exit!');
end

