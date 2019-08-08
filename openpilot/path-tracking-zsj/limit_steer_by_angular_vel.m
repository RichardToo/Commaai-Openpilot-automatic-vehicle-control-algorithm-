function steer_angle = limit_steer_by_angular_vel(expect_steer_angle,...
    current_steer_angle, max_angular_vel, time_step)
% ����ǰ��ƫ�ǲ������������ٶȵ�����?

% 输出:
% steer_angle  : ������ٶ�Լ��������ǰ��ƫ��?

% 输入:
% expect_steer_angle  : ��ǰ����������ǰ��ƫ��
% current_steer_angle : ��ǰʱ��ǰ��ƫ�ǵ�ʵ��ֵ?
% max_angular_vel     : ���ǰ��ƫ�ǽ��ٶ�
% time_step           : ʱ�䲽��

steer_angle = expect_steer_angle;

max_steer_angle = current_steer_angle + max_angular_vel * time_step;
min_steer_angle = current_steer_angle - max_angular_vel * time_step;

steer_angle = min(steer_angle, max_steer_angle);
steer_angle = max(steer_angle, min_steer_angle);
