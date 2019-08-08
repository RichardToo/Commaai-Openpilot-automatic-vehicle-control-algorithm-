function veh_pose = update_veh_pose_mpc(origin_pose, steer_angle,...
    steer_acc,veh_params,mpc_params, time_step)

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

veh_params.velocity=veh_params.velocity + steer_acc* time_step ;
v=veh_params.velocity;

%% �ö���ѧ��������λ�ˣ�����
% Ac=mpc_params.A;
% % Update the velocity of the Matrix A
% Ac(2,2)=Ac(2,2)/v;
% Ac(2,4)=Ac(2,3)/v;
% Ac(4,2)=Ac(4,2)/v;
% Ac(4,4)=Ac(4,4)/v;
%  
% Bc=mpc_params.B;
% Cc=mpc_params.C;
% % update matrix C
% Cc(2,1)=(mpc_params.lr*mpc_params.cr-...
%      mpc_params.lf*mpc_params.cf)/(mpc_params.mass*v)-v;
% Cc(4,1)=-(mpc_params.lf*mpc_params.lf*...
%      mpc_params.cf+mpc_params.lr*mpc_params.lr*...
%      mpc_params.cr)/(mpc_params.iz*v);
% 
% % Update matrix D
% n = size(Ac,1); % number of states
% p = size(Bc,2); % number of input
% q = size(Cc,1); % number of output
% Dc = zeros(q,p);
% 
%  [Ad,Bd,Cd,Dd] = c2dm(Ac,Bc,Cc,Dc,time_step);

%% 

 delta_dist = v * time_step;
 
% [y_k,y_k1,theta_k,theta_k1]=Ad*[delta_dist;v;theta0;veh_params.angular_v]...
%     +Bd.*steer_angle;
%%

  %�����ڵ�λ���沽���߹��ľ���

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


