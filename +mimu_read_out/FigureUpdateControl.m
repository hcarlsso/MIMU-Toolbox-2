classdef FigureUpdateControl < handle
    properties
        time;
        Ts;
    end    
    methods
        function obj = FigureUpdateControl(Ts)
            obj.time = tic; % Start timer
            obj.Ts = Ts; % Sampling time
        end
        function obj = callback(obj, ~, ~)
            b = toc(obj.time); % Check timer
            if b > obj.Ts
                drawnow % update screen
                obj.time = tic;
            end
        end
    end
end