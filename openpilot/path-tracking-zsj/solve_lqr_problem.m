function K = solve_lqr_problem(A, B, Q, R, max_iter)
% ���LQR��Kֵ

% ���:
% K         :

% ����:
% A         : ״̬����
% B         : ���ƾ���
% Q         : ״̬��Ȩ����
% R         : ���Ƽ�Ȩ����
% min_tol   : ��С�������
% max_iter  : ����������

% ���
% K: ��������

AT = A';
BT = B';

P = Q; %P�ĳ�ʼֵΪQ
n = 0; %��������

min_tol = 0.0001;
while(n < max_iter)
    tmp1 = inv(R + BT * P * B);
    P_next = AT * P * A - AT * P * B * tmp1 * BT * P * A + Q;
    
    diff = norm(P_next - P); %�������
    P = P_next;
    
    if (diff < min_tol)
        disp("Error,LQR cannot find the answer")
        break;
    end
    
    n = n + 1;
end

tmp2 = inv(R + BT * P * B);
K = tmp2 * BT * P * A;


