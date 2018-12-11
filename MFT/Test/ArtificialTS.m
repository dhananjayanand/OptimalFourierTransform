classdef ArtificialTS
    % Class for synthesizing a time series from sinusoids and noise
    properties
        Name            % string name of the Time Series
        Description     % string describing the TS
        
        T0              % double starting time
        Extent          % double TS duration in seconds
        nSamples        % number of samples in the time series (Sample Rate = nSamples/Extent)
        
        Valid           % [1..nSinusoids] array of booleans (invalid if caller enters bad values)
        Freqs           % [1..nSinusoids] array of sinusoid frequencies
        Amps            % [1..nSinusoids] array of sinusoid amplitudes
        Phases          % [1..nSinusoids] array of phase angles (in radians)
        
        NoiseUniformLow % double Uniform distribution noise lowest value
        NoiseUniformHi  % double Uniform distribution noise highest value
        NoiseGaussMean  % double noise mean value
        NoiseGaussSD    % double noise standard deviation
        
        Ts              % Time Series
        time            % Time vector
    end
    
    methods
        %Constructor
        function ArtTS = ArtificialTS( ...
                Name, ...
                Description, ...
                T0, ...
                Extent, ...
                nSamples, ...
                Freqs, ...
                Amps, ...
                Phases, ...
                NoiseUniformLow, ...
                NoiseUniformHi, ...
                NoiseGaussMean, ...
                NoiseGaussSD ...
                )
            if nargin > 0
               ArtTS.Name = Name;
               ArtTS.Description = Description;
               ArtTS.T0 = T0;
               ArtTS.Extent = Extent;
               ArtTS.nSamples = nSamples;
               ArtTS.Freqs = Freqs;
               ArtTS.Amps = Amps;
               ArtTS.Phases = Phases;
               ArtTS.NoiseUniformLow = NoiseUniformLow;
               ArtTS.NoiseUniformHi = NoiseUniformHi;
               ArtTS.NoiseGaussMean = NoiseGaussMean;
               ArtTS.NoiseGaussSD = NoiseGaussSD;
                              
               ArtTS.Valid = ArtTS.checkValid;
               ArtTS.time = ArtTS.makeTime;    % create the time vector
               ArtTS.Ts = ArtTS.makeTS();      % create the time series                                     
            end            
        end
       
        function Valid = checkValid(ArtTS)
            Valid = false;
            if length(ArtTS.Freqs) < 1
                error ('ArtTS.Freqs must have 1 or more frequencies')
            end
%             if length(ArtTS.Freqs) ~= length(ArtTS.Amps)
%                 error ('ArtTS.Freqs and ArtTS.Amps must be the same size')
%             end
%             if length(ArtTS.Freqs) ~= length(ArtTS.Phases)
%                 error ('ArtTS.Freqs and ArtTS.Phases must be the same size')
%             end
            if ArtTS.nSamples < 1
                error ('ArtTS.nSamples must be grater than 0')
            end
            if ArtTS.Extent <= 0
                error ('ArtTS.Extent must be greater than 0')
            end
            Valid = true;
        end
        
        function ArtTS = makeTime(ArtTS)
            ArtTS.time = (ArtTS.T0 : (ArtTS.Extent)/(ArtTS.nSamples):ArtTS.Extent-ArtTS.Extent/ArtTS.nSamples);
        end
                        
        function [ArtTS] = makeTS(ArtTS)
            ArtTS.Valid = ArtTS.checkValid;
            if length(ArtTS.time) < 1
                ArtTS.time = ArtTS.makeTime;
            end
            x = zeros(1,length(ArtTS.time));
            for i = 1:length(ArtTS.Freqs)
                x = x + ArtTS.Amps(i)*cos(2*pi*ArtTS.Freqs(i)*ArtTS.time - ArtTS.Phases(i));
            end
            
            % add noise
            bNoiseOn = false;
            NoiseUniformRange = ArtTS.NoiseUniformHi - ArtTS.NoiseUniformLow;
            if NoiseUniformRange ~= 0
                bNoiseOn = true;
            end
            if ArtTS.NoiseGaussSD > 0
                bNoiseOn = true;
            end
            if bNoiseOn
                x = x ...
                    + ArtTS.NoiseGaussSD*randn(size(x))...
                    + ArtTS.NoiseGaussMean ...
                    + NoiseUniformRange * rand(size(x)) ...
                    + ArtTS.NoiseUniformLow;
            end
               
            ArtTS.Ts = x;                
        end
  

    % set methods
    function ArtTS = set.Name(ArtTS,str)
        if ischar(str)
            ArtTS.Name = str;
        else
            error('ArtTS.Name must be a string')
        end
    end
    
    function ArtTS = set.Description(ArtTS,str)
        if ischar(str)
            ArtTS.Description = str;
        else
            error('ArtTS.Description must be a string')
        end
    end
    
    function ArtTS = set.T0(ArtTS,dbl)
        if isscalar(dbl) && isreal(dbl)
            ArtTS.T0 = dbl;
        else
            error('ArtTS.T0 must be a real scalar value');
        end
    end
    
    function ArtTS = set.Extent(ArtTS,dbl)
        if isscalar(dbl) && isreal(dbl)
            ArtTS.Extent = dbl;
        else
            error('ArtTS.Extent must be a real scalar value');
        end
    end
    
    function ArtTS = set.nSamples(ArtTS,int)
        if isscalar(int) && isinteger(int) && int > 0
            ArtTS.nSamples = double(int);
        else
            error('ArtTS.nSamples must be a positive integer scalar value');
        end
    end
    
    function ArtTS = set.Freqs(ArtTS,dbl)
        if  isreal(dbl)
            ArtTS.Freqs = dbl;
        else
            error('ArtTS.Freqs must be an array of real values');
        end
    end
    
    function ArtTS = set.Amps(ArtTS,dbl)
        if  isreal(dbl)
            ArtTS.Amps = dbl;
        else
            error('ArtTS.Amps must be an array of real values');
        end
    end
    
    function ArtTS = set.Phases(ArtTS,dbl)
        if  isreal(dbl)
            ArtTS.Phases = dbl;
        else
            error('ArtTS.Phases must be an array of real values');
        end
    end
 
    end
    
%    methods  (Access=private)
%         
%         function time = makeTime(ArtTS)
%             time = (ArtTS.T0:ArtTS.Extent/ArtTS.nSamples:ArtTS.Extent);
%         end
%     end
        
    
end
                             