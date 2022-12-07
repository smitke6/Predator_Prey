clear;clc;close all;



it=200;
gridsize=1;

num_in_prey=100;
velocity_prey=0.02;
prey_re=0.1;
prey_die=0.00;
prey_neighbors=3;
prey_neighbors_dis=0.05;

num_in_pred=100;
velocity_pred=0.025;
pred_re=0.50;
pred_die=0.03;
pred_neighbors=5;
pred_neighbors_dis=0.05;

eat_dis=0.02;
see_dis=0.6;


prey=zeros(num_in_prey,3,2);
prey(:,1:2,1)=rand(gridsize,num_in_prey,2);
prey(:,3,1)=2*pi*rand(1,num_in_prey);

pred=zeros(num_in_pred,4,2);
pred(:,1:2,1)=rand(gridsize,num_in_pred,2);
pred(:,3,1)=2*pi*rand(1,num_in_pred);
pred(:,4,1)=[ones(num_in_pred/2,1);zeros(num_in_pred/2,1)];%binornd(1,0.5,[1 num_in_pred]);

% plot(prey(:,1,1),prey(:,2,1),'o',...
%     'MarkerSize',10,...
%     'MarkerEdgeColor','b',...
%     'MarkerFaceColor','b')
% hold on
% plot(pred(:,1,1),pred(:,2,1),'o',...
%     'MarkerSize',10,...
%     'MarkerEdgeColor','r',...
%     'MarkerFaceColor','r')
% axis([-0.5 1.5 -0.5 1.5])
% hold off
% pause(0.5);

num_pred0_sum(1)=length(find(pred(:,4,1)==0));
num_pred1_sum(1)=length(find(pred(:,4,1)==1));
num_prey_sum(1)=length(prey(:,1,1));

for ti=2:it
    
    if 1-isempty(pred)
        num_pred=length(pred(:,1,ti-1));
        
        pred = pred(randperm(num_pred), :,:);
    else
        num_pred=0;
    end
    
    Delete_pred = zeros(1,1);
    
    dd=1;
    
    
    
    if num_pred>0
        for i=1:num_pred
            Delete_prey = 0;dy=1;
            
            if 1-isempty(prey)
                num_prey=length(prey(:,1,ti-1));
            else
                num_prey=0;
            end
            
            if num_prey>0
                dis_pred_prey=((prey(:,1,ti-1)-pred(i,1,ti-1)*ones(num_prey,1)).^2+...
                    (prey(:,2,ti-1)-pred(i,2,ti-1)*ones(num_prey,1)).^2).^0.5;
                [min_dis,jj]=min(dis_pred_prey);
            else
                min_dis=  see_dis+1;
                
            end
            
            
            dis_pred_pred=((pred(1:num_pred,1,ti-1)-pred(i,1,ti-1)*ones(num_pred,1)).^2+...
                (pred(1:num_pred,2,ti-1)-pred(i,2,ti-1)*ones(num_pred,1)).^2).^0.5;
            [pred_dis,kk]=find(dis_pred_pred<=pred_neighbors_dis);
            
            e=2;
            cor_xy=[1,1,1,-1]/4*e;
            cor_xz=[1,1,1,-1]/4*(8-e^2)^0.5;
            ci=binornd(1,0.5);
            cj=binornd(1,0.5);
            ck=binornd(1,0.5);
            h_xy=-(-1)^binornd(1,(1+cor_xy(1+ci+2*cj))/2);
            h_xz=-(-1)^binornd(1,(1+cor_xz(1+ci+2*ck))/2);
            
            
            if min_dis <= eat_dis && (((-1)^(ci*cj)*h_xy==1&&pred(i,4,ti-1)==0)||((-1)^(ci*ck)*h_xz==1&&pred(i,4,ti-1)==1))
                
                %pred(i,1:2,ti)=pred(i,1:2,ti-1);
                %pred(i,3,ti)=pred(i,3,ti-1)+ pi*(rand(1)-1/2);
                %pred(i,4,ti)=pred(i,4,ti-1);
                Delete_prey(dy) = jj;
                dy=dy+1;
                
                if rand <= pred_re && length(pred_dis)<=pred_neighbors
                    pred(end+1,1:2,ti)=pred(i,1:2,ti-1);
                    pred(end,3,ti)=2*pi*rand(1);
                    pred(end,1:2,ti-1)=pred(i,1:2,ti-1);
                    pred(end,4,ti-1:ti)=pred(i,4,ti-1);
                    
                end
                
            elseif min_dis+1 <= see_dis
                
                pred(i,3,ti)=atan2(prey(jj,2,ti-1)-pred(i,2,ti-1),prey(jj,1,ti-1)-pred(i,1,ti-1))+...
                    1/2*pi*(rand(1)-1/2);
                pred(i,1,ti)=pred(i,1,ti-1)+ velocity_pred*cos(pred(i,3,ti));
                pred(i,2,ti)=pred(i,2,ti-1)+ velocity_pred*sin(pred(i,3,ti));
                
            end
            
            pred(i,3,ti)=pred(i,3,ti-1)+ 2*pi*(rand(1)-1/2);
            pred(i,4,ti)=pred(i,4,ti-1);
            pred(i,1,ti)=pred(i,1,ti-1)+ velocity_pred*cos(pred(i,3,ti));
            
            if pred(i,1,ti)<0
                
                pred(i,1,ti)=1+pred(i,1,ti);
                
            elseif pred(i,1,ti)>1
                
                pred(i,1,ti)=-1+pred(i,1,ti);
                
            end
            
            pred(i,2,ti)=pred(i,2,ti-1)+ velocity_pred*sin(pred(i,3,ti));
            
            if pred(i,2,ti)<0
                
                pred(i,2,ti)=1+pred(i,2,ti);
                
            elseif pred(i,2,ti)>1
                
                pred(i,2,ti)=-1+pred(i,2,ti);
                
            end
            
            
            
            
            if rand <= pred_die
                
                Delete_pred(dd) = i;
                dd=dd+1;
            end
            
            if Delete_prey(1)>0
                prey(Delete_prey, :,:) = [];
            end
        end
    end
    
    if Delete_pred(1)>0
        pred(Delete_pred, :,:) = [];
    end
    
    if 1-isempty(prey)
        num_prey_stay=length(prey(:,1,ti-1));
    else
        num_prey_stay=0;
    end
    
    Delete_prey2 = 0;dy=1;
    
    if num_prey_stay>0
        
        for i=1:num_prey_stay
            
            
            dis_prey_prey=((prey(1:num_prey_stay,1,ti-1)-prey(i,1,ti-1)*ones(num_prey_stay,1)).^2+...
                (prey(1:num_prey_stay,2,ti-1)-prey(i,2,ti-1)*ones(num_prey_stay,1)).^2).^0.5;
            [prey_dis,jj]=find(dis_prey_prey<=prey_neighbors_dis);
            
            if length(prey_dis)>=prey_neighbors
                
            elseif rand <= prey_re
                prey(i,1:3,ti)=prey(i,1:3,ti-1);
                
                prey(end+1,1:2,ti)=prey(i,1:2,ti);
                prey(end,3,ti)=2*pi*rand(1);
                prey(end,1:2,ti-1)=prey(i,1:2,ti);
            end
            
            if rand <= prey_die
                
                Delete_prey2(dy) = i;
                dy=dy+1;
                
            else
                prey(i,3,ti)=prey(i,3,ti-1)+ 2*pi*(rand(1)-1/2);
                
                prey(i,1,ti)=prey(i,1,ti-1)+velocity_prey*cos(prey(i,3,ti));
                
                if prey(i,1,ti)<0
                    
                    prey(i,1,ti)=1+prey(i,1,ti);
                    
                elseif prey(i,1,ti)>1
                    
                    prey(i,1,ti)=-1+prey(i,1,ti);
                    
                end
                
                prey(i,2,ti)=prey(i,2,ti-1)+velocity_prey*sin(prey(i,3,ti));
                
                if prey(i,2,ti)<0
                    
                    prey(i,2,ti)=1+prey(i,2,ti);
                    
                elseif prey(i,2,ti)>1
                    
                    prey(i,2,ti)=-1+prey(i,2,ti);
                    
                end
                
                
            end
            
        end
    end
    
    if Delete_prey2(1)>0
        prey(Delete_prey2, :,:) = [];
    end
    
    
    if 1-isempty(pred)
        p0=find(pred(:,4,ti-1)==0);
        num_pred0_sum(ti)=length(p0);
        p1=find(pred(:,4,ti-1)==1);
        num_pred1_sum(ti)=length(p1);
        
    else
        num_pred0_sum(ti)=0;
        num_pred1_sum(ti)=0;
    end
    if 1-isempty(prey)
        num_prey_sum(ti)=length(prey(:,1,ti-1));
        
    else
        num_prey_sum(ti)=0;
    end
    
    hold off
    
    if num_pred0_sum(ti)>0
        plot(pred(p0,1,ti-1),pred(p0,2,ti-1),'o',...
            'MarkerSize',4,...
            'MarkerEdgeColor',[1,0.3,0.3],...
            'MarkerFaceColor',[1,0.3,0.3])
        hold on
        
        plot(pred(p0,1,ti),pred(p0,2,ti),'o',...
            'MarkerSize',6,...
            'MarkerEdgeColor','r',...
            'MarkerFaceColor','r')
        
    end
    
    if num_pred1_sum(ti)>0
        plot(pred(p1,1,ti-1),pred(p1,2,ti-1),'o',...
            'MarkerSize',4,...
            'MarkerEdgeColor',[0.3,1,0.3],...
            'MarkerFaceColor',[0.3,1,0.3])
        hold on
        
        plot(pred(p1,1,ti),pred(p1,2,ti),'o',...
            'MarkerSize',6,...
            'MarkerEdgeColor','g',...
            'MarkerFaceColor','g')
        
    end
    
    if num_prey_sum(ti)
        plot(prey(:,1,ti-1),prey(:,2,ti-1),'o',...
            'MarkerSize',4,...
            'MarkerEdgeColor',[0.3,0.3,1],...
            'MarkerFaceColor',[0.3,0.3,1])
        hold on
        plot(prey(:,1,ti),prey(:,2,ti),'o',...
            'MarkerSize',6,...
            'MarkerEdgeColor','b',...
            'MarkerFaceColor','b')
    end
    axis([-0.2 1.2 -0.2 1.2])
    axis equal
    pause(0.1);
    hold off
    
    ti
    
end

figure (2)
time=1:ti;%484;%360;%;
plot(time,num_pred0_sum,'r',time,num_pred1_sum,'g',time,num_prey_sum,'b');
