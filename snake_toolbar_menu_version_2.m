% ������:
% 1)������� ������� ����: ���� �������� ����(���������), �������
% �����(������� �����:D), ����, ����� ������ - ALMOST DONE!
% 2)������� ������ � ��������: �����/�������, ���������� �������, ������
% ������ ����, ��������� ���� - DONE!
% 3) �������� ���� - DONE!
% 4) �������� �������(��� ��� � 2048)
% 5) ������� ��������� ���(figures) ���� � ��������
% 6) �������������� - OMEGASUPERHARD
% 7) ������� ����� � �������� - VERY HARD
% 8) ������ ������ ��� ������/��������, ������� ������, ������� ����������
% ��� ���������
function snake_toolbar_menu_version_2
global food_coord_x
global food_coord_y
global points
global record_check

snake_figure = figure('units', 'pixels', 'outerposition', [100 100 630 630], 'Color', [0.5 0.5 0.5], 'menubar', 'none');

toolbar = uitoolbar(snake_figure);
[img,map] = imread(fullfile(matlabroot,...
        'toolbox','matlab','icons','file_new.png'));        
p = uipushtool(toolbar,'TooltipString','Start',...
        'ClickedCallback',@start_game_snake, 'CData', double(img)/65536);

difficulty_sign = uicontrol('units', 'pixels', 'style', 'text', 'position', [20 525 300 30], ...
     'horizontalalignment', 'left', 'max', 2, 'fontsize', 15,'visible','on','string', 'choose the game difficulty :)', 'userdata', 'victory_sign','backgroundcolor',[0.5 0.5 0.5]);
game_difficulty = uicontrol('units', 'pixels', 'style', 'popupmenu', 'position', [20 500 150 20], ...
     'horizontalalignment', 'left', 'max', 2, 'fontsize', 15,'visible','on','string',...
     {'borderless';'border'},'userdata', 'difficulty');
enter_your_name_sign = uicontrol('units', 'pixels', 'style', 'text', 'position', [20 400 300 30], ...
     'horizontalalignment', 'left', 'max', 2, 'fontsize', 15,'visible','on','string', 'enter your name, mortal', 'userdata', 'enter_your_name_sign','backgroundcolor',[0.5 0.5 0.5]);
enter_your_name = uicontrol('units', 'pixels', 'style', 'edit', 'position', [20 350 300 30], ...
     'horizontalalignment', 'left', 'max', 2, 'fontsize', 15,'visible','on','string', '', 'userdata', 'name');
[img,map] = imread(fullfile(matlabroot,...
        'toolbox','matlab','icons','tool_text_justify.png'));        
records_toolbar = uipushtool(toolbar,'TooltipString','Highscores',...
        'ClickedCallback',@open_records, 'CData', double(img)/65536);       
record_check = 0;

    function start_game_snake(~,~)
[img,map] = imread(fullfile(matlabroot,...
        'toolbox','matlab','icons','help_gs.png'));        
anthem_toolbar = uipushtool(toolbar,'TooltipString','Restart anthem',...
        'ClickedCallback',@restart_anthem, 'CData', double(img)/65536);
    
[img,map] = imread(fullfile(matlabroot,...
        'toolbox','matlab','icons','help_gs.png'));        
stop_anthem_toolbar = uipushtool(toolbar,'TooltipString','Stop anthem',...
        'ClickedCallback',@stop_anthem, 'CData', double(img)/65536);        
        
snake_figure.CloseRequestFcn = @exit_program;
snake_figure.KeyPressFcn = @movement_direction;
difficulty_sign.Visible = 'off';
game_difficulty.Visible = 'off';
enter_your_name_sign.Visible = 'off';
enter_your_name.Visible = 'off';
p.ClickedCallback = @restart_snake;
name = enter_your_name.String;
p.TooltipString = 'Restart';

snake_axes = axes('units', 'pixels', 'position', [50 50 490 490],'XTick',[],'YTick',[],'Visible','off');
points = 0;
points_text = uicontrol('units', 'pixels', 'style', 'text', 'position', [550 70 50 20], ...
     'horizontalalignment', 'left', 'max', 2, 'fontsize', 8, 'string', 'Points:', 'userdata', 'points_text');
points_value = uicontrol('units', 'pixels', 'style', 'text', 'position', [550 50 50 20], ...
     'horizontalalignment', 'left', 'max', 2, 'fontsize', 8, 'string', points, 'userdata', 'points_value'); 

exit = true;

board_size = 20; % ������ ��������� �����������
size = 20; % ������ �����
for i = 1:size
    for j = 1:size
        chunchic_board(i,j) = rectangle('Position',[i*board_size j*board_size size size],'FaceColor','w','EdgeColor','k'); % ������ ����� ����. ���� ��� ������� ������, � ������ �������� �� �����
    end
end
snake_size = 3; % ������ ����
start_position_x = [1 2 3 ];
start_position_y = [1 1 1 ]; % ������ ������ ������

for i = 1:snake_size
    chunchic_board(start_position_x(i),start_position_y(i)).FaceColor = 'k'; % ������ - ������ ��������
end
movement = true; % �������� (���, ����)
direction = 1; % 1 - ������, 2 - ����, 3 - �����, 4 - �����
create_food(); % ����� ��������� ��� ����� ����� ������

anthem_filename = 'C:\Users\chunchic\Document\���\������� 7\game_snake\anthem.wav';
[y,Fs] = audioread(anthem_filename);
play_anthem = audioplayer(y,Fs);
play(play_anthem);

move(); % ����� ��������� ����� ����� ������


    function exit_program(~,~) 
        exit = false;
        delete(gcf)
    end

    function move(~,~)

while movement == true

    if exit == false % ����� �� ����� ��� ������� �� ��������
       break
    end
    
        if start_position_x(end) == food_coord_x && start_position_y(end) == food_coord_y
            create_food();
            increase_size = true; % �������� ���������� 
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
    
% ������ ����� ������ � ����� ������ ������ �� ������ ������
% ������� ������ �����
        new_head_position_x = start_position_x(end)+1; % ����� ������ ������
        new_head_position_y = start_position_y(end);
        new_body_position_x = zeros(snake_size-1,1); % ����� ������ ���� � ������
        new_body_position_y = zeros(snake_size-1,1);
        
        for i = 1:snake_size-1
            new_body_position_x(i) = start_position_x(i+1);
            new_body_position_y(i) = start_position_y(i+1);
        end

            if start_position_y(1) == size+1 % ��� �������, ����� �� �������
                start_position_y(1) = 1; % ������������ ������ 1 ����
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
    
% ������ ����� ������ � ����� ������ ����� �� ������ ������
% ������� ������ �����
        new_head_position_x = start_position_x(end); % ����� ������ ������
        new_head_position_y = start_position_y(end)-1;
        new_body_position_x = zeros(snake_size-1,1); % ����� ������ ���� � ������
        new_body_position_y = zeros(snake_size-1,1);
        
        for i = 1:snake_size-1
            new_body_position_x(i) = start_position_x(i+1);
            new_body_position_y(i) = start_position_y(i+1);
        end

            if start_position_x(1) == size+1 % ��� �������, ����� �� �������
                start_position_x(1) = 1; % ������������ ������ 1 ����
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
    
% ������ ����� ������ � ����� ������ ����� �� ������ ������
% ������� ������ �����
        new_head_position_x = start_position_x(end)-1; % ����� ������ ������
        new_head_position_y = start_position_y(end);
        new_body_position_x = zeros(snake_size-1,1); % ����� ������ ���� � ������
        new_body_position_y = zeros(snake_size-1,1);
        
        for i = 1:snake_size-1
            new_body_position_x(i) = start_position_x(i+1);
            new_body_position_y(i) = start_position_y(i+1);
        end

            if start_position_y(1) == size+1 % ��� �������, ����� �� �������
                start_position_y(1) = 1; % ������������ ������ 1 ����
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
    
% ������ ����� ������ � ����� ������ ������ �� ������ ������
% ������� ������ �����
        new_head_position_x = start_position_x(end); % ����� ������ ������
        new_head_position_y = start_position_y(end)+1;
        new_body_position_x = zeros(snake_size-1,1); % ����� ������ ���� � ������
        new_body_position_y = zeros(snake_size-1,1);
        
        for i = 1:snake_size-1
            new_body_position_x(i) = start_position_x(i+1);
            new_body_position_y(i) = start_position_y(i+1);
        end
       
            if start_position_x(1) == size+1 % ��� �������, ����� �� �������
                start_position_x(1) = 1; % ������������ ������ 1 ����
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
    new_body_position_x = []; % ������� �������, ����� �� ������ ��� ���������� �����
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
        food_coord_x = randi(size); % ��������� ������ ����� ���
        food_coord_y = randi(size);
        if chunchic_board(food_coord_x,food_coord_y).FaceColor == [0 0 0]
            create_food(); % ����� �� ��������� ��� "� ������"
        end
        chunchic_board(food_coord_x,food_coord_y).FaceColor = 'b';
    end
    
        function restart_snake(~,~) % ������� ����
            
            stop(play_anthem);   
            delete(anthem_toolbar);
            delete(stop_anthem_toolbar);
            movement = false; % ������ ������������� ������
            delete(chunchic_board); % ������� figure
            
            start_game_snake(); % ������ ��������� �����
        end
        
        function restart_anthem(~,~) 
            anthem_filename = 'C:\Users\chunchic\Document\���\������� 7\game_2048\anthem.wav';
            [y,Fs] = audioread(anthem_filename);
            play_anthem = audioplayer(y,Fs);
            play(play_anthem);
        end
        
    function stop_anthem(~,~)
        stop(play_anthem);
    end
    
    end
end