function [steer_cmd,acc,steer_feedforward] =  calc_mpc(trajref, delta_x,...
    veh_pose, ref_pose, mpc_params, index, veh_params)
% ���:
% steering_cmd      : ǰ��ƫ�Ƿ���������, rad
% acc               : ���ٶȲ��� m/s^2
% steer_feedforward ��ǰ��ƫ�ǣ�rad

% ����:

% trajref           : ����·��[X, Y, Theta, Radius]
% delta_x           : ����λ���복����ǰλ�˵�ƫ��[dx, dy, dtheta]
% veh_pose          : ������ǰλ��[x, y, theta]
% mpc_params        : MPC�Ĳ���
% index             : �����Ż���trajref�ĳ�ʼindex
% veh_params        : ��������

%% Update state
basic_state_size=6;
matrix_state=zeros(6,1);
control_state=zeros(2,1);

%% update parameter state
dx=delta_x(1);
dy=delta_x(2);
dtheta=delta_x(3);
theta_des=trajref(index,3);
theta=veh_pose(3);
radius_des=trajref(index,4);
k=trajref(index,5);  % curvature
one_min_k=1-k;
if one_min_k<=0
    one_min_k=0.01;
end
% ��ǰ���ٶ�
v=veh_params.velocity; 
% �����ٶ�
v_des=veh_params.v_des; 
% ��ǰת����ٶ�
angular_v=veh_params.angular_v;
% ����ת����ٶ�
angular_v_des=v_des*(1/radius_des);
if angular_v_des < 0.01
    angular_v_des=0;
end

%% calculate the state
% lateral error
matrix_state(1,1)=dy*cos(theta_des)-dx*sin(theta_des);
% lateral error rate
matrix_state(2,1)=v*sin(dtheta);
% heading error
matrix_state(3,1)=angle_normalization(dtheta);
% heading error rate
heading_error_rate=angular_v-angular_v_des;
matrix_state(4,1)=heading_error_rate;
% station error
matrix_state(5,1)=-(dx*cos(theta_des)+dy*sin(theta_des));
% speed error
matrix_state(6,1)=v_des-v*cos(dtheta)/one_min_k;

%% Update Matrix
 mpc_params=update_state_matrix(v,mpc_params); 
 A=mpc_params.A;
 B=mpc_params.B;
 C=mpc_params.C;
 I=mpc_params.I;
 ts=mpc_params.ts;
 
 % ��ɢ��matrix a
 % bilinear discrete matrix A
 matrix_ad=zeros(size(A));
 matrix_ad=(I+ts*0.5 * A) * inv(I-ts*0.5 * A); 
 
 % ��ɢ��matrix b
 matrix_bd=zeros(size(B));
 matrix_bd=B*ts;
 
 % ��ɢ��matrix c
 matrix_cd=C* ts *heading_error_rate; 
 
 %% Feed forward angle Update
 kv=mpc_params.lr*mpc_params.mass/2/mpc_params.cf/...
      veh_params.wheel_base - mpc_params.lf*mpc_params.mass...
      /2/mpc_params.cr/veh_params.wheel_base;
  steer_feedforward=atan(veh_params.wheel_base*k + kv *v*v*k);
  steer_feedforward=angle_normalization(steer_feedforward);
  
  % Todo: gain scheduler for higher speed steering
  
 %% apply MPC solver

horizon = 10;   %Prediction horizon
control = 2;    %control horizon

%����mpc�㷨����
lower_bound=zeros(control,1);
lower_bound(1,1)=-veh_params.max_steer_angle;
lower_bound(2,1)=-veh_params.max_deceleration;

upper_bound=zeros(control,1);
upper_bound(1,1)=veh_params.max_steer_angle;
upper_bound(2,1)=veh_params.max_acceleration;
    
% matrix q Ȩ�ؾ���
matrix_q=zeros(basic_state_size,basic_state_size); %0.05 0 1 0 0 0
matrix_q(1,1)=0.05;
matrix_q(3,3)=1;

% matrix r
matrix_r=eye(control,control); % 1 1

% reference matrix 
% zero matrix since the state is already the error
% 10��״̬����ϵĲο���������ֵ
ref_state=zeros(basic_state_size, 1);

%��MPC
command=solve_mpc_problem(matrix_ad,matrix_bd,matrix_cd...
    ,matrix_q,matrix_r,lower_bound...
    ,upper_bound,ref_state,horizon,control,...
    matrix_state,control_state);

%ǰ��ƫ�Ƿ���������
steer_cmd=command(1);
%ɲ��������ϵ�� 
acc=command(2); %��֤ɲ�������ű仯��ƽ����
  
  
  
  
  
  
 
 
 