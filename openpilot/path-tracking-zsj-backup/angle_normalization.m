function angle_norm = angle_normalization(angle_origin)
% ���Ƕȵ�ȡֵ��Χ��׼����[-pi, pi]

% ���:
% angle_norm    : ��׼����ĽǶ�ֵ,[-pi, pi]

% ����:
% angle_origin  : ԭʼ�Ƕ�ֵ��[-2*pi, 2*pi]

if angle_origin > pi
    angle_norm = angle_origin - 2 * pi;
    
elseif angle_origin < -pi
    angle_norm = angle_origin + 2 * pi;
    
else
    angle_norm = angle_origin;
end

