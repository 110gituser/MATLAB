% 定义变量范围，在 -2 到 2 之间生成二维网格，用于绘制目标函数
[x, y] = meshgrid(-2:0.1:2, -2:0.1:2); %  -2 到 2 的等间距向量，步长为 0.1
z = x.^2 + y.^2;  % 目标函数 f(x, y) = x² + y²，表示一个抛物面

% 绘制目标函数的3D曲面图
figure;
surf(x, y, z, 'FaceAlpha', 0.7, 'EdgeColor', 'none'); % 半透明面，不显示网格线
hold on;  % 保持当前图像，使后续图像叠加绘制
colormap('parula');  % 设置颜色映射
colorbar;            % 显示颜色条
xlabel('x'); ylabel('y'); zlabel('f(x,y)');  % 坐标轴标签
title('3D Visualization of Lagrange Multiplier'); % 图标题

% 绘制约束平面 x + y = 1，转换为 z 平面上表示
[x_plane, y_plane] = meshgrid(-2:0.1:2);   % 生成平面点
z_plane = zeros(size(x_plane));           % 占位用，无实际意义
surf(x_plane, y_plane, (x_plane + y_plane - 1)*10, ... % 用放大10倍后的表达式模拟平面
     'FaceColor', 'r', 'FaceAlpha', 0.3, 'EdgeColor', 'none'); % 半透明红色平面

% 使用符号变量定义目标函数和约束条件
syms xs ys lambda
f = xs^2 + ys^2;         % 目标函数 f(x, y)
g = xs + ys - 1;         % 约束条件 g(x, y) = x + y - 1 = 0
L = f - lambda * g;      % 构造拉格朗日函数 L = f - λg

% 计算偏导并构建梯度方程组 ∇L = 0
grad = [diff(L, xs); diff(L, ys); diff(L, lambda)];
solutions = solve(grad == [0; 0; 0], [xs, ys, lambda]); % 解方程组

% 提取解并转换为数值
x_points = double(solutions.xs);           % x 坐标
y_points = double(solutions.ys);           % y 坐标
z_points = x_points.^2 + y_points.^2;      % 对应的目标函数值

% 绘制约束条件与目标函数曲面的交线，即 x + y = 1 在线上的 f 值
t = linspace(-2, 2, 100);         % 参数 t 控制点
x_line = t;                       % x = t
y_line = 1 - t;                   % y = 1 - t（使 x + y = 1）
z_line = x_line.^2 + y_line.^2;  % 对应的函数值
plot3(x_line, y_line, z_line, 'k-', 'LineWidth', 3); % 绘制为粗黑线

% 绘制极值点（解）并标记
for i = 1:length(x_points)
    plot3(x_points(i), y_points(i), z_points(i), 'o', ...  % 画点
          'MarkerSize', 10, 'MarkerFaceColor', 'r', ...    % 红色填充
          'MarkerEdgeColor', 'k');                         % 黑边
    % 添加点的文本标签（坐标信息）
    text(x_points(i)+0.1, y_points(i)+0.1, z_points(i)+0.1, ...
         sprintf('(%.1f,%.1f,%.1f)', x_points(i), y_points(i), z_points(i)), ...
         'FontSize', 10, 'Color', 'k');
end

% 坐标轴样式设置
grid on;          % 网格线
axis tight;       % 自动缩放以紧密包围图像
view(30, 30);     % 设置观察视角（方位角 30°, 俯仰角 30°）
set(gca, 'FontSize', 12, 'LineWidth', 1.5);  % 坐标轴字体和线宽

% 生成图例（自动根据点数添加条目）
legend_items = {'目标函数: f(x,y)=x^2+y^2', '约束平面: x+y=1', '约束交线'};
for i = 1:length(x_points)
    legend_items{end+1} = sprintf('极值点 %d', i);
end
legend(legend_items, 'Location', 'northeast'); % 设置图例位置

% 释放 hold 状态，防止后续图形继续绘制到此图中
hold off;
