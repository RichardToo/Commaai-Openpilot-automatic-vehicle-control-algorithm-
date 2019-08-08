function steer_feedbackward = calc_lqr_feedbackward(trajref,...
    delta_x, lqr_params, start_index, veh_params, steer_feedforward)
% ����lqr��ǰ��ƫ�Ƿ���������  //����ʦ��69ҳ

% ���:
% steer_feedbackward: ǰ��ƫ�Ƿ���������, rad

% ����:
% trajref           : ����·��[X, Y, Theta, Radius]
% delta_x           : ����λ���복����ǰλ�˵�ƫ��[dx, dy, dtheta]
% lqr_params        : LQR�Ĳ���
% start_index       : �����Ż���trajref�ĳ�ʼindex
% veh_params        : ��������
% steer_feedforward : ǰ��ƫ��ǰ��������, rad

% 1. ����LQR�Ĳ���
delta_t = lqr_params.delta_t;   %LQR��ʱ�䲽��, s
horizon = lqr_params.horizon;   %�����Ż����ڴ�С
Q = lqr_params.Q;               %״̬���Ȩ�ؾ���
R = lqr_params.R;               %������Ȩ�ؾ���?
Q0 = lqr_params.Q0;             %״̬����ն˾���

% 2. ���ó�������
vel = veh_params.velocity;      %����, m/s
wheel_base = veh_params.wheel_base;     %���, m

% 3. ������ƫ�����Ƶ�[-pi, pi]
delta_x(3) = angle_normalization(delta_x(3));

% 4. ����Pk��Vk���ն�״̬ʱ�̵�ֵ
Pk = Q0;
Vk = [0; 0; 0];    %�ն�״̬ 

% 5. �����Ż�
end_index = start_index + horizon;  %���ù����Ż���trajref�ϵ���ʼindex
for i = end_index : -1  : (start_index + 1)
    Pk_1 = Pk;
    Vk_1 = Vk;
    
    ref_theta = trajref(i-1, 3);        %�ο���ĺ����
    ref_delta = calc_steer_feedforward(...
        trajref(i-1, 4), wheel_base);   %�ο����ǰ��ƫ��
    
    A = [1 0 -vel * sin(ref_theta) * delta_t;
         0 1  vel * cos(ref_theta) * delta_t;
         0 0  1];
    B = [0;
         0;
         vel * delta_t / (wheel_base * cos(ref_delta)^2)];
    
    tmp = B' * Pk_1 * B + R;
    K = B' * Pk_1 * A / tmp;
    Ku = R / tmp;
    Kv = B' / tmp;
    
    Pk = A' * Pk_1 * (A - B * K) + Q;
    u_feedforward = ref_delta;
    Vk = (A - B * K) * Vk_1 - K' * R * u_feedforward;
end

% 6. ���lqr��ǰ��ƫ�Ƿ���������
steer_feedbackward = -K * delta_x - Ku * steer_feedforward - Kv * Vk_1;

