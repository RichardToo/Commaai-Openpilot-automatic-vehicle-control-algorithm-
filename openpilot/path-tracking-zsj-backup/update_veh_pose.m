function veh_pose = update_veh_pose(origin_pose, steer_angle,...
    veh_params, time_step)
% ���³�����λ��״̬ vehicle_pose = [x, y, theta]
% x     : ������, m
% y     : ������, m
% theta : ����ǣ��������ĽǶȣ���ʱ��[0, 2*pi], rad

% ����:
% origin_pose   : ��ʼ����λ��״̬
% steer_angle   : ǰ��ƫ��, rad
% veh_params    : ��������
% time_step     : ���沽��, s

x0 = origin_pose(1);
y0 = origin_pose(2);
theta0 = origin_pose(3);

delta_dist = veh_params.velocity * time_step;  %�����ڵ�λ���沽���߹��ľ���

tol = 0.0001;   %�ж�ֱ�л���ת���ǰ��ƫ����ֵ

if abs(steer_angle) > tol
    % ת��
    radius = veh_params.wheel_base / tan(steer_angle);  %ת��뾶
    center_x = x0 - radius * sin(theta0);
    center_y = y0 + radius * cos(theta0);
    
    delta_theta = delta_dist / radius;
    theta = theta0 + delta_theta;
    x = center_x + radius * sin(theta);
    y = center_y - radius * cos(theta);
else
    % ֱ�С�
    x = x0 + delta_dist * cos(theta0);
    y = y0 + delta_dist * sin(theta0);
    theta = theta0;
end

theta = mod(theta, 2*pi); %theta�ķ�ΧΪ0~2*pi
veh_pose = [x, y, theta];


