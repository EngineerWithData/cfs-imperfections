%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This Script plots the Imperfections calculated from photogrammetry data
% and the manual readings.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
clc;
cd 'C:\DPadilla\PHD Research\Axial Test Results';

%% LOAD DATA
% load IMPERFECT3.mat %%% Extract the global component from dW
% % load IMPERFECT.mat %%% d1 is the distance of line 5 to web flat plane
% load ManualIMPERFECT2.mat % Uses pInterp

% load pgIMPERFECT.mat %% Uses getImp3.m
load mIMPERFECT.mat %% Uses getManImp2.m
% svPth='C:\DPadilla\PHD Research\MatlabPublishing\ImpManVsPG\DifferentScale\';

% load ManualIMPERFECT.mat 
% load IMPERFECT2.mat  %2 Top and Bottom most points deleted

load pgIMPERFECT2.mat %% Uses getImpB.m 
svPth='C:\DPadilla\PHD Research\MatlabPublishing\ImpManVsPGv2\DifferentScale\';

fls={'IM600GAC122','IM600GAC225','IM362GAC117','IM362GAC219',...% 1-4
     'IM600DAC113','IM600DAC216','IM362DAC111','IM362DAC212',...% 5-8
     'IM600LAC14','IM600LAC23','IM362LAC18','IM362LAC25',...    % 9-12
     'IM600GAM126','IM600GAM227','IM362GAM129','IM362GAM228',...% 13-16
     'IM600DAM114','IM600DAM215','IM362DAM19','IM362DAM210',... % 17-20
     'IM600LAM12','IM600LAM21','IM362LAM16','IM362LAM27'};      % 21-24

flsm={'IMan600GAC122','IMan600GAC225','IMan362GAC117b','IMan362GAC219',...   % 1-4
      'IMan600DAC113','IMan600DAC216','IMan362DAC111','IMan362DAC212',...    % 5-8
      'IMan600LAC14','IMan600LAC23','IMan362LAC18','IMan362LAC25b',...       % 9-12
      'IMan600GAM1a26','IMan600GAM2a27','IMan362GAM1a29','IMan362GAM2a28',...% 13-16
      'IMan600DAM114','IMan600DAM215','IMan362DAM19','IMan362DAM210',...     % 17-20
      'IMan600LAM12','IMan600LAM21','IMan362LAM16','IMan362LAM27'};          % 21-24
 
webW=[6.000,6.000,3.625,3.625,6.000,6.000,3.625,3.625,6.000,6.000,3.625,3.625,...
      6.000,6.000,3.625,3.625,6.000,6.000,3.625,3.625,6.000,6.000,3.625,3.625]*25.4; % For d2 plot
% webW=10*webW./webW; 
LL=[90,90,90,90,24,24,24,24,12,12,12,12,90,90,90,90,24,24,24,24,12,12,12,12];

tck=[0.102337,0.101703,0.071530,0.071500,0.070873,0.070873,0.071193,0.071193,0.033730,0.033730,0.056787,0.056787,...%Cyclic
     0.101794,0.102167,0.071589,0.071822,0.070873,0.070873,0.071833,0.071833,0.033730,0.033730,0.056787,0.056787]; %Mono
 
FEw=[1.40900,1.40325,1.35275,1.35600,1.35450,1.37475,1.35705,1.35400,1.64925,1.64825,1.65450,1.63225,...%Cyclic
     1.42375,1.42000,1.35650,1.35900,1.36825,1.37175,1.36825,1.35725,1.65600,1.65200,1.63725,1.66400];  %Mono
FWw=[1.41775,1.41450,1.32475,1.31675,1.34475,1.32950,1.32080,1.33450,1.64100,1.63525,1.63900,1.66000,...%Cyclic
     1.40975,1.40675,1.31800,1.31100,1.32950,1.32925,1.31725,1.33450,1.64300,1.63400,1.66425,1.63625];  %Mono
WW=[5.98800,6.00450,3.67450,3.67325,6.01300,6.00400,3.66875,3.67050,5.92900,5.91625,3.65075,3.64675,... %Cyclic
    6.01200,5.99250,3.67375,3.66875,6.01100,6.01125,3.70025,3.67125,5.90250,5.91700,3.66425,3.64950];   %Mono

space=' ';
spec2plot=[4,8,20,11,24,6,18,10,22];
% spec2plot = 4;
for i=spec2plot
    
    %%%%%%%%%%%%%%%%%%
    %% Create Plots %
    %%%%%%%%%%%%%%%%%
    figGImp(i)=figure('Color','w','Position',[10 100 1.5*430 1.1*340],'PaperType','usletter','PaperOrientation','portrait','PaperPositionMode','auto'); 
    set(figGImp(i),'DefaultTextFontName', 'Arial')
    %%% Bow & Camber %%%
    hGimp(i,1)=subplot(1,2,1,'FontName','Arial','FontSize',6,'YColor','w');
    hold on;
    xlabel('\delta / L (x10^{-3})','Interpreter','Tex','FontSize',6);
    ylabel('z/L','Interpreter','Tex','Rotation',0,'FontSize',6,'Color','k');
    box off;
    ht(1) = title(fls{i}(3:9),'FontName','Arial','FontSize',6);       
    % Twist
    hGimp(i,2)=subplot(1,2,2,'FontName','Arial','FontSize',6,'YColor','w');
    hold on;
    xlabel('\phi (x10^{-3}rad)','Interpreter','Tex','FontSize',6);
    ylabel('z/L','Interpreter','Tex','Rotation',0,'FontSize',6,'Color','k');
    box off;
    ht(2) = title(fls{i}(3:9),'FontName','Arial','FontSize',6);
        
    figLImp(i)=figure('Color','w','Position',[630 100 1.5*430 1.1*340],'PaperType','usletter','PaperOrientation','portrait','PaperPositionMode','auto'); 
    set(figLImp(i),'DefaultTextFontName', 'Arial')
    %%% Delta_1 %%%
    hLimp(i,1)=subplot(1,2,1,'FontName','Arial','FontSize',6,'YColor','w');
    hold on;
    xlabel('\delta_w / H (x10^{-3})','Interpreter','Tex','FontSize',6);
    ylabel('z/L','Interpreter','Tex','Rotation',0,'FontSize',6,'Color','k');
    box off;
    ht(3) = title(fls{i}(3:9),'FontName','Arial','FontSize',6);
    %%% Delta_2 %%%
    hLimp(i,2)=subplot(1,2,2,'FontName','Arial','FontSize',6,'YColor','w','XMinorTick','off');
    hold on;
    xlabel('\delta_f / B (x10^{-3})','Interpreter','Tex','FontSize',6);
    ylabel('z/L','Interpreter','Tex','Rotation',0,'FontSize',6,'Color','k');
    box off;
    ht(4) = title(fls{i}(3:9),'FontName','Arial','FontSize',6);    
    set(axes('Position',get(hLimp(i,2),'Position'),'Color','none','YColor','w',... 
             'XDir','Reverse','XMinorTick','off','FontName','Arial','FontSize',6),'Parent',figLImp(i));
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
    mdW  = mean(dW(~isnan(dW(:,1)),1))*1;
    mdFE = mean(dFE(~isnan(dFE(:,1)),1))*1;
    mdFW = mean(dFW(~isnan(dFW(:,1)),1))*1;
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
    hl=legend(hGimp(i,1),{'\delta_{B} [pg]','\delta_{C} [pg]','\delta_{C} [m]'},'FontName','Arial','FontSize',6); legend(hGimp(i,1),'boxoff')
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
    set(text(zeros(size(yT))-5*Xoff,yT,yL,'FontName','Arial','FontSize',6),'Parent',hGimp(i,1));
    set(hGimp(i,1),'YTick',[]);
	set(hGimp(i,1),'YTickLabel',[]);
    set(hl,'Location','Best');
	set(get(hGimp(i,1),'ylabel'),'Position',[0 1.05 1])
%     delete(hl);% only for batch printing
    %%%%%%%%%
    % Twist %
    %%%%%%%%%
    plot(hGimp(i,2),1000*Phi(:,1),Phi(:,2)./LL(i),'r');
    plot(hGimp(i,2),1000*Phim(:,1),Phim(:,2)./LL(i),'LineStyle','-','Marker','.','Color',[0.3,0.3,0.3]);
    hl=legend(hGimp(i,2),{'\phi [pg]','\phi [m]'},'FontName','Arial','FontSize',6); legend(hGimp(i,2),'boxoff')
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
    set(text(zeros(size(yT))-5*Xoff,yT,yL,'FontName','Arial','FontSize',6),'Parent',hGimp(i,2));
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
             'FontName','Arial','FontSize',6),'Parent',hGimp(i,2));
         
    dLbl={['Manual Max Values:','','',''];...
          [' ','\delta_{B} / L = ',num2str(1000*max(abs(dBm(:,1)+mdB)/LL(i)),4),'(x10^{-3})'];...
          [' ','\phi = ',num2str(1000*max(abs(Phim(:,1))),4),'(x10^{-3}rad)']};
    set(text(1.5*min(get(hGimp(i,2),'Xlim')),0.25*max(get(hGimp(i,2),'Ylim')),...
             {dLbl{1};dLbl{2};dLbl{3}},'EdgeColor','none',...
             'FontName','Arial','FontSize',6),'Parent',hGimp(i,2));       
% 	delete(hl);% only for batch printing
    %%%%%%%%%%%%%
    % d2E & d2W %
    %%%%%%%%%%%%%
    set(0,'CurrentFigure',figLImp(i));
    hp(1)=plot(hLimp(i,2),-1000*dFE(:,1)./FEw(i)-0.0*webW(i),dFE(:,2)./LL(i),'b');
    hp(2)=plot(hLimp(i,2),-1000*dFE(:,1)./FEw(i)-0.0*webW(i),dFE(:,2)./LL(i),'r');
    hp(3)=plot(hLimp(i,2),-1000*dFE(:,1)./FEw(i)-0.0*webW(i),dFE(:,2)./LL(i),'LineStyle','-','Marker','.','Color',[0,0.6,0]);
    hp(4)=plot(hLimp(i,2),-1000*dFE(:,1)./FEw(i)-0.0*webW(i),dFE(:,2)./LL(i),'LineStyle','-','Marker','.','Color',[0.3,0.3,0.3]);
    hl=legend(hLimp(i,2),{'\delta_{fe} [pg]','\delta_{fw} [pg]','\delta_{fe} [m]','\delta_{fw} [m]'},'FontName','Arial','FontSize',6); legend(hLimp(i,2),'boxoff')
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
    set(text(zeros(size(yT))-5*Xoff-axOff*0.5,yT,yL,'FontName','Arial','FontSize',6),'Parent',hLimp(i,2));
    set(hLimp(i,2),'YTick',[]);
    set(hLimp(i,2),'YTickLabel',[]);
    set(hLimp(i,3),'YTick',[]);
    set(hLimp(i,3),'YTickLabel',[]);
    set(hl,'Location','Best');
    set(get(hLimp(i,2),'ylabel'),'Position',[-0.5*axOff 1.05 1])
% 	delete(hl);% only for batch printing
    % plot(hLimp(i,2),0.5*(-1000*dFE(:,1)./FEw(i)+1000*dFW(:,1)./FWw(i))-max([webW(i),2.5*xext])*0.5,dFW(:,2)./LL(i),'k-');
    % plot(hLimp(i,2),0.5*(+1000*(dfe(:,1)-mdFE)./FEw(i)+1000*(dfw(:,1)+mdFW)./FWw(i))-axOff*0.5,dfw(:,2)./LL(i),'k.-');
    % plot(hLimp(i,2),1000*(d2(:,1)+mdFE+mdFW)./(0.5.*(FEw(i)+FWw(i)))-axOff*0.5,d2(:,2)./LL(i),'Color',0.6*[1,1,1],'Marker','.');
    %%%%%%
    % d1 %
    %%%%%%
    plot(hLimp(i,1),1000*dW(:,1)./WW(i),dW(:,2)./LL(i),'b');
    plot(hLimp(i,1),1000*(dWm(:,1)+mdW)./WW(i),dWm(:,2)./LL(i),'LineStyle','-','Marker','.','Color',[0,0.6,0]);
    hl=legend(hLimp(i,1),{'\delta_w [pg]','\delta_w [m]'},'FontName','Arial','FontSize',6);legend(hLimp(i,1),'boxoff')
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
    set(text(zeros(size(yT))-5*Xoff,yT,yL,'FontName','Arial','FontSize',6),'Parent',hLimp(i,1));
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
             'FontName','Arial','FontSize',6),'Parent',hLimp(i,2));
    dLbl={['Manual Max Values:','','',''];...
          [' ','\delta_w / H = ',num2str(1000*max(abs(dWm(:,1)+mdW)/WW(i)),4),'(x10^{-3})'];...
	      [' ','\delta_{fe} / B_e = ',num2str(1000*max(abs(dfe(:,1)-mdFE)/FEw(i)),4),'(x10^{-3})'];...
          [' ','\delta_{fw} / B_w = ',num2str(1000*max(abs(dfw(:,1)+mdFW)/FWw(i)),4),'(x10^{-3})']};
    set(text(1.5*min(get(hLimp(i,2),'Xlim')),0.25*max(get(hLimp(i,2),'Ylim')),...
             {dLbl{1};dLbl{2};dLbl{3};dLbl{4}},'EdgeColor','none',...
             'FontName','Arial','FontSize',6),'Parent',hLimp(i,2));
%     delete(hl);% only for batch printing

    for k = 1:length(ht)
        set(ht(k),'Position',[get(ht(k),'Position')].*[1,1.05,1]);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Print EPS format using printeps.m %%%
    if ~exist(svPth,'dir')
        mkdir(svPth);
    end
%     printeps(figGImp(i),strcat('G',fls{i}),svPth,'Arial')
%     printeps(figLImp(i),strcat('L',fls{i}),svPth,'Arial')
%     eval(['print -depsc2 -f' num2str(figGImp(i)) ' ' '''' horzcat(svPth,'G',fls{i},'.eps') '''' ';']);
%     eval(['print -depsc2 -f' num2str(figLImp(i)) ' ' '''' horzcat(svPth,'L',fls{i},'.eps') '''' ';']);
    eval(['print -dpng  -f' num2str(figGImp(i)) ' ' '''' horzcat(svPth,'G',fls{i},'.png') '''' ';']);
    eval(['print -dpng  -f' num2str(figLImp(i)) ' ' '''' horzcat(svPth,'L',fls{i},'.png') '''' ';']);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     
%     pause;  
end
% Close figures
if ~strcmp(questdlg('DO YOU WANT TO KEEP THE PLOTS OPEN?','????','Yes','No','No'),'Yes')
    close([figLImp(figLImp~=0),figGImp(figGImp~=0)])
end

 