%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This Script plots the Imperfections calculated from photogrammetry data
% and the manual readings.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
clc;
cd 'C:\DPadilla\PHD Research\Flexural Test Results';

%% LOAD DATA
load pgIMPFlex.mat %% Uses getImp3.m
load mIMPFlex.mat %% Uses getManImp2.m
svPth='C:\DPadilla\PHD Research\MatlabPublishing\Flex\ImpManVsPG\DifferentScale\';

% load pgIMPFlex2.mat %% Uses getImpB.m
% svPth='C:\DPadilla\PHD Research\MatlabPublishing\Flex\ImpManVsPG2\DifferentScale\';

fls  = {'IM1200GFC16','IM1200GFC25','IM800GFC13','IM800GFC21',...     % 1-4
        'IM1200DFC113','IM1200DFC216','IM800DFC112','IM800DFC226',... % 5-8
        'IM1000LFC123','IM1000LFC222','IM800LFC130','IM800LFC232',... % 9-12
        'IM1200GFM17','IM1200GFM235','IM800GFM14','IM800GFM22',...    % 13-16
        'IM1200DFM115','IM1200DFM214','IM800DFM125','IM800DFM227',... % 17-20
        'IM1000LFM121','IM1000LFM224','IM800LFM131','IM800LFM228'};   % 21-24

flsm = {'IMan120GFC16','IMan120GFC25','IMan080GFC13','IMan080GFC21',...     % 1-4
        'IMan120DFC113','IMan120DFC216','IMan080DFC112','IMan080DFC226',... % 5-8
        'IMan100LFC123','IMan100LFC222','IMan080LFC130','IMan080LFC232',... % 9-12
        'IMan120GFM17','IMan120GFM235','IMan080GFM14','IMan080GFM22',...    % 13-16
        'IMan120DFM115','IMan120DFM214','IMan080DFM125','IMan080DFM227',... % 17-20
        'IMan100LFM121','IMan100LFM224','IMan080LFM131','IMan080LFM228'};   % 21-24
 
webW=[12.000,12.000,8.000,8.000,12.000,12.000,8.000,8.000,10.000,10.000,8.000,8.000,...
      12.000,12.000,8.000,8.000,12.000,12.000,8.000,8.000,10.000,10.000,8.000,8.000]*25.4; % For d2 plot
% webW=10*webW./webW;

LL=[120,120,120,120,64,64,64,64,64,64,64,64,120,120,120,120,64,64,64,64,64,64,64,64];

tck=[0.099137,0.098950,0.098507,0.098483,0.101357,0.100707,0.070663,0.071050,0.045017,0.045343,0.034567,0.036522,...%Cyclic
     0.098930,0.099107,0.098533,0.098653,0.101653,0.100970,0.071208,0.071243,0.045383,0.045540,0.034730,0.034823];  %Mono
 
FEw=[1.674500,1.685500,1.688250,1.597750,2.592250,2.561500,2.489000,2.510250,1.937250,1.934750,1.966500,2.078750,...%Cyclic
     1.666250,1.686000,1.668175,1.587750,2.585500,2.597750,2.513000,2.557500,1.938750,1.937750,1.949000,1.967500];  %Mono

FWw=[1.698750,1.696250,1.674250,1.584250,2.556250,2.587750,2.533500,2.481250,1.980750,1.971500,1.962750,1.977750,...%Cyclic
     1.700750,1.655000,1.664750,1.571750,2.592750,2.615750,2.510500,2.509750,1.975500,1.981250,1.964250,1.939000];  %Mono
 
WW=[12.034750,12.033750,8.027500,8.029500,12.070000,12.068750,8.040500,8.039000,10.001250,10.014750,8.057750,8.020000,... %Cyclic
    12.042500,12.037000,8.031500,8.024500,12.078000,12.079500,8.042250,8.033750,10.020000,10.017000,8.050750,8.061000];   %Mono

space=' ';
spec2plot=[1,4,16,5,17,8,20,10,22,12,24];
% spec2plot=1;

for i=spec2plot
    
    %%%%%%%%%%%%%%%%%%
    %% Create Plots %
    %%%%%%%%%%%%%%%%%
    figGImp(i)=figure('Color','w','Position',[10 100 1.5*430 1.1*340],'PaperType','usletter','PaperOrientation','portrait','PaperPositionMode','auto'); 
    set(figGImp(i),'DefaultTextFontName', 'Arial')
    %%% Bow & Camber %%%
    hGimp(i,1)=subplot(1,2,1,'FontName','Arial','FontSize',8,'YColor','w');
    hold on;
    xlabel('\delta / L (x10^{-3})','Interpreter','Tex','FontSize',8);
    ylabel('z/L','Interpreter','Tex','Rotation',0,'FontSize',8,'Color','k');
    box off;
    title(fls{i},'FontName','Arial','FontSize',8);
    % Twist
    hGimp(i,2)=subplot(1,2,2,'FontName','Arial','FontSize',8,'YColor','w');
    hold on;
    xlabel('\phi (x10^{-3}rad)','Interpreter','Tex','FontSize',8);
    ylabel('z/L','Interpreter','Tex','Rotation',0,'FontSize',8,'Color','k');
    box off;
    title(fls{i},'FontName','Arial','FontSize',8);
    
    figLImp(i)=figure('Color','w','Position',[630 100 1.5*430 1.1*340],'PaperType','usletter','PaperOrientation','portrait','PaperPositionMode','auto'); 
    set(figLImp(i),'DefaultTextFontName', 'Arial')
    %%% Delta_1 %%%
    hLimp(i,1)=subplot(1,2,1,'FontName','Arial','FontSize',8,'YColor','w');
    hold on;
    xlabel('\delta_w / H (x10^{-3})','Interpreter','Tex','FontSize',8);
    ylabel('z/L','Interpreter','Tex','Rotation',0,'FontSize',8,'Color','k');
    box off;
    title(fls{i},'FontName','Arial','FontSize',8);
    %%% Delta_2 %%%
    hLimp(i,2)=subplot(1,2,2,'FontName','Arial','FontSize',8,'YColor','w','XMinorTick','off');
    hold on;
    xlabel('\delta_f / B (x10^{-3})','Interpreter','Tex','FontSize',8);
    ylabel('z/L','Interpreter','Tex','Rotation',0,'FontSize',8,'Color','k');
    box off;
    title(fls{i},'FontName','Arial','FontSize',8);
    set(axes('Position',get(hLimp(i,2),'Position'),'Color','none','YColor','w',... 
             'XDir','Reverse','XMinorTick','off','FontName','Arial','FontSize',8),'Parent',figLImp(i));
    hold on;
    box off;
    hLimp(i,3)=gca;
    %%%%%%%%%%%%%%%%%%%
    %% Photogrammetry %
    %%%%%%%%%%%%%%%%%%%
    RE  = evalin('caller',fls{i});
    dB  = [RE.Bow.Sweep{2},RE.Bow.Sweep{1}];
    dC  = [RE.Camber.Sweep{2},RE.Camber.Sweep{1}];
    Phi = [RE.Twist.Phi{2},RE.Twist.Phi{1}];
    dW  = [RE.IWeb.Imp{2},RE.IWeb.Imp{1}];
    dFE = [RE.ID2.Imp2{3},RE.ID2.Imp2{1}];
    dFW = [RE.ID2.Imp2{4},RE.ID2.Imp2{1}];
    
    mdB  = mean(dB(~isnan(dB(:,1)),1))*1;
    mdC  = mean(dC(~isnan(dC(:,1)),1))*1;
    mPhi = mean(Phi(~isnan(Phi(:,1)),1))*1;
    mdW  = mean(dW(~isnan(dW(:,1)),1))*1;
    mdFE = mean(dFE(~isnan(dFE(:,1)),1))*1;
    mdFW = mean(dFW(~isnan(dFW(:,1)),1))*1;
    
%     dB  =[detrend2(RE.Bow.Sweep{1},RE.Bow.Sweep{2},1),RE.Bow.Sweep{1}] + mdB*1;
%     dC  =[detrend2(RE.Camber.Sweep{1},RE.Camber.Sweep{2},1),RE.Camber.Sweep{1}] + mdC*1;
%     Phi =[detrend2(RE.Twist.Phi{1},RE.Twist.Phi{2},1),RE.Twist.Phi{1}] + mPhi*1;
%     dW  =[detrend2(RE.IWeb.Imp{1},RE.IWeb.Imp{2},1),RE.IWeb.Imp{1}] + mdW*1;
%     dFE  =[detrend2(RE.ID2.Imp2{1},RE.ID2.Imp2{3},1),RE.ID2.Imp2{1}] + mdFE*1;
%     dFW  =[detrend2(RE.ID2.Imp2{1},RE.ID2.Imp2{4},1),RE.ID2.Imp2{1}] + mdFW*1;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    %% Manual Imperfections %
    %%%%%%%%%%%%%%%%%%%%%%%%%
    REM=evalin('caller',flsm{i});
    % Method 1 (Not used because M1 data still retains the out of plumb trend):
    %         dBm =[detrend2(REM.M1.Bow{1},REM.M1.Bow{2},0),REM.M1.Bow{1}];
    %         Phim=[detrend2(REM.M1.Twist{1},REM.M1.Twist{2},0),REM.M1.Twist{1}];
    %         dWm =[detrend2(REM.M1.d1{1},REM.M1.d1{2},0),REM.M1.d1{1}];
    % Method 2:
    dBm  =[detrend2(REM.M2.Bow{1},REM.M2.Bow{2},0),REM.M2.Bow{1}];
    Phim =[detrend2(REM.M2.Twist{1},REM.M2.Twist{2},0),REM.M2.Twist{1}];
    dWm  =[detrend2(REM.M2.d1{1},REM.M2.d1{2},0),REM.M2.d1{1}];
    dfe  =[detrend2(REM.M1.d2E{1},REM.M1.d2E{2},0),REM.M1.d2E{1}];
    dfw  =[detrend2(REM.M1.d2W{1},REM.M1.d2W{2},0),REM.M1.d2W{1}];
    d2   =[REM.M1.d2{2},REM.M1.d2{1}];
    %     d2=[detrend2(REM.M1.d2{1},REM.M1.d2{2},0),REM.M1.d2{1}];

%     dBm  =[REM.M2.Bow{2},REM.M2.Bow{1} - mdB*0];
%     Phim =[REM.M2.Twist{2},REM.M2.Twist{1}];
%     dWm  =[REM.M2.d1{2},REM.M2.d1{1} - mdW*0];
%     dfe  =[REM.M1.d2E{2},REM.M1.d2E{1} + mdFE*0];
%     dfw  =[REM.M1.d2W{2},REM.M1.d2W{1} - mdFW*0];    
%     d2   =[REM.M1.d2{2},REM.M1.d2{1}];
    
    dBm=dBm(~isnan(dBm(:,1)),:);
    Phim=Phim(~isnan(Phim(:,1)),:);
    dWm=dWm(~isnan(dWm(:,1)),:);
    dfe=dfe(~isnan(dfe(:,1)),:);
    dfw=dfw(~isnan(dfw(:,1)),:);
    d2=d2(~isnan(d2(:,1)),:);
    
    %%%%%%%%%%%%%%%%
    %% Bow & Camber %
    %%%%%%%%%%%%%%%%
    set(0,'CurrentFigure',figGImp(i));
    plot(hGimp(i,1),1000*dB(:,1)./LL(i),dB(:,2)./LL(i),'b');
    plot(hGimp(i,1),1000*dC(:,1)./LL(i),dC(:,2)./LL(i),'r');
    plot(hGimp(i,1),1000*(dBm(:,1)+mdB)./LL(i),dBm(:,2)./LL(i),'LineStyle','-','Marker','.','Color',[0,0.6,0]);
    hl=legend(hGimp(i,1),{'\delta_{B} [pg]','\delta_{C} [pg]','\delta_{C} [m]'},'FontName','Arial','FontSize',8);
    plot(hGimp(i,1),[0,0],[0,1.05],'k');
    set(hGimp(i,1),'Ylim',[0,1.05]);
    set(hGimp(i,1),'Xlim',max(abs(get(hGimp(i,1),'Xlim')))*[-1,1]);
    % Move Y-axis
    yT=max(get(hLimp(i,1),'Ytick'))*(0:.1:1);yT=yT(2:length(yT));
    yL=strjust(num2str(yT'),'left');
    yL([1,3,5,7,9],:)=blanks(1);
    Xoff=diff(get(hGimp(i,1),'Xlim'))/50;
    for j=1:length(yT)
        plot(hGimp(i,1),Xoff*[-1,1],[yT(j) yT(j)],'k');
    end
    set(text(zeros(size(yT))-5*Xoff,yT,yL,'FontName','Arial','FontSize',8),'Parent',hGimp(i,1));
    set(hGimp(i,1),'YTick',[]);
	set(hGimp(i,1),'YTickLabel',[]);
    set(hl,'Location','Best');
	set(get(hGimp(i,1),'ylabel'),'Position',[0 1.05 1])
    delete(hl);% only for batch printing
    %%%%%%%%%
    % Twist %
    %%%%%%%%%
    plot(hGimp(i,2),1000*Phi(:,1),Phi(:,2)./LL(i),'r');
    plot(hGimp(i,2),1000*Phim(:,1),Phim(:,2)./LL(i),'LineStyle','-','Marker','.','Color',[0.3,0.3,0.3]);
    hl=legend(hGimp(i,2),{'\phi [pg]','\phi [m]'},'FontName','Arial','FontSize',8);
    plot(hGimp(i,2),[0,0],[0,1],'k');
    plot(hGimp(i,2),[0,0],[0,1.05],'k');
    set(hGimp(i,2),'Ylim',[0,1.05]);
    set(hGimp(i,2),'Xlim',max(abs(get(hGimp(i,2),'Xlim')))*[-1,1]);
    % Move Y-axis
    yT=max(get(hLimp(i,2),'Ytick'))*(0:.1:1);yT=yT(2:length(yT));
    yL=strjust(num2str(yT'),'left');
    yL([1,3,5,7,9],:)=blanks(1);
    Xoff=diff(get(hGimp(i,2),'Xlim'))/50;
    for j=1:length(yT)
        plot(hGimp(i,2),Xoff*[-1,1],[yT(j) yT(j)],'k');
    end
    set(text(zeros(size(yT))-5*Xoff,yT,yL,'FontName','Arial','FontSize',8),'Parent',hGimp(i,2));
    set(hGimp(i,2),'YTick',[]);
    set(hGimp(i,2),'YTickLabel',[]);
    set(hl,'Location','Best');
    set(get(hGimp(i,2),'ylabel'),'Position',[0 1.05 1])
    
    dLbl={['PG Max Values:','','',''];...
          [' ','L = ',num2str(25.4*LL(i),4),' (mm)'];...
          [' ','\delta_{B} / L = ',num2str(1000*max(abs(dB(:,1))/LL(i)),4),'(x10^{-3})'];...
	      [' ','\delta_{C} / L = ',num2str(1000*max(abs(dC(:,1))/LL(i)),4),'(x10^{-3})'];...
          [' ','\phi = ',num2str(1000*max(abs(Phi(:,1))),4),'(x10^{-3}rad)']};
    set(text(1.5*min(get(hGimp(i,2),'Xlim')),0.75*max(get(hGimp(i,2),'Ylim')),...
             {dLbl{1};dLbl{2};dLbl{3};dLbl{4};dLbl{5}},'EdgeColor','none',...
             'FontName','Arial','FontSize',8),'Parent',hGimp(i,2));
         
    dLbl={['Manual Max Values:','','',''];...
          [' ','\delta_{B} / L = ',num2str(1000*max(abs(dBm(:,1)+mdB)/LL(i)),4),'(x10^{-3})'];...
          [' ','\phi = ',num2str(1000*max(abs(Phim(:,1))),4),'(x10^{-3}rad)']};
    set(text(1.5*min(get(hGimp(i,2),'Xlim')),0.25*max(get(hGimp(i,2),'Ylim')),...
             {dLbl{1};dLbl{2};dLbl{3}},'EdgeColor','none',...
             'FontName','Arial','FontSize',8),'Parent',hGimp(i,2));       
	delete(hl);% only for batch printing
    %%%%%%%%%%%%%
    % d2E & d2W %
    %%%%%%%%%%%%%
    set(0,'CurrentFigure',figLImp(i));
    hp(1)=plot(hLimp(i,2),-1000*dFE(:,1)./FEw(i)-0.0*webW(i),dFE(:,2)./LL(i),'b');
    hp(2)=plot(hLimp(i,2),-1000*dFE(:,1)./FEw(i)-0.0*webW(i),dFE(:,2)./LL(i),'r');
    hp(3)=plot(hLimp(i,2),-1000*dFE(:,1)./FEw(i)-0.0*webW(i),dFE(:,2)./LL(i),'LineStyle','-','Marker','.','Color',[0,0.6,0]);
    hp(4)=plot(hLimp(i,2),-1000*dFE(:,1)./FEw(i)-0.0*webW(i),dFE(:,2)./LL(i),'LineStyle','-','Marker','.','Color',[0.3,0.3,0.3]);
    hl=legend(hLimp(i,2),{'\delta_{fe} [pg]','\delta_{fw} [pg]','\delta_{fe} [m]','\delta_{fw} [m]'},'FontName','Arial','FontSize',8);
    delete(hp);
    plot(hLimp(i,2),-0*webW(i)*[0.5,0.5],[0,1.05],'Color',0.6*[1,1,1],'LineStyle','-');
    plot(hLimp(i,3),+0*webW(i)*[0.5,0.5],[0,1.05],'Color',0.6*[1,1,1],'LineStyle','-');
    plot(hLimp(i,2),-1000*dFE(:,1)./FEw(i)-0.0*webW(i),dFE(:,2)./LL(i),'b');
    plot(hLimp(i,3),+1000*dFW(:,1)./FWw(i)+0.0*webW(i),dFW(:,2)./LL(i),'r');
    plot(hLimp(i,2),1000*(dfe(:,1)-mdFE)./FEw(i)-0.0*webW(i),dfe(:,2)./LL(i),'LineStyle','-','Marker','.','Color',[0,0.6,0]);
    plot(hLimp(i,3),1000*(dfw(:,1)+mdFW)./FWw(i)+0.0*webW(i),dfw(:,2)./LL(i),'LineStyle','-','Marker','.','Color',[0.3,0.3,0.3]);
    x4=get(hLimp(i,3),'Xlim');
    x2=get(hLimp(i,2),'Xlim');
    xext=max([ceil(max([max(abs(dFE(:,1)./FEw(i))),max(abs(dFW(:,1)./FWw(i)))])*1000/10)*10,...
              ceil(max([max(abs((dfe(:,1)-mdFE)./FEw(i))),max(abs((dfw(:,1)+mdFW)./FWw(i)))])*1000/10)*10]);
    axOff=max([webW(i),3*xext]);
    set(hLimp(i,2),'Xlim',[-xext-axOff,xext]);
    set(hLimp(i,3),'Xlim',[-xext-axOff,xext]);
    % Fix X-axes
    if xext==0
        xT=(-1:1);
    else
        xT=xext*(-1:.25:1);
    end
    xL=char(strjust(num2str(xT(xT<0)'),'center'),...
               [space(ones(sum(xT>=0),1)),strjust(num2str(xT(xT>=0)'),'center')]);
    xL([2,4,6,8],:)=blanks(1);
    set(hLimp(i,2),'XTick',xT);
    set(hLimp(i,2),'XTickLabel',xL);
    set(hLimp(i,3),'XTick',xT);
    set(hLimp(i,3),'XTickLabel',xL);
    plot(hLimp(i,2),-axOff*[0.5,0.5],[0,1.05],'k'); 
    set([hLimp(i,2),hLimp(i,3)],'Ylim',[0,1.05]);
    % Move Y-axis
    yT=max(get(hLimp(i,3),'Ytick'))*(0:.1:1);yT=yT(2:length(yT));
    yL=strjust(num2str(yT'),'left');
    yL([1,3,5,7,9],:)=blanks(1);
    Xoff=diff(get(hLimp(i,2),'Xlim'))/50;
    for j=1:length(yT)
        plot(hLimp(i,2),Xoff*[-1,1]-axOff*[0.5,0.5],[yT(j) yT(j)],'k');
    end
    set(text(zeros(size(yT))-5*Xoff-axOff*0.5,yT,yL,'FontName','Arial','FontSize',8),'Parent',hLimp(i,2));
    set(hLimp(i,2),'YTick',[]);
    set(hLimp(i,2),'YTickLabel',[]);
    set(hLimp(i,3),'YTick',[]);
    set(hLimp(i,3),'YTickLabel',[]);
    set(hl,'Location','Best');
    set(get(hLimp(i,2),'ylabel'),'Position',[-0.5*axOff 1.05 1])
	delete(hl);% only for batch printing
    % plot(hLimp(i,2),0.5*(-1000*dFE(:,1)./FEw(i)+1000*dFW(:,1)./FWw(i))-max([webW(i),2.5*xext])*0.5,dFW(:,2)./LL(i),'k-');
    % plot(hLimp(i,2),0.5*(+1000*(dfe(:,1)-mdFE)./FEw(i)+1000*(dfw(:,1)+mdFW)./FWw(i))-axOff*0.5,dfw(:,2)./LL(i),'k.-');
    % plot(hLimp(i,2),1000*(d2(:,1)+mdFE+mdFW)./(0.5.*(FEw(i)+FWw(i)))-axOff*0.5,d2(:,2)./LL(i),'Color',0.6*[1,1,1],'Marker','.');
    %%%%%%
    % d1 %
    %%%%%%
    plot(hLimp(i,1),1000*dW(:,1)./WW(i),dW(:,2)./LL(i),'b');
    plot(hLimp(i,1),1000*(dWm(:,1)+mdW)./WW(i),dWm(:,2)./LL(i),'LineStyle','-','Marker','.','Color',[0,0.6,0]);
    hl=legend(hLimp(i,1),{'\delta_w [pg]','\delta_w [m]'},'FontName','Arial','FontSize',8);
    plot(hLimp(i,1),[0,0],[0,1],'k');
    plot(hLimp(i,1),[0,0],[0,1.05],'k');
    set(hLimp(i,1),'Ylim',[0,1.05]);
    set(hLimp(i,1),'Xlim',max(abs(get(hLimp(i,1),'Xlim')))*[-1,1]);
    % Move Y-axis
    yT=max(get(hLimp(i,1),'Ytick'))*(0:.1:1);yT=yT(2:length(yT));
    yL=strjust(num2str(yT'),'left');
    yL([1,3,5,7,9],:)=blanks(1);
    Xoff=diff(get(hLimp(i,1),'Xlim'))/50;
    for j=1:length(yT)
        plot(hLimp(i,1),Xoff*[-1,1],[yT(j) yT(j)],'k');
    end
    set(text(zeros(size(yT))-5*Xoff,yT,yL,'FontName','Arial','FontSize',8),'Parent',hLimp(i,1));
    set(hLimp(i,1),'YTick',[]);
    set(hLimp(i,1),'YTickLabel',[]);
    set(hl,'Location','Best');
    set(get(hLimp(i,1),'ylabel'),'Position',[0 1.05 1])
    dLbl={['PG Max Values:','','',''];...
          [' ','H  = ',num2str(25.4*WW(i),4),' (mm)'];...
          [' ','B_e = ',num2str(25.4*FEw(i),4),' (mm)'];...
          [' ','B_w = ',num2str(25.4*FWw(i),4),' (mm)'];...
          [' ','\delta_w / H = ',num2str(1000*max(abs(dW(:,1))/WW(i)),4),'(x10^{-3})'];...
	      [' ','\delta_{fe} / B_e = ',num2str(1000*max(abs(dFE(:,1))/FEw(i)),4),'(x10^{-3})'];...
          [' ','\delta_{fw} / B_w = ',num2str(1000*max(abs(dFW(:,1))/FWw(i)),4),'(x10^{-3})']};
    set(text(1.5*min(get(hLimp(i,2),'Xlim')),0.75*max(get(hLimp(i,2),'Ylim')),...
             {dLbl{1};dLbl{2};dLbl{3};dLbl{4};dLbl{5};dLbl{6};dLbl{7}},'EdgeColor','none',...
             'FontName','Arial','FontSize',8),'Parent',hLimp(i,2));
    dLbl={['Manual Max Values:','','',''];...
          [' ','\delta_w / H = ',num2str(1000*max(abs(dWm(:,1)+mdW)/WW(i)),4),'(x10^{-3})'];...
	      [' ','\delta_{fe} / B_e = ',num2str(1000*max(abs(dfe(:,1)-mdFE)/FEw(i)),4),'(x10^{-3})'];...
          [' ','\delta_{fw} / B_w = ',num2str(1000*max(abs(dfw(:,1)+mdFW)/FWw(i)),4),'(x10^{-3})']};
    set(text(1.5*min(get(hLimp(i,2),'Xlim')),0.25*max(get(hLimp(i,2),'Ylim')),...
             {dLbl{1};dLbl{2};dLbl{3};dLbl{4}},'EdgeColor','none',...
             'FontName','Arial','FontSize',8),'Parent',hLimp(i,2));
    delete(hl);% only for batch printing
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Print EPS format using printeps.m %%%
    if ~exist(svPth,'dir')
        mkdir(svPth);
    end
    printeps(figGImp(i),strcat('G',fls{i}),svPth,'Arial')
    printeps(figLImp(i),strcat('L',fls{i}),svPth,'Arial')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     
%     pause;  
end
% Close figures
if ~strcmp(questdlg('DO YOU WANT TO KEEP THE PLOTS OPEN?','????','Yes','No','No'),'Yes')
    close([figLImp(figLImp~=0),figGImp(figGImp~=0)])
end

 