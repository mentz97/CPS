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
n=25; %%number of sensors
x_sens=l_room*rand(n, 1);
y_sens=l_room*rand(n, 1);
figure(1)
make_grid(xg,yg,x_sens,y_sens);
hold on

r=4;
Q=make_Q_rand(n,r,x_sens,y_sens);
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
x_ref=zeros(100,1);
y_ref=zeros(100,1);

for k=1:p
    k_n=k-1; % matlab fa partire i cicli da 1 mannaggia a lui
    x_ref(k)=fix(k_n/10)+l_p/2;
    y_ref(k)=mod(k_n, 10)+l_p/2;
    
    for i=1:n
        d=norm([x_ref(k), y_ref(k)]-[x_sens(i), y_sens(i)]);
        if d<=8
            Rss=Pt-40.2-20*log10(d)+dev_stand*randn();
        else
            Rss=Pt-58.5-33*log10(d)+dev_stand*randn();
        end
        A(i, k)=Rss;
    end
    
end

figure(1)
plot(x_ref, y_ref,'.g');

%% Runtime Phase
figure()
make_grid(xg, yg, x_sens, y_sens);
hold on

ni=50; %%number of iterations

for i=1:ni
    x_measured=x_ref(ceil(p*rand()));
    y_measured=x_ref(ceil(p*rand()));
    p1=plot(x_measured, y_measured, 'sb', 'MarkerSize', 10);
    y=zeros(n, 1);
    for j=1:n
        d=norm([x_measured, y_measured]-[x_sens(j), y_sens(j)]);
        if d<=8
            y(j)=Pt-40.2-20*log10(d)+dev_stand*randn();
        else
            y(j)=Pt-58.5-33*log10(d)+dev_stand*randn();
        end
    end
    u_A=mutual_coherence(A);
    [Om, Yp]=reduce_coherence(A, y);
    u_Om=mutual_coherence(Om);
    %to_do -> implement IST
    pause()
    delete(p1)
end