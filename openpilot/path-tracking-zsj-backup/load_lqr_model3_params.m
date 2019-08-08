function lqr_model3_params = load_lqr_model3_params(trajref_params,...
    veh_params)
% ����LQR_model3�Ĳ���?

% ����:
% trajref_params : trajref�Ĳ���
% veh_params     : veh�Ĳ���

lqr_model3_params.delta_t = trajref_params.dist_interval /...
    veh_params.velocity;              %LQR��ʱ�䲽��, s

lqr_model3_params.ref_index = 0;      %���ٲο���
lqr_model3_params.horizon = 15;       %�����Ż����ڵĴ�С

lqr_model3_params.Q = [10,  0,   0;
                        0, 5,   0;
                        0,  0, 100];  %״̬���Ȩ�ؾ��� inital 10 10 100
                                                        %10 5 100 best
                    
lqr_model3_params.R = 10;             %������Ȩ�ؾ���

lqr_model3_params.Q0 = [1, 0, 0;
                        0, 1, 0;
                        0, 0, 1];     %״̬����ն˾���

