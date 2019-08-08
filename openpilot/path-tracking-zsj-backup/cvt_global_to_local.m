function point_local = cvt_global_to_local(point_global, base_local)
% ����ϵת��������������ȫ������ϵתΪ�ֲ�����ϵ

% ���:
% point_local: �ֲ�����ϵ�ĵ�����[x_local, y_local]

% ����:
% point_global: ȫ������ϵ�ĵ�����[x_global, y_global]
% base_local  : �ֲ�����ϵ��ȫ������ϵ��λ�úͽǶ�[x_base, y_base, theta_base]

base_point = base_local(1:2);   %�ֲ�����ϵ��ԭ������
base_theta = base_local(3);     %�ֲ�����ϵX����ȫ������ϵX�����ԽǶ�

% ƽ�Ʊ任
tmp_point = point_global - base_point;

% ��ת�任
A = [cos(base_theta), -sin(base_theta); 
     sin(base_theta),  cos(base_theta)];
point_local = tmp_point * A;

