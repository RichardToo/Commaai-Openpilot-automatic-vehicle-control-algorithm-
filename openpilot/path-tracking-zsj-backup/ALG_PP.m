function steer_cmd = ALG_PP(veh_pose, trajref, pp_params,...
    veh_params, steer_state, time_step)
% ��PP�㷨��������ǰ��ƫ��

% ���:
% steer_cmd         : ����ǰ��ƫ�ǧ�, rad

% ����:
% veh_pose          : ������ǰλ��[x, y, theta]
% trajref           : ����·��[X, Y, Theta, Radius]
% pp_params         : pp����
% veh_params        : ��������
% steer_state       : ��ǰǰ��ƫ��, rad
% time_step         : ����ʱ�䲽��, s

% 1. ���㳵���ڵ�ǰλ��������·���ϵ������
[~, index] = calc_nearest_point(veh_pose, trajref);

% 2. ����Ԥ����릻
preview_dist = calc_preview_dist(pp_params, veh_params.velocity);

% 3. ����Ԥ���λ��? 
% 3.1. ����������·���ϵ�Ԥ���
preview_point_global = preview_point_on_trajref(veh_pose,...
    preview_dist, trajref, index);

% 3.2. ��Ԥ����ȫ������ϵת�������ֲ�����ϵ
base_local = veh_pose;  %����λ����Ϊ�ֲ�����ϵԭ��
base_local(3) = veh_pose(3) - pi/2;  %���ĺ���ΪY��
preview_point_local = cvt_global_to_local(preview_point_global,...
    base_local);

% 4. ��������ǰ��ƫ�ǧ�
steer_cmd = pure_pursuit(preview_point_local, veh_params.wheel_base);

% 5. ��������ǰ��ƫ��?
steer_cmd = limit_steer_by_angular_vel(steer_cmd, steer_state,...
    veh_params.max_angular_vel, time_step);

steer_cmd = limit_steer_angle(steer_cmd, veh_params.max_steer_angle);

