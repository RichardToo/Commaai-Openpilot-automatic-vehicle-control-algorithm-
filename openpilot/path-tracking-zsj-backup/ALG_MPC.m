function [steer_cmd,acc]= ALG_MPC(veh_pose, trajref,...
    mpc_params, veh_params, steer_state, time_step)
% ��MPC�㷨��������ǰ��ƫ��

% ���:
% steer_cmd     : ����ǰ��ƫ��, rad
% acc           �����ٶȲ��㣬m/s^2

% ����:
% veh_pose          : ������ǰλ��[x, y, theta]
% trajref           : ����·��[X, Y, Theta, Radius]
% mpc_params        : mpc����
% veh_params        : ��������
% steer_state       : ��ǰǰ��ƫ��, rad
% time_step         : ����ʱ�䲽��, s

% 1. ���㳵����ǰλ��������·���ϵ�ͶӰ��λ��
[~, index] = calc_nearest_point(veh_pose, trajref);
ref_pose = calc_proj_pose(veh_pose(1:2), trajref(index, 1:3),...
    trajref(index + 1, 1:3));

delta_x = (veh_pose - ref_pose)';

% 2. ��������ƫ��
[steer_command,acc,steer_feedforward] = calc_mpc(trajref, delta_x, veh_pose, ref_pose, ...
    mpc_params, index, veh_params);


% 3. ��������ǰ��ƫ�ǧ�
steer_cmd = steer_feedforward + steer_command;

% 4. ��������ǰ��ƫ�ǧ�
steer_cmd = limit_steer_by_angular_vel(steer_cmd, steer_state,...
    veh_params.max_angular_vel, time_step);

steer_cmd = limit_steer_angle(steer_cmd, veh_params.max_steer_angle);


