function draw_traj_curvature(traj)
% ����������ÿ�������
% traj = [X, X, Theta, Radius, Curvature]

k = 10;   %��ʾ���ʳ��ȴ�С�ı���

n = length(traj);   %traj的长�?

for i = 1 : 1 : n
    x = traj(i, 1);     %��ĺ�����
    y = traj(i, 2);     %���������?
    theta = traj(i, 3); %��ĺ����
    r = traj(i, 4);     %��İ뾶
    c = traj(i, 5);     %�������
    circle_theta = theta - pi / 2;  %�õ���Բ�϶�Ӧ�Ļ���
    xo = x - r * cos(circle_theta); %Բ�ĵ�x����
    yo = y - r * sin(circle_theta); %Բ�ĵ�y����
    
    xc = xo + (r + k * c) * cos(circle_theta);  %���ʵ��x����
    yc = yo + (r + k * c) * sin(circle_theta);  %���ʵ��y����
    
    plot([x, xc], [y, yc], 'b');     %���Ӹõ������ʵ�
    hold on;
end


