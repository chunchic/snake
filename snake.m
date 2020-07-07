function snake
snake_figure = figure('units', 'pixels', 'outerposition', [100 100 630 630], 'menubar', 'none', 'keypressfcn', @movement_direction);
snake_axes = axes('units', 'pixels', 'position', [50 50 490 490],'XTick',[],'YTick',[],'Visible','off');

board_size = 30;
size = 51;
for i = 1:size
    for j = 1:size
        chunchic_board(i,j) = rectangle('Position',[i*board_size j*board_size size size],'FaceColor','w','EdgeColor','k'); % рисуем белое поле. пока что границы черные, в релизе поменять на белые
    end
end
snake_size = 4;
start_position_x = [20 21 22 23];
start_position_y = [5 5 5 5]; % коорды начала змейки

for i = 1:snake_size
    chunchic_board(start_position_x(i),start_position_y(i)).FaceColor = 'k'; % змейка - черные квадраты
end
movement = true;
direction = 1; % 1 - вправо, 2 - вниз, 3 - влево, 4 - вверх
move(); % чтобы двигалась сразу после старта

    function move(~,~)
        
while movement == true
    
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
        
        chunchic_board(new_head_position_x,new_head_position_y).FaceColor = 'k';
        if start_position_x(1) == 0
            chunchic_board(size,start_position_y(1)).FaceColor = 'w';
        else
        chunchic_board(start_position_x(1),start_position_y(1)).FaceColor = 'w';
        end
        
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
        
        chunchic_board(new_head_position_x,new_head_position_y).FaceColor = 'k';
        if start_position_y(1) == size+1
            chunchic_board(start_position_x(1),1).FaceColor = 'w';
        else
        chunchic_board(start_position_x(1),start_position_y(1)).FaceColor = 'w';
        end
        
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
    
% рисуем новую голову в новой клетке справа от старой головы
% удаляем старый хвост
        new_head_position_x = start_position_x(end)-1; % новые коорды головы
        new_head_position_y = start_position_y(end);
        new_body_position_x = zeros(snake_size-1,1); % новые коорды тела и хвоста
        new_body_position_y = zeros(snake_size-1,1);
        
        for i = 1:snake_size-1
            new_body_position_x(i) = start_position_x(i+1);
            new_body_position_y(i) = start_position_y(i+1);
        end
        
        chunchic_board(new_head_position_x,new_head_position_y).FaceColor = 'k';
        if start_position_x(1) == size+1
            chunchic_board(1,start_position_y(1)).FaceColor = 'w';
        else
        chunchic_board(start_position_x(1),start_position_y(1)).FaceColor = 'w';
        end
        
        for i = 1:snake_size-1
            start_position_x(i) = new_body_position_x(i);
            start_position_y(i) = new_body_position_y(i);
        end
        start_position_x(end) = new_head_position_x;
        start_position_y(end) = new_head_position_y;
         
    end
    
    drawnow;
    pause(0.2)
end
    end
    function movement_direction(hObject,~)
        key = get(hObject,'CurrentKey');
        if strcmp(key,'shift') == true
            movement = false;
        elseif strcmp(key,'return') == true
            movement = true;
        elseif strcmp(key,'downarrow') == true && direction ~= 4
            direction = 2;
        elseif strcmp(key,'leftarrow') == true && direction ~= 1
            direction = 3;
        elseif strcmp(key,'uparrow') == true && direction ~= 2
            direction = 4;
        elseif strcmp(key,'rightarrow') == true && direction ~= 3
            direction = 1;
        end
        
        move();
    end
end