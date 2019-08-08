function steer_feedforward = calc_steer_feedforward(radius, wheel_base)
% �������ʰ뾶�����Ӧ��ǰ��ƫ�ǣ���Ϊǰ��������

% ���:
% steer_feedforward : ǰ��ǰ��ƫ��, rad

% ����:
% radius            : ��İ뾶ֵ, m
% wheel_base        : ���, m

steer_feedforward = atan(wheel_base / radius);
