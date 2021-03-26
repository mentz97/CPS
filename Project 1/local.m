%% project modeling and control - localization
clear all
close all
clc

%% map
l_room=10; 
l_p=1;
p=100;

xg = 0:1:10;
yg = 0:1:10;

uniform=1; %%1->usiamo i sensori distribuiti in maniera uniforme, 0-> usiamo la grid topology

%% sensors uniformly distribuited 
if uniform==1
n=25;
x=l_room*rand(n, 1);
y=l_room*rand(n, 1);
figure(1)
make_grid(xg,yg,x,y);
hold on

r=4;
Q=make_Q_rand(n,r,x,y);
end

%% sensors grid topology ...
if uniform==0
%%...
end

%% check connettivity
G=graph(Q);
figure(2)
plot(G)
eigenvalue=sort(abs(eig(Q)))

%% build A
Pt=25;
dev_stand=0.5;
var=0.5^2;

for k=1:p
    k_n=k-1; % matlab fa partire i cicli da 1 mannaggia a lui
    x_broad=fix(k_n/10)+l_p/2;
    y_broad=mod(k_n, 10)+l_p/2;
    figure(1)
    pl=plot(x_broad, y_broad,'.g');
    
    for i=1:n
        d=norm([x_broad, y_broad]-[x(i), y(i)]);
        if d<=8
            Rss=Pt-40.2-20*log10(d)+dev_stand*randn();
        else
            Rss=Pt-58.5-33*log10(d)+dev_stand*randn();
        end
        A(i, k)=Rss;
    end
    
    pause()
    delete(pl);
end
