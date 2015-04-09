function BER_vs_SNR_OFDM_with_BPSK(varargin)
% Plot the relationship between the bit-error-rate (BER) and
% signal-to-noise ratio (SNR) for OFDM system with BPSK modulation method
% BER_vs_SNR_OFDM_with_BPSK(ParameterName1, ParameterValue1,...
%                           ParameterName2, ParameterValue2,...)
% Parameters:
%   BitPerSymbol: Bits per symbol, default is 1
%   NoSymbol: Number of symbols, default is 10^6
%   NoSub: Number of subcarriers, default is 64
%   LenCyclic: Length of cyclic prefix, default is 16
%   SNR: SNR range for simulations, default is 0:2:30
%   BPSKNum: Number of phase for BPSK, default is 2. Mapping the bit 0 and
%            the bit 1 as -1 and 1
% Example:
%   BER_vs_SNR_OFDM_with_BPSK('NoSymbols',10^6,'SNR',0:15);

    %% Input parametes
    % default parameters
    Detect=0;
    BitPerSymbol=1; % bit/symbol
    NoSymbols=10^6; % symbol numbers
    NoSub=64; % Subcarries number
    LenCyclic=16; % Length of Cyclic prefix
    SNR=30:-2:0;
    BPSKNum=2; % Phase number of BPSK
    % User's parameter
    for i=1:2:length(varargin)
        switch lower(varargin{i})
            case 'detect'
                Detect=varargin{i+1};
            case 'bitpersymbol'
                BitPerSymbol=varargin{i+1};
            case lower('NoSymbols')
                NoSymbols=varargin{i+1};
            case lower('NoSub')
                NoSub=varargin{i+1};
            case lower('LenCyclic')
                LenCyclic=varargin{i+1};
            case lower('SNR')
                SNR=varargin{i+1};
            case lower('BPSKNum')
                BPSKNum=varargin{i+1};
            otherwise
                disp(['Unknown input: ' varargin{i}])
                return
        end
    end
    %% Transmiter Side
    % Gnerate Data Sequence
    NoBits=NoSymbols*BitPerSymbol;
    data=randi([0 1],1,NoBits);
    % Separate data to different path
    path=reshape(data,NoSub,NoBits/NoSub);
    % BPSK
    BPSKpath=dpskmod(path,BPSKNum);
    % ifft
    ifftpath=ifft(BPSKpath,NoSub);
    % Add cyclic prefix
    Tranpath=zeros(size(ifftpath,1)+LenCyclic,size(ifftpath,2));
    Tranpath(1:LenCyclic,:)=ifftpath((end-LenCyclic+1):end,:);
    Tranpath((1+LenCyclic):end,:)=ifftpath;
    %% Transmit and Receiver
    % Transmit
    BER=zeros(size(SNR));
    for SNRNo=1:length(SNR)
        %% Channel Side
        % Add additive Gaussian white noise
        Repath=awgn(Tranpath,SNR(SNRNo),'measured');
        %% Receiver Side
        % Detect signal
        if Detect
            Detectpath=zeros(size(Repath));
            for i=1:25:size(Repath,2)
                disp(i)
                Resignal=Repath(:,i:(i+25-1));
                Resignal=reshape(Resignal,size(Resignal,1)*size(Resignal,2),1);
                compare=reshape(Tranpath,size(Resignal,1)*size(Resignal,2),size(Tranpath,2)/25);
                error=sum(abs(Resignal(:,ones(1,size(compare,2)))-compare).^2,1);
                [~,I]=min(error);
                Detectpath(:,((I-1)*25+1):((I-1)*25+25))=Repath(:,i:(i+25-1));
            end
        else
            Detectpath=Repath;
        end
        % Remove cyclic prefix
        ReCyclicpath=Detectpath((1+LenCyclic):end,:);
        % fft
        fftpath=fft(ReCyclicpath,NoSub);
        % inverse BPSK
        demodpath=dpskdemod(fftpath,BPSKNum);
        % Reform
        demodata=reshape(demodpath,1,NoBits);
        %% Calculate BER
        BER(SNRNo)=sum(xor(demodata,data))/NoBits;
        disp(['SNR: ' num2str(SNR(SNRNo)) '. BER: ' num2str(BER(SNRNo))])
    end
    %% Plot result
    figure;
    semilogy(SNR,BER,'--dr','linewidth',2);
    grid on
    xlabel('SNR');
    ylabel('BER');
    title('Simulation Results')
end