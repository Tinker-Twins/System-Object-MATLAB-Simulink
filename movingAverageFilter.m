classdef movingAverageFilter < matlab.System
    % Unweighted moving average filter of 1- or 2D input.
    
    % Public, tunable properties
    properties(Nontunable)
        % WindowLength Moving window length
        WindowLength (1,1){mustBeInteger,mustBePositive} = 5
    end

    % Pre-computed constants
    properties(Access = private, Nontunable)
        pCoefficients;
    end
    
    properties(Access = private)
        State;
        pNumChannels = -1;
    end
    
    methods
        function obj = movingAverageFilter(varargin)
            % Support name-value pair arguments when constructing object
            setProperties(obj,nargin,varargin{:})
        end
    end
    
    methods(Access = protected)
        function setupImpl(obj,x)
            % Perform one-time calculations, such as computing constants
            obj.pNumChannels = size(x,2);
            obj.pCoefficients = ones(1,obj.WindowLength)/obj.WindowLength;
            obj.State = zeros(obj.WindowLength-1,obj.pNumChannels,'like',x);
        end

        function y = stepImpl(obj,u)
            % Implement algorithm. Calculate y as a function of input u and
            % states.
            [y,obj.State] = filter(obj.pCoefficients,1,u,obj.State);
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
            obj.State(:) = 0;
        end
        
        function validateInputsImpl(~, u)
            validateattributes(u,{'double','single'}, {'2d',...
                'nonsparse'},'','input');
        end
        
        function s = saveObjectImpl(obj)
            s = saveObjectImpl@matlab.System(obj);
            if isLocked(obj)
                s.pCoefficients = obj.pCoefficients;
                s.pNumChannels = obj.pNumChannels;
                s.State = obj.State;
            end
        end
        
        function loadObjectImpl(obj,s,wasLocked)
            if wasLocked
                obj.pCoefficients = s.pCoefficients;
                obj.pNumChannels = s.pNumChannels;
                obj.State = s.State;
            end
            loadObjectImpl@matlab.System(obj,s,wasLocked);
        end
        
    end
end