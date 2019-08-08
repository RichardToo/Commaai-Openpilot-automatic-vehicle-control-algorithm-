function heading_angle = calc_heading_angle(point1, point2)
% ��������λ�ü��㺽���

% ���:
% heading_angle : ����ǣ����������ĽǶȣ���ʱ��0~2*pi, rad

% ����:
% point1        : λ������ [x, y]
% point2        : λ������ [x, y]

delta_y = point2(2) - point1(2);
delta_x = point2(1) - point1(1);

heading_angle = mod(atan2(delta_y, delta_x), 2*pi);

