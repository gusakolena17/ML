    
% Script entry point
function Script2Buttons(fullFileName)
    
    % If Filename not specified as argument then
    if nargin < 1
        % Use dialog to choose image file
        %%[file, folder] = uigetfile({'*.jpg';'*.png';'*.tif';'*.*'},'Select the image file');
        %%fullFileName = fullfile(folder,file);
        %[fullFileName, user_cancelled] = imgetfile;
        %if user_cancelled
        %    return;
        %end
    end
    
    uicontrol('Style', 'pushbutton', 'Unit', 'normalized', 'Position', [0.1 0.02 0.3 0.05], ...
        'String', 'Графік #1', 'Callback', @do_work1_Callback);
    uicontrol('Style', 'pushbutton', 'Unit', 'normalized', 'Position', [0.4 0.02 0.3 0.05], ...
        'String', 'Обчислити #2', 'Callback', @do_work2_Callback);

    function do_work1_Callback(src, evt)
        do_work1();
    end
    function do_work2_Callback(src, evt)
        do_work2();
    end
    
end

function do_work1()
    %clear, clc
 
    s =[8, 8.5, 9, 9.5, 10, 10.5, 11, 11.5, 12];
    V = [25.75, 27.25, 29.5, 31.0, 32.5, 34.0, 35.5, 37.75, 39.25];

    contrastAmount = 1.0;
    valDistance = 0;
    
    function draw()
        cla
        plot(s,V,'ob'), hold on

        % ?????????? ??????? ??????????
        f = @(x,u) x(1)*u + x(2);

        x0 = [1 0]; % ?????????
        x = lsqcurvefit(f,x0,s,V) % ??????? ???????????

        Vn = f(x,s) +  valDistance; % ??????? ???? ???????? ?????

        plot(s*contrastAmount,Vn,':r') % ??????
        legend('Дані','Апроксимація',2)

        d = sum(V-Vn) % ???? ?????????
        ds = sum((V-Vn).^2) % ???? ????????? ?????????
    end
    
    draw();
    
    
    hp = uipanel('Title','', 'Position',[1/2 0.93 1/2 1/15]);
    
    % Callback functions for sliders
    function onContrastSlider(hObject, eventdata)
        contrastAmount = get(hObject,'Value');
        draw();
    end
    function onMaskSlider(hObject, eventdata)
        valDistance = get(hObject,'Value');
        draw();
    end

    uicontrol('Style', 'text', 'Unit', 'normalized', 'Position', [0 .5 .5 .5], 'String', 'Scale:', 'HorizontalAlign', 'left', 'Parent', hp);
    uicontrol('Style', 'text', 'Unit', 'normalized', 'Position', [.5 .5 .5 .5], 'String', 'Distance:', 'HorizontalAlign', 'left', 'Parent', hp);
    
    % Create two sliders for contrast and threshold.
    uicontrol('Style', 'slider', 'Min', 1.0, 'Max', 2.0, 'Unit', 'normalized', 'Parent', hp,...
        'Value', contrastAmount, 'Position', [0 0 .5 .5], 'Callback', @onContrastSlider);
    uicontrol('Style', 'slider', 'Min', 0, 'Max', 255, 'Unit', 'normalized', 'Parent', hp,...
        'Value', valDistance, 'Position', [.5 0 .5 .5], 'Callback', @onMaskSlider);
    
    
    uicontrol('Style', 'pushbutton', 'Unit', 'normalized', 'Position', [0.65 0.7 0.3 0.05], ...
        'String', 'Load', 'Callback', @do_load_Callback);
    
    function do_load_Callback(src, evt)
        % Use dialog to choose xls file
        [file, folder] = uigetfile({'*.xls';'*.*'},'Select the Ms.Excel file');
        if isequal(file,0) || isequal(folder,0)
            return;
        end
        inputFullFileName = fullfile(folder, file);

        %clear all;
        s=xlsread(inputFullFileName,1,'A2:A1000');
        V=xlsread(inputFullFileName,1,'B2:B1000');
        draw()
    end
    
end

function ret = do_work2()
    
    %y=a*exp^m*x 
    
    x = 0;
    y = 0;
    
    contrastAmount = 1.0;
    valDistance = 0;
    
    do_load_Callback(0, 0);
    
    function draw()
        cla
    
        N=length(x);

        figure(1);
        plot(x,y), grid on;
        hold on;
        xx = 0.896;


        % ????????????
        y_=log(y);

        sum1 = 0;
        sum2 = 0;
        sum3 = 0;
        sum4 = 0;
        for i=1:1:N
            sum1 = sum1 + x(i);
            sum2 = sum2 + y_(i);
            sum3 = sum3 + x(i)^2;
            sum4 = sum4 + x(i)*y_(i);
        end
        Mx  = sum1/N;
        Mx2 = sum3/N;
        My  = sum2/N;
        Mxy = sum4/N;

        A = [Mx2 Mx
            Mx 1];
        B = [Mxy
            My];

        X = A\B;
        a = X(1),
        b = X(2),
        m = a;
        a = exp(b);

        y__ = a*exp(m*x);

        figure(1);
        plot(x*contrastAmount,y__ +  valDistance,'r'), grid on;
        legend('1','2',-1);
        yy = a*exp(m*xx);
        Y(3) = yy;
        %-
    end
    
    hp = uipanel('Title','', 'Position',[1/2 0.93 1/2 1/15]);
    
    % Callback functions for sliders
    function onContrastSlider(hObject, eventdata)
        contrastAmount = get(hObject,'Value');
        draw();
    end
    function onMaskSlider(hObject, eventdata)
        valDistance = get(hObject,'Value');
        draw();
    end

    uicontrol('Style', 'text', 'Unit', 'normalized', 'Position', [0 .5 .5 .5], 'String', 'Scale:', 'HorizontalAlign', 'left', 'Parent', hp);
    uicontrol('Style', 'text', 'Unit', 'normalized', 'Position', [.5 .5 .5 .5], 'String', 'Distance:', 'HorizontalAlign', 'left', 'Parent', hp);
    
    % Create two sliders for contrast and threshold.
    uicontrol('Style', 'slider', 'Min', 1.0, 'Max', 2.0, 'Unit', 'normalized', 'Parent', hp,...
        'Value', contrastAmount, 'Position', [0 0 .5 .5], 'Callback', @onContrastSlider);
    uicontrol('Style', 'slider', 'Min', 0, 'Max', 255, 'Unit', 'normalized', 'Parent', hp,...
        'Value', valDistance, 'Position', [.5 0 .5 .5], 'Callback', @onMaskSlider);
    
    
    uicontrol('Style', 'pushbutton', 'Unit', 'normalized', 'Position', [0.65 0.7 0.3 0.05], ...
        'String', 'Load', 'Callback', @do_load_Callback);
    uicontrol('Style', 'pushbutton', 'Unit', 'normalized', 'Position', [0.65 0.6 0.3 0.05], ...
        'String', 'Save', 'Callback', @do_save_Callback);

    function do_load_Callback(src, evt)
        % Use dialog to choose xls file
        [file, folder] = uigetfile({'*.xls';'*.*'},'Select the Ms.Excel file');
        if isequal(file,0) || isequal(folder,0)
            return;
        end
        inputFullFileName = fullfile(folder, file);

        %clear all;
        x=xlsread(inputFullFileName,1,'A2:A7');
        y=xlsread(inputFullFileName,1,'B2:B7');
        draw()
    end
    function do_save_Callback(src, evt)
        % Use dialog to choose xls file
        [file, folder] = uiputfile('lab3.xls','Save to the Ms.Excel file');
        if isequal(file,0) || isequal(folder,0)
            return;
        end
        outputFullFileName = fullfile(folder, file);

        xlswrite(outputFullFileName,Y,1,'D3');
    end
    
end
