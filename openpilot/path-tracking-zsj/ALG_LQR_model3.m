function steer_cmd = ALG_LQR_model3(veh_pose, trajref, lqr_params,...
    veh_params, steer_state, time_step)
% ��LQR�㷨��������ǰ��ƫ��
% ���õĳ���ģ��model3: [delta_x, delta_y, delta_theta]

% ���:
% steer_cmd     : ����ǰ��ƫ��, rad

% ����:
% veh_pose      : ������ǰλ��[x, y, theta]
% trajref       : ����·��[X, Y, Theta, Radius]
% lqr_params    : LQR����
% veh_params    : ��������
% steer_state   : ��ǰǰ��ƫ��, rad
% time_step     : ����ʱ�䲽��, s

% 1. ���㳵����ǰλ��������·���ϵ�ͶӰ��λ��
[~, index] = calc_nearest_point(veh_pose, trajref);
ref_pose = calc_proj_pose(veh_pose(1:2), trajref(index, 1:3),...
    trajref(index + 1, 1:3));

% 2. ����ο����ǰ��ƫ��ǰ��������
ref_index = index + lqr_params.ref_index;
ref_radius = trajref(ref_index, 4);
steer_feedforward = calc_steer_feedforward(ref_radius,...
    veh_params.wheel_base);

% 3. ��LQR����ǰ��ƫ�Ƿ���������
delta_x = (veh_pose - ref_pose)';
steer_feedbackward = calc_lqr_feedbackward(trajref, delta_x, ...
    lqr_params, index, veh_params, steer_feedforward);

% 4. ��������ǰ��ƫ�ǧ�
steer_cmd = steer_feedforward + steer_feedbackward;

% 5. ��������ǰ��ƫ�ǧ�
steer_cmd = limit_steer_by_angular_vel(steer_cmd, steer_state,...
    veh_params.max_angular_vel, time_step);

steer_cmd = limit_steer_angle(steer_cmd, veh_params.max_steer_angle);


