function y_limits = set_y_limits(roadmap_name)
% ����figure��ʾ��y�᷶Χ

% ���:
% y_limits     : y�᷶Χ

% ����
% roadmap_name : ·������

switch (roadmap_name)
    % ����·��ָ��figure��y�᷶Χ
    case 'small_circle'
        y_limits = [-2, 35];
        
    case 'big_circle'
        y_limits = [-2, 70];
    
    case 'wave_test'
        y_limits = [-2, 70];
    otherwise
        disp('The roadmap does not exit!');
end

