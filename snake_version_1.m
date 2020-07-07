% задачи:
% 1)сделать главное меню: ввод скорости змеи(сложность), размера
% доски(уровень лагов:D), ника, выбор режима
% 2)сделать тулбар с кнопками: старт/рестарт, посмотреть рекорды, заново
% начать гимн, выключить гимн
% 3) добавить гимн
% 4) добавить рекорды(все как в 2048)
% 5) сделать красочнее фон(figures) игры и рекордов
% 6) оптимизировать - OMEGASUPERHARD
% 7) сделать режим с границей - VERY HARD
function snake_version_1
global food_coord_x;
global food_coord_y;

f = figure('units', 'pixels', 'outerposition', [100 100 630 630], 'Color', [0.5 0.5 0.5], 'menubar', 'none');

toolbar = uitoolbar(f);
[img,map] = imread(fullfile(matlabroot,...
        'toolbox','matlab','icons','file_new.png'));        
p = uipushtool(toolbar,'TooltipString','Start',...
        'ClickedCallback',@game_snake, 'CData', double(img)/65536);

    function game_snake(~,~)    

snake_figure = figure('units', 'pixels', 'outerposition', [100 100 630 630], 'Color', [0.5 0.5 0.5], 'menubar', 'none', 'keypressfcn', @movement_direction,'CloseRequestFcn',@exit_program);
snake_axes = axes('units', 'pixels', 'position', [50 50 490 490],'XTick',[],'YTick',[],'Visible','off');
exit = true;

board_size = 15; % размер маленьких квадратиков
size = 15; % размер доски
for i = 1:size
    for j = 1:size
        chunchic_board(i,j) = rectangle('Position',[i*board_size j*board_size size size],'FaceColor','w','EdgeColor','k'); % рисуем белое поле. пока что границы черные, в релизе поменять на белые
    end
end
snake_size = 9; % размер змеи
start_position_x = [1 2 3 4 5 6 7 8 9];
start_position_y = [5 5 5 5 5 5 5 5 5]; % коорды начала змейки

for i = 1:snake_size
    chunchic_board(start_position_x(i),start_position_y(i)).FaceColor = 'k'; % змейка - черные квадраты
end
movement = true; % движение (вкл, выкл)
direction = 1; % 1 - вправо, 2 - вниз, 3 - влево, 4 - вверх
create_food(); % чтобы создавало еду сразу после старта
move(); % чтобы двигалась сразу после старта
increase_size = false;

    function exit_program(~,~) 
        exit = false;
        delete(gcf)
    end

    function move(~,~)

while movement == true

    if exit == false % выход из цикла при нажатии на закрытие
       break
    end
    
        if start_position_x(end) == food_coord_x && start_position_y(end) == food_coord_y
            create_food();
            increase_size = true; % включить увеличение 
            snake_size = snake_size+1;
            switch direction
                case 1
                    start_position_x(snake_size) = start_position_x(snake_size-1)+1;
                    if start_position_x(snake_size) == size+1;
                        start_position_x(snake_size) = 1;
                    end
                    start_position_y(snake_size) = start_position_y(snake_size-1);
                case 2
                    start_position_x(snake_size) = start_position_x(snake_size-1);
                    start_position_y(snake_size) = start_position_y(snake_size-1)-1;
                    if start_position_y(snake_size) == 0;
                        start_position_y(snake_size) = size;
                    end
                case 3
                    start_position_x(snake_size) = start_position_x(snake_size-1)-1;
                    if start_position_x(snake_size) == 0;
                        start_position_x(snake_size) = size;
                    end
                    start_position_y(snake_size) = start_position_y(snake_size-1);
                case 4
                    start_position_x(snake_size) = start_position_x(snake_size-1);
                    start_position_y(snake_size) = start_position_y(snake_size-1)+1;
                    if start_position_y(snake_size) == size+1;
                        start_position_y(snake_size) = 1;
                    end                  
            end
            chunchic_board(start_position_x(snake_size),start_position_y(snake_size)).FaceColor = 'k';
        end
    
    if direction == 1
        
        if start_position_x(end) == size
            start_position_x(end) = 0;
        end
    
% рисуем новую голову в новой клетке справа от старой головы
% удаляем старый хвост
        new_head_position_x = start_position_x(end)+1; % новые коорды головы
        new_head_position_y = start_position_y(end);
        new_body_position_x = zeros(snake_size-1,1); % новые коорды тела и хвоста
        new_body_position_y = zeros(snake_size-1,1);
        
        for i = 1:snake_size-1
            new_body_position_x(i) = start_position_x(i+1);
            new_body_position_y(i) = start_position_y(i+1);
        end

            if start_position_y(1) == size+1 % для случаев, когда на границе
                start_position_y(1) = 1; % поворачивает больше 1 раза
            elseif start_position_y(1) == 0
                start_position_y(1) = size;
            end
            
            if start_position_x(1) == size+1
                start_position_x(1) = 1;
            elseif start_position_x(1) == 0
                start_position_x(1) = size;
            end
            
        chunchic_board(start_position_x(1),start_position_y(1)).FaceColor = 'w';
        chunchic_board(new_head_position_x,new_head_position_y).FaceColor = 'k';
        
        for i = 1:snake_size-1
            start_position_x(i) = new_body_position_x(i);
            start_position_y(i) = new_body_position_y(i);
        end
        start_position_x(end) = new_head_position_x;
        start_position_y(end) = new_head_position_y;
         
    end
    
    if direction == 2
        if start_position_y(end) == 1
            start_position_y(end) = size+1;
        end
    
% рисуем новую голову в новой клетке снизу от старой головы
% удаляем старый хвост
        new_head_position_x = start_position_x(end); % новые коорды головы
        new_head_position_y = start_position_y(end)-1;
        new_body_position_x = zeros(snake_size-1,1); % новые коорды тела и хвоста
        new_body_position_y = zeros(snake_size-1,1);
        
        for i = 1:snake_size-1
            new_body_position_x(i) = start_position_x(i+1);
            new_body_position_y(i) = start_position_y(i+1);
        end

            if start_position_x(1) == size+1 % для случаев, когда на границе
                start_position_x(1) = 1; % поворачивает больше 1 раза
            elseif start_position_x(1) == 0
                start_position_x(1) = size;
            end
            
            if start_position_y(1) == 0
                start_position_y(1) = size;
            elseif start_position_y(1) == size+1
                start_position_y(1) = 1;
            end
            
        chunchic_board(start_position_x(1),start_position_y(1)).FaceColor = 'w';
        chunchic_board(new_head_position_x,new_head_position_y).FaceColor = 'k';
        
        for i = 1:snake_size-1
            start_position_x(i) = new_body_position_x(i);
            start_position_y(i) = new_body_position_y(i);
        end
        start_position_x(end) = new_head_position_x;
        start_position_y(end) = new_head_position_y;
    end
    
    if direction == 3
        
        if start_position_x(end) == 1
            start_position_x(end) = size+1;
        end
    
% рисуем новую голову в новой клетке слева от старой головы
% удаляем старый хвост
        new_head_position_x = start_position_x(end)-1; % новые коорды головы
        new_head_position_y = start_position_y(end);
        new_body_position_x = zeros(snake_size-1,1); % новые коорды тела и хвоста
        new_body_position_y = zeros(snake_size-1,1);
        
        for i = 1:snake_size-1
            new_body_position_x(i) = start_position_x(i+1);
            new_body_position_y(i) = start_position_y(i+1);
        end

            if start_position_y(1) == size+1 % для случаев, когда на границе
                start_position_y(1) = 1; % поворачивает больше 1 раза
            elseif start_position_y(1) == 0
                start_position_y(1) = size;
            end
            
            if start_position_x(1) == 0
                start_position_x(1) = size;
            elseif start_position_x(1) == size+1
                start_position_x(1) = 1;
            end
            
        chunchic_board(start_position_x(1),start_position_y(1)).FaceColor = 'w';
        chunchic_board(new_head_position_x,new_head_position_y).FaceColor = 'k';
        
        for i = 1:snake_size-1
            start_position_x(i) = new_body_position_x(i);
            start_position_y(i) = new_body_position_y(i);
        end
        start_position_x(end) = new_head_position_x;
        start_position_y(end) = new_head_position_y;
         
    end
    
    if direction == 4
        if start_position_y(end) == size
            start_position_y(end) = 0;
        end
    
% рисуем новую голову в новой клетке сверху от старой головы
% удаляем старый хвост
        new_head_position_x = start_position_x(end); % новые коорды головы
        new_head_position_y = start_position_y(end)+1;
        new_body_position_x = zeros(snake_size-1,1); % новые коорды тела и хвоста
        new_body_position_y = zeros(snake_size-1,1);
        
        for i = 1:snake_size-1
            new_body_position_x(i) = start_position_x(i+1);
            new_body_position_y(i) = start_position_y(i+1);
        end
       
            if start_position_x(1) == size+1 % для случаев, когда на границе
                start_position_x(1) = 1; % поворачивает больше 1 раза
            elseif start_position_x(1) == 0
                start_position_x(1) = size;
            end
            
            if start_position_y(1) == size+1
                start_position_y(1) = 1;
            elseif start_position_y(1) == 0
                start_position_y(1) = size;
            end
            
        chunchic_board(start_position_x(1),start_position_y(1)).FaceColor = 'w';
        chunchic_board(new_head_position_x,new_head_position_y).FaceColor = 'k';
        
        for i = 1:snake_size-1
            start_position_x(i) = new_body_position_x(i);
            start_position_y(i) = new_body_position_y(i);
        end
        start_position_x(end) = new_head_position_x;
        start_position_y(end) = new_head_position_y;
    end
    
    for i = 1:snake_size-1
        if start_position_x(end) == start_position_x(i) && start_position_y(end) == start_position_y(i)
            movement = false;
        end
    end
    
    increase_size = false; 
    drawnow;
    pause(0.05)
    new_body_position_x = []; % очищаем массивы, чтобы не мешали при увеличении длины
    new_body_position_y = [];
end
    end
    function movement_direction(hObject,~)
        key = get(hObject,'CurrentKey');
        if strcmp(key,'shift') == true
            movement = false;
        elseif strcmp(key,'return') == true
            movement = true;
        elseif strcmp(key,'downarrow') == true
            if direction == 4 || direction == 2
                return
            else
                direction = 2;
            end
        elseif strcmp(key,'leftarrow') == true
            if direction == 1 || direction ==3
                return
            else
                direction = 3;
            end
        elseif strcmp(key,'uparrow') == true
            if direction == 2 || direction == 4
                return
            else
                direction = 4;
            end
        elseif strcmp(key,'rightarrow') == true
            if direction == 3 || direction == 1
                return
            else
                direction = 1;
            end
        end
        
        move();
    end
    function create_food(~,~)
        food_coord_x = randi(size);
        food_coord_y = randi(size);
        for i = 1:snake_size
            if food_coord_x == start_position_x(i) && food_coord_y == start_position_y(i)
                create_food(); 
            end
        end
        chunchic_board(food_coord_x,food_coord_y).FaceColor = 'b';
    end
    end
end