% 定义变量范围，在 -1.5 到 1.5 之间生成网格数据
[x1, x2] = meshgrid(-1.5:0.05:1.5, -1.5:0.05:1.5);

% 定义目标函数 f(x1, x2) = x1^2 + 2*x2
f = x1.^2 + 2*x2;

% 绘制目标函数的等高线图（contourf 用于填充等高线）
figure;
contourf(x1, x2, f, 20, 'LineWidth', 1); % 20 表示等高线数量
hold on;

% 绘制约束条件单位圆：x1^2 + x2^2 = 1
theta = linspace(0, 2*pi, 100); % 极角从 0 到 2π
plot(cos(theta), sin(theta), 'r-', 'LineWidth', 2); % 单位圆

% 使用符号计算定义符号变量
syms x1_sym x2_sym lambda_sym

% 定义目标函数和约束条件（符号表达式）
f_sym = x1_sym^2 + 2*x2_sym;
g_sym = x1_sym^2 + x2_sym^2 - 1;

% 构造拉格朗日函数 L = f - λ*g
L = f_sym - lambda_sym * g_sym;

% 对 L 求偏导，构建一阶偏导方程组
dL_dx1 = diff(L, x1_sym);      % ∂L/∂x1
dL_dx2 = diff(L, x2_sym);      % ∂L/∂x2
dL_dlambda = diff(L, lambda_sym); % ∂L/∂λ

% 解三元方程组：求解驻点（可能的极值点）
solutions = solve([dL_dx1 == 0, dL_dx2 == 0, dL_dlambda == 0], [x1_sym, x2_sym, lambda_sym]);

% 提取所有实数解（忽略复数解）
real_solutions = [];
for i = 1:length(solutions.x1_sym)
    x1_val = double(solutions.x1_sym(i));
    x2_val = double(solutions.x2_sym(i));
    
    % 判断是否为实数
    if isreal(x1_val) && isreal(x2_val)
        real_solutions = [real_solutions; x1_val, x2_val]; % 加入结果列表
    end
end

% 在图中标记极值点
for i = 1:size(real_solutions, 1)
    x1_point = real_solutions(i, 1);
    x2_point = real_solutions(i, 2);
    f_value = x1_point^2 + 2*x2_point; % 计算该点对应的目标函数值
    
    % 判断是否为全局最小值，并使用不同颜色标记
    if f_value == min(f_value)
        % 用白底蓝圈表示最小值点
        plot(x1_point, x2_point, 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'w');
        text(x1_point+0.1, x2_point+0.1, sprintf('f=%.1f', f_value), 'Color', 'w', 'FontSize', 11);
    else
        % 用红色实心圆表示其他极值点
        plot(x1_point, x2_point, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
        text(x1_point+0.1, x2_point+0.1, sprintf('f=%.1f', f_value), 'Color', 'r', 'FontSize', 11);
    end
end

% 设置坐标轴属性
grid on;              % 显示网格线
box on;               % 边框
xlabel('x_1', 'FontSize', 12, 'FontWeight', 'bold'); % x 轴标签
ylabel('x_2', 'FontSize', 12, 'FontWeight', 'bold'); % y 轴标签
title('拉格朗日乘数法可视化', 'FontSize', 14);         % 图标题
set(gca, 'LineWidth', 1.5, 'FontSize', 11);          % 坐标轴外观
axis equal;          % 保持坐标轴比例相同，使单位圆不变形

% 添加图例
legend('目标函数等高线', '约束条件: x_1^2+x_2^2=1', ...
       '极值点 (局部)', '极值点 (全局最小)', 'Location', 'best');

hold off; % 释放 hold 即每次绘图时都会清除原图重新绘制


% 