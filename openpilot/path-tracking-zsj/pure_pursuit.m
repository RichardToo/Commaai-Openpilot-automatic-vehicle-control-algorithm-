function steer_angle = pure_pursuit(preview_point, wheel_base)
% pure pursuit��������ǰ��ƫ�ǧ�

% 输出:
% steer_angle       : ǰ��ת��, rad

% 输入: 
% preview_point     : Ԥ�������[x, y]
% wheel_base        : ���, m

preview_dist = norm(preview_point);     %Ԥ�����, m
alpha = asin(-preview_point(1) / preview_dist);     %Ԥ����뵱ǰλ�õĽǶ�
steer_angle = atan(2 * wheel_base * sin(alpha) / preview_dist); %ǰ��ƫ�ǧ�

