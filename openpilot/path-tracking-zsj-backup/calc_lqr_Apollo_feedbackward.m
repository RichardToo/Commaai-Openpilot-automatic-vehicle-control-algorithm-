function steer_feedbackward = calc_lqr_Apollo_feedbackward(trajref,...
    delta_x, lqr_apollo_params, index, veh_params, veh_pose)
% ����lqr��ǰ��ƫ�Ƿ���������

% ���:
% steer_feedbackward: ǰ��ƫ�Ƿ���������, rad

% ����:
% trajref           : ����·��[X, Y, Theta, Radius]
% delta_x           : ����λ���복����ǰλ�˵�ƫ��[dx, dy, dtheta]
% lqr_apollo_params        : LQR�Ĳ���
% index       : �����Ż���trajref�ĳ�ʼindex
% veh_params        : ��������
% steer_feedforward : ǰ��ƫ��ǰ��������, rad

% 1. ����LQR�Ĳ���
delta_t = lqr_apollo_params.delta_t;   %LQR��ʱ�䲽��, s
horizon = lqr_apollo_params.horizon;   %�����Ż����ڴ�С
Q = lqr_apollo_params.Q;               %״̬���Ȩ�ؾ���
R = lqr_apollo_params.R;               %������Ȩ�ؾ���
Q0 = lqr_apollo_params.Q0;             %״̬����ն˾���

% 2. ���ó�������
v = veh_params.velocity;      %����, m/s
wheel_base = veh_params.wheel_base;     %���, m

% 3. ������ƫ�����Ƶ�[-pi, pi]
delta_x(3) = angle_normalization(delta_x(3));

% 4. ����Pk��Vk���ն�״̬ʱ�̵�ֵ
Pk = Q0;
Vk = [0; 0; 0];

% 5. Update state
basic_state_size=4;
matrix_state=zeros(4,1);
control_state=zeros(4,1);

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

%calculate the state
% lateral error
matrix_state(1,1)=dy*cos(theta_des)-dx*sin(theta_des);
% lateral error rate
matrix_state(2,1)=v*sin(dtheta);
% heading error
matrix_state(3,1)=angle_normalization(dtheta);
% heading error rate
heading_error_rate=angular_v-angular_v_des;
matrix_state(4,1)=heading_error_rate;

% Update Matrix
 lqr_apollo_params=update_LQR_matrix(v,lqr_apollo_params); 
 A=lqr_apollo_params.A;
 B=lqr_apollo_params.B;
 I=lqr_apollo_params.I;
 ts=lqr_apollo_params.ts;
 
 % ��ɢ��matrix a
 % bilinear discrete matrix A
 matrix_ad=zeros(size(A));
 matrix_ad=(I+ts*0.5 * A) * inv(I-ts*0.5 * A); 
 
 % ��ɢ��matrix b
 matrix_bd=zeros(size(B));
 matrix_bd=B*ts;

% 6. �����Ż�
 K = solve_lqr_problem(matrix_ad, matrix_bd,...
      Q, R, horizon);
  
% 7. ���lqr��ǰ��ƫ�Ƿ���������
 steer_feedbackward = -(K * matrix_state);

 




